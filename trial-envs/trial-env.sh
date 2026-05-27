#!/usr/bin/env bash
#
# trial-env.sh — Manage Paperless-ngx trial environments
#
# Usage:
#   ./trial-env.sh create  <org-name> [--port PORT] [--password PASSWORD]
#   ./trial-env.sh delete  <org-name> [--keep-data]
#   ./trial-env.sh list
#   ./trial-env.sh status  <org-name>
#   ./trial-env.sh stop    <org-name>
#   ./trial-env.sh start   <org-name>
#   ./trial-env.sh logs    <org-name> [--follow]
#   ./trial-env.sh info    <org-name>
#
# Each organization gets a fully isolated Paperless-ngx stack
# (PostgreSQL + Redis + Paperless) on a unique port.
#

set -euo pipefail

# ─── Configuration ───────────────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
ENVS_DIR="${SCRIPT_DIR}/instances"
COMPOSE_TEMPLATE="${SCRIPT_DIR}/docker-compose.trial.yml"
REGISTRY_FILE="${SCRIPT_DIR}/registry.json"
PORT_RANGE_START=8100
PORT_RANGE_END=8999
DEFAULT_ADMIN_USER="admin"
DEFAULT_ADMIN_PASSWORD="changeme123"

# The webserver MUST run the image built from this fork's own Dockerfile.
# The upstream ghcr.io/paperless-ngx/paperless-ngx image ships the vanilla UI
# and shows none of the fork's UI changes (logo, RTL, ar-AR bundle, app title).
PAPERLESS_IMAGE_DEFAULT="paperless-ngx:local"

# ─── Colors ──────────────────────────────────────────────────────────────────

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# ─── Helper Functions ────────────────────────────────────────────────────────

log_info()    { echo -e "${BLUE}ℹ${NC}  $*"; }
log_success() { echo -e "${GREEN}✔${NC}  $*"; }
log_warn()    { echo -e "${YELLOW}⚠${NC}  $*"; }
log_error()   { echo -e "${RED}✖${NC}  $*" >&2; }

die() { log_error "$@"; exit 1; }

# Validate org name: lowercase alphanumeric + hyphens, 2-40 chars
validate_org_name() {
    local name="$1"
    if [[ ! "$name" =~ ^[a-z0-9][a-z0-9-]{0,38}[a-z0-9]$ ]] && [[ ! "$name" =~ ^[a-z0-9]{1,2}$ ]]; then
        die "Invalid org name '${name}'. Use lowercase letters, numbers, and hyphens (2-40 chars)."
    fi
}

# Generate a random secret key
generate_secret_key() {
    python3 -c "import secrets; print(secrets.token_urlsafe(48))" 2>/dev/null \
        || openssl rand -base64 48 2>/dev/null \
        || head -c 48 /dev/urandom | base64
}

# Initialize registry file if it doesn't exist
init_registry() {
    if [[ ! -f "$REGISTRY_FILE" ]]; then
        echo '{}' > "$REGISTRY_FILE"
    fi
}

# Read from registry (requires jq)
registry_get() {
    local key="$1"
    jq -r ".[\"${key}\"] // empty" "$REGISTRY_FILE" 2>/dev/null
}

# Write to registry
registry_set() {
    local key="$1"
    local value="$2"
    local tmp
    tmp=$(mktemp)
    jq --arg k "$key" --argjson v "$value" '.[$k] = $v' "$REGISTRY_FILE" > "$tmp"
    mv "$tmp" "$REGISTRY_FILE"
}

# Remove from registry
registry_delete() {
    local key="$1"
    local tmp
    tmp=$(mktemp)
    jq --arg k "$key" 'del(.[$k])' "$REGISTRY_FILE" > "$tmp"
    mv "$tmp" "$REGISTRY_FILE"
}

# Find next available port
find_available_port() {
    init_registry
    local used_ports
    used_ports=$(jq -r '.[].port // empty' "$REGISTRY_FILE" 2>/dev/null | sort -n)

    for port in $(seq "$PORT_RANGE_START" "$PORT_RANGE_END"); do
        if ! echo "$used_ports" | grep -q "^${port}$"; then
            # Also check if something else is using the port
            if ! lsof -i ":${port}" &>/dev/null; then
                echo "$port"
                return 0
            fi
        fi
    done
    die "No available ports in range ${PORT_RANGE_START}-${PORT_RANGE_END}"
}

