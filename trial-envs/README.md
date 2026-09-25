# Paperless-ngx Trial Environment Manager

One-command setup for isolated Paperless-ngx trial environments. Each organization gets its own fully isolated stack (PostgreSQL + Redis + Paperless-ngx) on a unique port.

## Prerequisites

- **Docker** & **Docker Compose** (v2+)
- **jq** — `brew install jq`
- **The fork image** — trial environments run `paperless-ngx:local`, built from this
  repo's own `Dockerfile`. Build it once (and again after any `src-ui/` change):

  ```bash
  docker build -t paperless-ngx:local .
  ```

  Passing `--build` to `create` runs this for you.

## Quick Start

```bash
# Create a trial env for "acme-corp"
./trial-env.sh create acme-corp

# Create with custom port and password
./trial-env.sh create beta-client --port 8150 --password 'S3cur3Pass!'

# List all environments
./trial-env.sh list

# Get connection details
./trial-env.sh info acme-corp

# View logs
./trial-env.sh logs acme-corp --follow

# Stop/Start
./trial-env.sh stop acme-corp
./trial-env.sh start acme-corp

# Refresh an existing env after changing the stack or rebuilding the image
./trial-env.sh update acme-corp

# Back up an environment (database + documents) before changing or deleting it
./trial-env.sh backup acme-corp

# Create, building the fork image first
./trial-env.sh create acme-corp --build

# Delete (removes containers + data)
./trial-env.sh delete acme-corp

# Delete (keep data volumes)
./trial-env.sh delete acme-corp --keep-data
```

## How It Works

```
trial-envs/
├── trial-env.sh                 # Management script
├── docker-compose.trial.yml     # Compose template
├── registry.json                # Auto-generated: tracks all envs
├── backups/                     # Auto-generated: backup archives
│   └── acme-corp-20260922-170000.tar.gz
└── instances/                   # Auto-generated: per-org configs
    ├── acme-corp/
    │   ├── .env                 # Org-specific variables
    │   └── docker-compose.yml   # Copy of template
    └── beta-client/
        ├── .env
        └── docker-compose.yml
```

When you run `create`:
1. An available port is auto-assigned (range: 8100–8999)
2. A unique secret key is generated
3. Per-org directory is created with `.env` and `docker-compose.yml`
4. Docker Compose spins up: PostgreSQL → Redis → Paperless-ngx
5. The org is registered in `registry.json`

Each environment is completely isolated — separate database, separate Redis, separate volumes.

## Port Allocation

| Port Range | Purpose |
|-----------|---------|
| 8100–8999 | Auto-assigned trial environments |

You can also specify a port manually with `--port`.

## Commands Reference

| Command | Description |
|---------|-------------|
| `create <org>` | Create and start a new environment |
| `delete <org>` | Stop, remove containers and volumes |
| `update <org>` | Re-render the compose file from the template and recreate containers (data preserved); `--build` rebuilds the image first |
| `list` | Show all environments with status |
| `info <org>` | Display connection details |
| `status <org>` | Show Docker container status |
| `start <org>` | Start a stopped environment |
| `stop <org>` | Stop a running environment |
| `logs <org>` | View environment logs |
| `backup <org>` | Archive the database and file volumes to `backups/` (see below) |

## Default Credentials

- **Username:** `admin`
- **Password:** `changeme123`

Override with `--user` and `--password` flags on `create`.

## Rebuilding after UI changes

`create` and `update` never compile anything. They start containers from the image
already on your machine, which is why they finish in seconds and never download
packages — `pnpm install` and `ng build` only ever run inside `docker build`.

The consequence: **editing `src-ui/` changes nothing until you rebuild the image.**

```bash
docker build -t paperless-ngx:local .   # or: ./trial-env.sh update <org> --build
./trial-env.sh update <org>              # recreate the env on the new image
```

Each image records the git revision it was built from. `create` and `update` warn
when that revision differs from `HEAD`, or when the image was built from a clean
tree but `src/`/`src-ui/` now has uncommitted changes — so a stale image reports
itself instead of silently serving old UI. Then hard-refresh the browser, since
Angular's cached bundles outlive the container.

## Backups

```bash
./trial-env.sh backup acme-corp                  # -> backups/acme-corp-<UTC timestamp>.tar.gz
./trial-env.sh backup acme-corp --output /Volumes/backup-drive
./trial-env.sh backup acme-corp --include-data    # also archive the data volume
```

`backup` writes one checksummed `.tar.gz` per run plus a `.sha256` sidecar. Inside
the archive:

- `db.sql` — `pg_dump` of the `paperless` database (plain SQL, `--clean --if-exists`)
- `media/`, `consume/`, `export/` — dump of the matching Docker volumes
- `config/.env` — instance variables, including `PAPERLESS_SECRET_KEY`
- `config/docker-compose.yml`, `config/registry-entry.json` — stack and registry state
- `manifest.json` — sizes, source revision, and the real Docker volume names
- `RESTORE.md` — the exact commands to restore this archive

Decisions worth knowing:

- **The `data` volume is not included by default.** It holds the search index, the
  trained classifier, and logs — all regenerable. Pass `--include-data` if you would
  rather not wait for a rebuild.
- **`redisdata` is never included.** It is a cache and means nothing without the
  database.
- **The database container must be running.** A stopped PostgreSQL container cannot
  be dumped, so `backup` tells you to `start` the environment first.
- **Staging doubles the space briefly.** The archive is assembled in a temporary
  directory inside the output directory, which needs free space roughly the size of
  the data being copied.
- **The dump is taken live.** It is consistent for PostgreSQL, but a document being
  ingested at that exact moment may be missing its file from `media/`.
- **Archives contain credentials and client documents.** `backups/` is gitignored
  and created mode 700; keep copies on encrypted media.
- **Archives are created with `COPYFILE_DISABLE=1`.** macOS `tar` treats names
  beginning with `._` as AppleDouble metadata and silently omits them — paperless
  keeps `data/log/.__celery.lock` and `.__paperless.lock`, so a plain `tar` would drop
  them from every backup. The same quirk affects *listing and extraction* on macOS,
  which is why `RESTORE.md` reads and extracts with the container's GNU tar, and why
  `backup` counts the archive's files with GNU tar rather than the host's.

Restoring is a documented manual procedure (`RESTORE.md` inside each archive), not a
scripted command, so nothing can overwrite a live environment by accident.

## Notes

- **The webserver runs the fork image, never upstream.** The compose template uses
  `${PAPERLESS_IMAGE:-paperless-ngx:local}`. The upstream
  `ghcr.io/paperless-ngx/paperless-ngx` image ships the vanilla UI, so it shows none
  of this fork's UI changes (custom logo, RTL styles, ar-AR bundle, app title) even
  though the stack runs fine. `create` refuses to start when the image is missing.
- After a rebuild of `paperless-ngx:local`, run `update <org>` on each env — existing
  instances keep their own copy of the compose file.
- First startup takes 1-2 minutes for database migrations
- The `registry.json` file contains passwords — do not commit it
- Backup archives (`backups/`) contain a database dump and the instance secret key —
  do not commit or share them
- Each org uses ~500MB RAM (can be tuned with `PAPERLESS_TASK_WORKERS` etc.)
