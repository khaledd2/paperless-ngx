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
#   ./trial-env.sh backup  <org-name> [--output DIR] [--include-data]
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

# Scratch directory for an in-progress backup; an EXIT trap removes it
BACKUP_STAGING=""

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

# Read a KEY=value out of an instance .env. A missing key yields an empty
# string instead of tripping `set -e` the way a bare grep pipeline would.
env_value() {
    local file="$1"
    local key="$2"
    local line
    line=$(grep -E "^${key}=" "$file" 2>/dev/null || true)
    printf '%s' "${line#*=}"
}

container_running() {
    [[ "$(docker inspect -f '{{.State.Running}}' "$1" 2>/dev/null)" == "true" ]]
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
    image=$(env_value "${env_dir}/.env" "PAPERLESS_IMAGE")
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

# ─── Backup ──────────────────────────────────────────────────────────────────
# A stopped PostgreSQL volume is not a portable backup, so the database dump
# always comes from the live container. The file volumes are read directly
# through a throwaway container built from the database image, so a stopped
# environment can still have its documents archived.

# Ask Compose which Docker volume backs a named volume of an org's stack
compose_volume_name() {
    local project="$1"
    local vol="$2"
    local matches
    matches=$(docker volume ls \
        --filter "label=com.docker.compose.project=${project}" \
        --filter "label=com.docker.compose.volume=${vol}" \
        --format '{{.Name}}' 2>/dev/null || true)
    printf '%s' "${matches%%$'\n'*}"
}

# Copy a Docker volume's contents onto the host through a throwaway container
copy_volume_to_host() {
    local volume="$1"
    local dest="$2"
    local image="$3"

    mkdir -p "$dest"
    docker run --rm \
        --entrypoint sh \
        -v "${volume}:/src:ro" \
        -v "${dest}:/dst" \
        "$image" \
        -c 'tar -C /src -cf - . | tar -C /dst -xf -'
}

dir_kb() {
    local kb
    kb=$(du -sk "$1" 2>/dev/null | awk '{print $1}')
    printf '%s' "${kb:-0}"
}

human_kb() {
    local kb="${1:-0}"
    if [[ "$kb" -ge 1048576 ]]; then
        awk -v k="$kb" 'BEGIN { printf "%.1f GB", k / 1048576 }'
    elif [[ "$kb" -ge 1024 ]]; then
        awk -v k="$kb" 'BEGIN { printf "%.1f MB", k / 1024 }'
    else
        printf '%s KB' "$kb"
    fi
}

human_size() {
    local bytes
    bytes=$(wc -c < "$1" 2>/dev/null || echo 0)
    human_kb "$(( bytes / 1024 ))"
}

sha256_of() {
    if command -v shasum &>/dev/null; then
        shasum -a 256 "$1" | awk '{print $1}'
    elif command -v sha256sum &>/dev/null; then
        sha256sum "$1" | awk '{print $1}'
    else
        printf 'unavailable'
    fi
}

# Count the members of a tar listing, ignoring AppleDouble '._X' sidecars whose
# sibling X is itself in the archive. macOS tar invents such sidecars and also
# drops genuine files that merely start with '._', so a plain count is wrong in
# both directions. Paperless keeps real data/log/.__*.lock files, which have no
# 'X' sibling and therefore must still count.
count_archive_members() {
    awk '
        { name = $0; sub(/\/$/, "", name); member[name] = 1; list[NR] = name }
        END {
            for (i = 1; i <= NR; i++) {
                name = list[i]
                base = name
                sub(/.*\//, "", base)
                if (substr(base, 1, 2) == "._") {
                    prefix = substr(name, 1, length(name) - length(base))
                    if ((prefix substr(base, 3)) in member) continue
                }
                total++
            }
            print total + 0
        }'
}

cmd_backup() {
    local org_name=""
    local output_dir="${SCRIPT_DIR}/backups"
    local include_data=false

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --output)       output_dir="$2"; shift 2 ;;
            --include-data) include_data=true; shift ;;
            -*)             die "Unknown option: $1" ;;
            *)              org_name="$1"; shift ;;
        esac
    done

    [[ -z "$org_name" ]] && die "Usage: $0 backup <org-name> [--output DIR] [--include-data]"
    validate_org_name "$org_name"

    if ! env_exists "$org_name"; then
        die "Environment for '${org_name}' does not exist."
    fi

    command -v jq &>/dev/null || die "jq is required. Install it: brew install jq"

    local project="paperless-trial-${org_name}"
    local db_container="${project}-db"
    local env_dir="${ENVS_DIR}/${org_name}"

    if ! container_running "$db_container"; then
        die "Database container '${db_container}' is not running, so there is no live database to dump.
  Start the environment first:  $0 start ${org_name}"
    fi

    # Reuse the database image for its tar and sh, so a backup pulls nothing new
    local helper_image
    helper_image=$(docker inspect -f '{{.Config.Image}}' "$db_container" 2>/dev/null || true)
    helper_image="${helper_image:-alpine:3}"

    local port admin_user image
    port=$(env_value "${env_dir}/.env" "WEB_PORT")
    admin_user=$(env_value "${env_dir}/.env" "PAPERLESS_ADMIN_USER")
    image=$(env_value "${env_dir}/.env" "PAPERLESS_IMAGE")
    image="${image:-${PAPERLESS_IMAGE_DEFAULT}}"

    local port_json="${port:-0}"
    [[ "$port_json" =~ ^[0-9]+$ ]] || port_json=0

    local timestamp payload created_iso host
    timestamp=$(date -u '+%Y%m%d-%H%M%S')
    payload="${org_name}-${timestamp}"
    created_iso=$(date -u '+%Y-%m-%dT%H:%M:%SZ')
    host=$(hostname)

    mkdir -p "$output_dir"
    chmod 700 "$output_dir" 2>/dev/null || true

    # Stage inside the output directory: a host path Docker can bind-mount, and
    # one that lives under the repo rather than a /var/folders temp dir. Staging
    # needs free space roughly the size of the data being archived.
    BACKUP_STAGING=$(mktemp -d "${output_dir}/.staging-${org_name}.XXXXXX")
    trap 'if [[ -n "${BACKUP_STAGING:-}" ]]; then rm -rf "${BACKUP_STAGING}" || true; fi' EXIT

    local root="${BACKUP_STAGING}/${payload}"
    mkdir -p "${root}/config"

    echo ""
    echo -e "${BOLD}${CYAN}━━━ Backing Up: ${org_name} ━━━${NC}"
    echo ""

    # 1. Database
    log_info "Dumping PostgreSQL database..."
    docker exec "$db_container" pg_dump -U paperless -d paperless \
        --clean --if-exists --no-owner > "${root}/db.sql"
    if ! grep -q "PostgreSQL database dump complete" "${root}/db.sql" 2>/dev/null; then
        die "Database dump finished without its completion marker — refusing to write this backup."
    fi
    chmod 600 "${root}/db.sql"
    printf '  %-10s %s\n' "db.sql" "$(human_size "${root}/db.sql")"

    # 2. Instance configuration (secret key, credentials, port, compose file)
    log_info "Capturing instance configuration..."
    cp "${env_dir}/.env" "${root}/config/.env"
    chmod 600 "${root}/config/.env"
    if [[ -f "${env_dir}/docker-compose.yml" ]]; then
        cp "${env_dir}/docker-compose.yml" "${root}/config/docker-compose.yml"
    fi
    init_registry
    registry_get "$org_name" > "${root}/config/registry-entry.json"

    # 3. File volumes. redisdata is deliberately never archived: it is cache.
    local vols="media consume export"
    if [[ "$include_data" == true ]]; then
        vols="media consume export data"
    fi

    : > "${BACKUP_STAGING}/volumes.jsonl"
    local vol volume kb
    for vol in $vols; do
        volume=$(compose_volume_name "$project" "$vol")
        if [[ -z "$volume" ]]; then
            log_warn "No '${vol}' volume for '${org_name}' — skipping."
            continue
        fi
        log_info "Archiving volume '${vol}'..."
        copy_volume_to_host "$volume" "${root}/${vol}" "$helper_image"
        kb=$(dir_kb "${root}/${vol}")
        printf '  %-10s %s\n' "${vol}/" "$(human_kb "$kb")"
        jq -nc --arg name "$vol" --arg volume "$volume" --argjson kb "$kb" \
            '{name: $name, docker_volume: $volume, size_kb: $kb}' \
            >> "${BACKUP_STAGING}/volumes.jsonl"
    done

    # 4. Manifest, so an archive explains itself without the registry
    local head_rev image_rev image_dirty
    head_rev=$(current_revision)
    image_rev=$(image_label "$image" "paperless.fork.revision")
    image_dirty=$(image_label "$image" "paperless.fork.dirty")
    jq -n \
        --arg org_name "$org_name" \
        --arg created_at "$created_iso" \
        --arg host "$host" \
        --argjson web_port "$port_json" \
        --arg admin_user "${admin_user:-unknown}" \
        --arg image "$image" \
        --arg image_revision "$image_rev" \
        --arg image_dirty "$image_dirty" \
        --arg head_revision "$head_rev" \
        --argjson includes_data_volume "$include_data" \
        --slurpfile volumes "${BACKUP_STAGING}/volumes.jsonl" \
        '{
            org_name: $org_name,
            backup_created_at: $created_at,
            host: $host,
            web_port: $web_port,
            admin_user: $admin_user,
            image: $image,
            image_revision: $image_revision,
            image_dirty: $image_dirty,
            head_revision: $head_revision,
            includes_data_volume: $includes_data_volume,
            volumes: $volumes
        }' > "${root}/manifest.json"

    if [[ ! -s "${root}/manifest.json" ]]; then
        die "Failed to write manifest.json (is jq working?)."
    fi

    # 5. Restore guide, so the archive is not a dead end
    cat > "${root}/RESTORE.md" <<EOF