# Get the docker compose command for an org
compose_cmd() {
    local org_name="$1"
    local env_dir="${ENVS_DIR}/${org_name}"
    echo "docker compose --project-name paperless-trial-${org_name} -f ${env_dir}/docker-compose.yml"
}

# Check if org environment exists
env_exists() {
    local org_name="$1"
    [[ -d "${ENVS_DIR}/${org_name}" ]]
}

# Check whether an image is present in the local Docker daemon
image_exists() {
    docker image inspect "$1" &>/dev/null
}

# ─── Build provenance ────────────────────────────────────────────────────────
# Nothing in create/update ever compiles code: they start containers from an
# image that already exists locally. The image can therefore be far older than
# the source tree with no visible error at all. Record the revision at build
# time and compare it before starting, so a stale image is reported instead of
# silently serving out-of-date UI.

current_revision() {
    git -C "$REPO_ROOT" rev-parse --short HEAD 2>/dev/null || true
}

current_dirty() {
    if [[ -n "$(git -C "$REPO_ROOT" status --porcelain -- src src-ui Dockerfile 2>/dev/null)" ]]; then
        echo "yes"
    else
        echo "no"
    fi
}

image_label() {
    docker image inspect "$1" \
        --format "{{ index .Config.Labels \"$2\" }}" 2>/dev/null || true
}

# Warn (never block) when the image does not match the working tree
check_image_freshness() {
    local image="$1"
    local built_rev head_rev
    built_rev=$(image_label "$image" "paperless.fork.revision")
    head_rev=$(current_revision)

    if [[ -z "$built_rev" ]]; then
        log_warn "Image '${image}' records no source revision (built before provenance tracking)."
        log_warn "Rebuild if it predates your latest changes:"
        log_warn "  docker build -t ${image} ${REPO_ROOT} && $0 update <org>"
        return 0
    fi

    if [[ -n "$head_rev" && "$built_rev" != "$head_rev" ]]; then
        log_warn "Image '${image}' was built from ${built_rev}, but HEAD is ${head_rev}."
        log_warn "Rebuild:"
        log_warn "  docker build -t ${image} ${REPO_ROOT} && $0 update <org>"
        return 0
    fi

    if [[ "$(image_label "$image" "paperless.fork.dirty")" == "no" && "$(current_dirty)" == "yes" ]]; then
        log_warn "Image '${image}' was built from a clean tree, but src/ or src-ui/ has uncommitted changes."
        log_warn "Rebuild:"
        log_warn "  docker build -t ${image} ${REPO_ROOT} && $0 update <org>"
    fi
}

# Build the fork image from the repo root Dockerfile, stamping its provenance
build_fork_image() {
    local image="$1"
    local rev dirty
    rev=$(current_revision)
    dirty=$(current_dirty)

    log_info "Building '${image}' from ${REPO_ROOT} (this can take several minutes)..."
    docker build \
        --label "paperless.fork.revision=${rev}" \
        --label "paperless.fork.dirty=${dirty}" \
        -t "$image" "$REPO_ROOT"
    log_success "Built '${image}' from revision ${rev:-unknown} (uncommitted changes at build time: ${dirty})."
    log_warn "Existing environments still run the old image — recreate them with: $0 update <org>"
}

# Fail loudly when the fork image is missing instead of silently running the
# upstream image, which would show a stock UI in the trial environment.
require_image() {
    local image="$1"
    image_exists "$image" && return 0

    echo "" >&2
    log_error "Image '${image}' not found locally."
    echo "" >&2
    echo -e "  The trial stack must run this fork's own image. The upstream" >&2
    echo -e "  ghcr.io/paperless-ngx/paperless-ngx image contains the vanilla UI" >&2
    echo -e "  and drops all fork UI changes (logo, RTL styles, ar-AR bundle)." >&2
    echo "" >&2
    echo -e "  Build it with:" >&2
    echo -e "    ${BOLD}docker build -t ${image} ${REPO_ROOT}${NC}" >&2
    echo -e "  or re-run with ${BOLD}--build${NC} to build it automatically." >&2
    echo "" >&2
    exit 1
}

# ─── Commands ────────────────────────────────────────────────────────────────

cmd_create() {
    local org_name=""
    local port=""
    local password="${DEFAULT_ADMIN_PASSWORD}"
    local admin_user="${DEFAULT_ADMIN_USER}"
    local image="${PAPERLESS_IMAGE_DEFAULT}"
    local do_build=false

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --port)     port="$2"; shift 2 ;;
            --password) password="$2"; shift 2 ;;
            --user)     admin_user="$2"; shift 2 ;;
            --image)    image="$2"; shift 2 ;;
            --build)    do_build=true; shift ;;
            -*)         die "Unknown option: $1" ;;
            *)          org_name="$1"; shift ;;
        esac
    done

    [[ -z "$org_name" ]] && die "Usage: $0 create <org-name> [--port PORT] [--password PASSWORD] [--user USER] [--image IMAGE] [--build]"
    validate_org_name "$org_name"

    # Check for jq dependency
    command -v jq &>/dev/null || die "jq is required. Install it: brew install jq"

    init_registry

    # Check if already exists
    if env_exists "$org_name"; then
        die "Environment for '${org_name}' already exists. Delete it first or choose a different name."
    fi

    # Auto-assign port if not specified
    if [[ -z "$port" ]]; then
        port=$(find_available_port)
    fi

    # The webserver must run the fork image, otherwise the trial env shows the
    # stock upstream UI (no logo, RTL styles, or ar-AR bundle).
    if [[ "$do_build" == true ]]; then
        build_fork_image "$image"
    fi
    require_image "$image"
    check_image_freshness "$image"

    local secret_key
    secret_key=$(generate_secret_key)
    local env_dir="${ENVS_DIR}/${org_name}"

    echo ""
    echo -e "${BOLD}${CYAN}━━━ Creating Trial Environment ━━━${NC}"
    echo -e "  Organization:  ${BOLD}${org_name}${NC}"
    echo -e "  Web Port:      ${BOLD}${port}${NC}"
    echo -e "  Image:         ${BOLD}${image}${NC}"
    echo -e "  Admin User:    ${BOLD}${admin_user}${NC}"
    echo -e "  Admin Password:${BOLD} ${password}${NC}"
    echo ""

    # Create instance directory
    mkdir -p "$env_dir"

    # Generate .env file for this instance
    cat > "${env_dir}/.env" <<EOF
# Trial environment for: ${org_name}
# Created: $(date -u '+%Y-%m-%dT%H:%M:%SZ')

ORG_NAME=${org_name}
WEB_PORT=${port}
PAPERLESS_IMAGE=${image}
PAPERLESS_SECRET_KEY=${secret_key}
PAPERLESS_ADMIN_USER=${admin_user}
PAPERLESS_ADMIN_PASSWORD=${password}
EOF

    # Copy compose template
    cp "$COMPOSE_TEMPLATE" "${env_dir}/docker-compose.yml"

    # Register this environment
    registry_set "$org_name" "$(cat <<EOF
{
    "org_name": "${org_name}",
    "port": ${port},
    "admin_user": "${admin_user}",
    "admin_password": "${password}",
    "created_at": "$(date -u '+%Y-%m-%dT%H:%M:%SZ')",
    "status": "starting"
}
EOF
)"

    # Start the environment
    log_info "Pulling images (first time may take a few minutes)..."
    (cd "$env_dir" && docker compose --project-name "paperless-trial-${org_name}" up -d --pull missing)

    # Update status in registry
    registry_set "$org_name" "$(jq -r ".[\"${org_name}\"] | .status = \"running\"" "$REGISTRY_FILE")"

    echo ""
    echo -e "${GREEN}${BOLD}━━━ Environment Ready! ━━━${NC}"
    echo ""
    echo -e "  ${BOLD}URL:${NC}       http://localhost:${port}"
    echo -e "  ${BOLD}Username:${NC}  ${admin_user}"
    echo -e "  ${BOLD}Password:${NC}  ${password}"
    echo ""
    echo -e "  ${CYAN}Note:${NC} First startup may take 1-2 minutes for DB migrations."
    echo -e "  ${CYAN}Logs:${NC} $0 logs ${org_name} --follow"
    echo ""
    log_success "Trial environment '${org_name}' created successfully!"
}