# Restore guide — ${org_name}

Backup taken ${created_iso} UTC on ${host}, from image ${image}
(revision ${image_rev:-unknown}, uncommitted src/src-ui at build time: ${image_dirty:-unknown}).

## Contents

- db.sql — pg_dump of the 'paperless' database
- config/.env — instance variables, including PAPERLESS_SECRET_KEY
- config/docker-compose.yml — the stack definition at backup time
- config/registry-entry.json — registry.json entry at backup time
- manifest.json — sizes, image provenance and Docker volume names
- the volume directories recorded in manifest.json (media, consume, export)

Never archived: redisdata (pure cache); the data volume (search index, ML model,
logs) unless this backup was taken with --include-data.

## Restore

Restoring overwrites the target environment's database and documents. Do it into
a fresh environment, never over data you still need.

1. Recreate the instance skeleton (skip if it still exists):

       cd ${SCRIPT_DIR}
       ./trial-env.sh create ${org_name} --port ${port:-<port>}
       ./trial-env.sh stop ${org_name}

2. Extract this backup and point BACKUP at it:

       tar -xzf <archive>.tar.gz
       BACKUP="\$PWD/${payload}"

   On macOS, extract with GNU tar instead: the system tar silently skips
   members whose names start with ._ (paperless keeps data/log/.__*.lock):

       docker run --rm -v "\$PWD":/work --entrypoint tar ${helper_image} \\
         -xzf /work/<archive>.tar.gz -C /work