cmd_delete() {
    local org_name=""
    local keep_data=false

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --keep-data) keep_data=true; shift ;;
            -*)          die "Unknown option: $1" ;;
            *)           org_name="$1"; shift ;;
        esac
    done

    [[ -z "$org_name" ]] && die "Usage: $0 delete <org-name> [--keep-data]"
    validate_org_name "$org_name"
    init_registry

    if ! env_exists "$org_name"; then
        die "Environment for '${org_name}' does not exist."
    fi

    local env_dir="${ENVS_DIR}/${org_name}"

    echo ""
    echo -e "${YELLOW}${BOLD}━━━ Deleting Trial Environment: ${org_name} ━━━${NC}"
    echo ""

    # Stop and remove containers
    log_info "Stopping containers..."
    (cd "$env_dir" && docker compose --project-name "paperless-trial-${org_name}" down)

    if [[ "$keep_data" == false ]]; then
        # Remove volumes
        log_info "Removing Docker volumes..."
        (cd "$env_dir" && docker compose --project-name "paperless-trial-${org_name}" down -v) 2>/dev/null || true
    else
        log_warn "Keeping Docker volumes (use 'docker volume ls' to see them)"
    fi

    # Remove instance directory
    log_info "Removing instance directory..."
    rm -rf "$env_dir"

    # Remove from registry
    registry_delete "$org_name"

    echo ""
    log_success "Trial environment '${org_name}' deleted."
}

cmd_list() {
    init_registry

    local count
    count=$(jq 'length' "$REGISTRY_FILE" 2>/dev/null || echo "0")

    echo ""
    echo -e "${BOLD}${CYAN}━━━ Trial Environments ━━━${NC}"
    echo ""

    if [[ "$count" -eq 0 ]]; then
        echo -e "  ${YELLOW}No trial environments found.${NC}"
        echo -e "  Create one with: ${BOLD}$0 create <org-name>${NC}"
        echo ""
        return
    fi

    # Table header
    printf "  ${BOLD}%-20s %-7s %-12s %-12s %-24s${NC}\n" "ORGANIZATION" "PORT" "STATUS" "ADMIN" "CREATED"
    printf "  %-20s %-7s %-12s %-12s %-24s\n" "────────────────────" "───────" "────────────" "────────────" "────────────────────────"

    # Table rows
    jq -r 'to_entries[] | "\(.value.org_name)\t\(.value.port)\t\(.value.admin_user)\t\(.value.created_at)"' "$REGISTRY_FILE" 2>/dev/null | \
    while IFS=$'\t' read -r name port admin created; do
        # Check actual container status
        local status
        if docker ps --filter "name=paperless-trial-${name}-web" --format '{{.Status}}' 2>/dev/null | grep -q "Up"; then
            status="${GREEN}running${NC}"
        else
            status="${RED}stopped${NC}"
        fi
        printf "  %-20s %-7s %-23b %-12s %-24s\n" "$name" "$port" "$status" "$admin" "$created"
    done

    echo ""
    echo -e "  ${CYAN}Total: ${count} environment(s)${NC}"
    echo ""
}

cmd_status() {
    local org_name="$1"
    [[ -z "$org_name" ]] && die "Usage: $0 status <org-name>"
    validate_org_name "$org_name"

    if ! env_exists "$org_name"; then
        die "Environment for '${org_name}' does not exist."
    fi

    local env_dir="${ENVS_DIR}/${org_name}"

    echo ""
    echo -e "${BOLD}${CYAN}━━━ Status: ${org_name} ━━━${NC}"
    echo ""
    (cd "$env_dir" && docker compose --project-name "paperless-trial-${org_name}" ps)
    echo ""
}