3. Import the database:

       cd ${ENVS_DIR}/${org_name}
       docker compose --project-name ${project} up -d db
       docker exec -i ${project}-db psql -U paperless -d paperless < "\$BACKUP/db.sql"

   db.sql was taken with --clean --if-exists, so it drops the objects it
   recreates. Importing into a database that holds unrelated data destroys it.

4. Copy each file volume back in, swapping media for consume or export (and the
   volume name to match):

       docker run --rm -v ${project}_media:/dst -v "\$BACKUP/media":/src:ro \\
         --entrypoint sh ${helper_image} -c 'tar -C /src -cf - . | tar -C /dst -xf -'

   This runs as root, so restored files land owned by root, while the trial
   webserver runs as uid 1000. If paperless reports that it cannot write a file
   it restored, hand ownership back:

       docker run --rm -v ${project}_media:/dst --entrypoint chown ${helper_image} -R 1000:1000 /dst

5. Start the environment and hard-refresh the browser:

       cd ${SCRIPT_DIR}
       ./trial-env.sh start ${org_name}
EOF

    # 6. One archive, checksummed, and verified before we claim success
    local archive="${output_dir}/${payload}.tar.gz"
    log_info "Compressing archive..."
    # COPYFILE_DISABLE=1 stops macOS tar from treating names starting with '._'
    # as AppleDouble metadata: without it, paperless's data/log/.__*.lock files
    # are dropped from the archive without a word. GNU tar ignores this variable.
    COPYFILE_DISABLE=1 tar -czf "$archive" -C "$BACKUP_STAGING" "$payload"
    chmod 600 "$archive"

    if ! tar -tzf "$archive" > /dev/null 2>&1; then
        die "Archive verification failed: '${archive}' is not a readable gzip tarball."
    fi

    # Completeness check. macOS tar also HIDES '._'-prefixed members when it
    # lists, so counting with the host tar would happily pass an archive that
    # lost files. The container's GNU tar is the honest counter, and every
    # staged member must appear in the archive.
    local archive_name staged_entries archived_entries
    archive_name=$(basename "$archive")
    staged_entries=$(cd "$root" && find . \( -type f -o -type d -o -type l \) -print | wc -l | tr -d ' ')
    if archived_entries=$(docker run --rm -v "${output_dir}:/bk:ro" --entrypoint tar \
            "$helper_image" -tzf "/bk/${archive_name}" 2>/dev/null \
            | count_archive_members); then
        if [[ "$archived_entries" -ne "$staged_entries" ]]; then
            die "Archive holds ${archived_entries} members but ${staged_entries} were staged — the archive lost or gained entries, so it is not a faithful backup. Inspect it before relying on it: ${archive}"
        fi
    else
        log_warn "Could not list '${archive_name}' with the container's tar; skipped the completeness check."
    fi

    local digest
    digest=$(sha256_of "$archive")
    printf '%s  %s\n' "$digest" "$(basename "$archive")" > "${archive}.sha256"
    chmod 600 "${archive}.sha256"

    local archive_size
    archive_size=$(human_size "$archive")

    # The staged copy is redundant once the archive exists
    rm -rf "${BACKUP_STAGING}"
    BACKUP_STAGING=""

    echo ""
    echo -e "${GREEN}${BOLD}━━━ Backup Complete ━━━${NC}"
    echo ""
    echo -e "  ${BOLD}Environment:${NC} ${org_name}"
    echo -e "  ${BOLD}Archive:${NC}     ${archive}"
    echo -e "  ${BOLD}Size:${NC}        ${archive_size}"
    echo -e "  ${BOLD}SHA256:${NC}      ${digest}"
    echo -e "  ${BOLD}Checksum:${NC}    ${archive}.sha256"
    echo ""
    if [[ "$include_data" == false ]]; then
        echo -e "  ${CYAN}Not archived:${NC} the data/ volume (search index, ML model, logs)."
        echo -e "               Add ${BOLD}--include-data${NC} to include it; redisdata is cache and never archived."
    fi
    echo -e "  ${CYAN}Restore steps:${NC} RESTORE.md inside the archive."
    echo -e "  ${CYAN}Contains credentials:${NC} keep ${output_dir} private (mode 700)."
    echo ""
    log_success "Backup of '${org_name}' written to ${archive}"
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
    echo "  backup  <org-name>   Archive an environment's database and files"
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
    echo -e "${BOLD}BACKUP OPTIONS:${NC}"
    echo "  --output DIR         Where to write the archive (default: ${SCRIPT_DIR}/backups)"
    echo "  --include-data       Also archive the data volume (search index, ML model, logs)"
    echo ""
    echo -e "${BOLD}EXAMPLES:${NC}"
    echo "  $0 create acme-corp"
    echo "  $0 create beta-client --port 8150 --password 's3cur3!'"
    echo "  $0 list"
    echo "  $0 info acme-corp"
    echo "  $0 backup acme-corp"
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
        backup)  cmd_backup "$@" ;;
        help|-h|--help) cmd_help ;;
        *)       die "Unknown command: $command. Run '$0 help' for usage." ;;
    esac
}

main "$@"