cmd_stop() {
    local org_name="$1"
    [[ -z "$org_name" ]] && die "Usage: $0 stop <org-name>"
    validate_org_name "$org_name"

    if ! env_exists "$org_name"; then
        die "Environment for '${org_name}' does not exist."
    fi

    local env_dir="${ENVS_DIR}/${org_name}"

    log_info "Stopping '${org_name}'..."
    (cd "$env_dir" && docker compose --project-name "paperless-trial-${org_name}" stop)
    log_success "Environment '${org_name}' stopped."
}

cmd_start() {
    local org_name="$1"
    [[ -z "$org_name" ]] && die "Usage: $0 start <org-name>"
    validate_org_name "$org_name"

    if ! env_exists "$org_name"; then
        die "Environment for '${org_name}' does not exist."
    fi

    local env_dir="${ENVS_DIR}/${org_name}"

    log_info "Starting '${org_name}'..."
    (cd "$env_dir" && docker compose --project-name "paperless-trial-${org_name}" up -d)
    log_success "Environment '${org_name}' started."
}

cmd_update() {
    local org_name=""
    local do_build=false

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --build) do_build=true; shift ;;
            -*)      die "Unknown option: $1" ;;
            *)       org_name="$1"; shift ;;
        esac
    done

    [[ -z "$org_name" ]] && die "Usage: $0 update <org-name> [--build]"
    validate_org_name "$org_name"

    if ! env_exists "$org_name"; then
        die "Environment for '${org_name}' does not exist."
    fi

    local env_dir="${ENVS_DIR}/${org_name}"

    # Keep this instance's own .env (port, admin, secret key) but refresh the
    # compose file from the template so it picks up stack changes.
    log_info "Refreshing compose file for '${org_name}' from template..."
    cp "$COMPOSE_TEMPLATE" "${env_dir}/docker-compose.yml"

    # Resolve the image recorded for this instance, falling back to the default
    # for instances created before images were tracked in .env
    local image
    image=$(grep -E '^PAPERLESS_IMAGE=' "${env_dir}/.env" 2>/dev/null | cut -d= -f2-)
    image="${image:-${PAPERLESS_IMAGE_DEFAULT}}"

    if [[ "$do_build" == true ]]; then
        build_fork_image "$image"
    fi
    require_image "$image"
    check_image_freshness "$image"

    log_info "Recreating containers for '${org_name}' on '${image}' (data volumes preserved)..."
    (cd "$env_dir" && docker compose --project-name "paperless-trial-${org_name}" up -d --force-recreate)

    log_success "Environment '${org_name}' updated."
    echo -e "  ${CYAN}Hard-refresh the browser (Cmd+Shift+R) to drop cached UI assets.${NC}"
}

cmd_logs() {
    local org_name=""
    local follow=""

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --follow|-f) follow="-f"; shift ;;
            -*)          die "Unknown option: $1" ;;
            *)           org_name="$1"; shift ;;
        esac
    done

    [[ -z "$org_name" ]] && die "Usage: $0 logs <org-name> [--follow]"
    validate_org_name "$org_name"

    if ! env_exists "$org_name"; then
        die "Environment for '${org_name}' does not exist."
    fi

    local env_dir="${ENVS_DIR}/${org_name}"
    (cd "$env_dir" && docker compose --project-name "paperless-trial-${org_name}" logs $follow)
}

cmd_info() {
    local org_name="$1"
    [[ -z "$org_name" ]] && die "Usage: $0 info <org-name>"
    validate_org_name "$org_name"
    init_registry

    if ! env_exists "$org_name"; then
        die "Environment for '${org_name}' does not exist."
    fi

    local info
    info=$(registry_get "$org_name")

    if [[ -z "$info" ]]; then
        die "No registry entry for '${org_name}'."
    fi

    local port admin_user admin_pass created
    port=$(echo "$info" | jq -r '.port')
    admin_user=$(echo "$info" | jq -r '.admin_user')
    admin_pass=$(echo "$info" | jq -r '.admin_password')
    created=$(echo "$info" | jq -r '.created_at')

    # Check container status
    local status
    if docker ps --filter "name=paperless-trial-${org_name}-web" --format '{{.Status}}' 2>/dev/null | grep -q "Up"; then
        status="${GREEN}running${NC}"
    else
        status="${RED}stopped${NC}"
    fi

    echo ""
    echo -e "${BOLD}${CYAN}━━━ Environment Info: ${org_name} ━━━${NC}"
    echo ""
    echo -e "  ${BOLD}Organization:${NC}   ${org_name}"
    echo -e "  ${BOLD}Status:${NC}         ${status}"
    echo -e "  ${BOLD}URL:${NC}            http://localhost:${port}"
    echo -e "  ${BOLD}Port:${NC}           ${port}"
    echo -e "  ${BOLD}Admin User:${NC}     ${admin_user}"
    echo -e "  ${BOLD}Admin Password:${NC} ${admin_pass}"
    echo -e "  ${BOLD}Created:${NC}        ${created}"
    echo ""
    echo -e "  ${CYAN}Containers:${NC}"
    docker ps --filter "name=paperless-trial-${org_name}" --format "    {{.Names}}\t{{.Status}}" 2>/dev/null || echo "    (none running)"
    echo ""
}

cmd_help() {
    echo ""
    echo -e "${BOLD}${CYAN}Paperless-ngx Trial Environment Manager${NC}"
    echo ""
    echo -e "${BOLD}USAGE:${NC}"
    echo "  $0 <command> [arguments] [options]"
    echo ""
    echo -e "${BOLD}COMMANDS:${NC}"
    echo "  create  <org-name>   Create and start a new trial environment"
    echo "  delete  <org-name>   Stop and remove a trial environment"
    echo "  update  <org-name>   Refresh an environment from the template and recreate it"
    echo "                       (add --build to rebuild the image first)"
    echo "  list                 List all trial environments"
    echo "  status  <org-name>   Show container status for an environment"
    echo "  start   <org-name>   Start a stopped environment"
    echo "  stop    <org-name>   Stop a running environment"
    echo "  logs    <org-name>   View logs for an environment"
    echo "  info    <org-name>   Show full connection info for an environment"
    echo ""
    echo -e "${BOLD}CREATE OPTIONS:${NC}"
    echo "  --port PORT          Set specific port (default: auto-assigned from ${PORT_RANGE_START}-${PORT_RANGE_END})"
    echo "  --password PASSWORD  Set admin password (default: ${DEFAULT_ADMIN_PASSWORD})"
    echo "  --user USER          Set admin username (default: ${DEFAULT_ADMIN_USER})"
    echo "  --image IMAGE        Set webserver image (default: ${PAPERLESS_IMAGE_DEFAULT})"
    echo "  --build              Build the fork image from the repo Dockerfile first"
    echo ""
    echo -e "${BOLD}DELETE OPTIONS:${NC}"
    echo "  --keep-data          Keep Docker volumes (don't destroy data)"
    echo ""
    echo -e "${BOLD}EXAMPLES:${NC}"
    echo "  $0 create acme-corp"
    echo "  $0 create beta-client --port 8150 --password 's3cur3!'"
    echo "  $0 list"
    echo "  $0 info acme-corp"
    echo "  $0 delete acme-corp"
    echo ""
    echo -e "${BOLD}REQUIREMENTS:${NC}"
    echo "  - Docker & Docker Compose"
    echo "  - jq (brew install jq)"
    echo "  - The fork image '${PAPERLESS_IMAGE_DEFAULT}' built from the repo Dockerfile,"
    echo "    otherwise the upstream image serves a stock UI."
    echo ""
}

# ─── Main ────────────────────────────────────────────────────────────────────

main() {
    # Ensure instances directory exists
    mkdir -p "$ENVS_DIR"

    local command="${1:-help}"
    shift 2>/dev/null || true

    case "$command" in
        create)  cmd_create "$@" ;;
        delete)  cmd_delete "$@" ;;
        list)    cmd_list ;;
        status)  cmd_status "${1:-}" ;;
        start)   cmd_start "${1:-}" ;;
        stop)    cmd_stop "${1:-}" ;;
        update)  cmd_update "$@" ;;
        logs)    cmd_logs "$@" ;;
        info)    cmd_info "${1:-}" ;;
        help|-h|--help) cmd_help ;;
        *)       die "Unknown command: $command. Run '$0 help' for usage." ;;
    esac
}

main "$@"
