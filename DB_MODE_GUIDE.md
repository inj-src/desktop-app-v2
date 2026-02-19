# Database Mode Guide (PGlite vs External PostgreSQL)

This desktop app supports two database modes:

- `pglite`: embedded database managed by Electron (default).
- `external-postgres`: use a PostgreSQL server outside Electron.

## Quick switch

Set env vars before `npm run dev` / `npm run build`.

### Embedded PGlite (default)

```bash
DB_MODE=pglite npm run dev
```

### External PostgreSQL

```bash
DB_MODE=external-postgres \
DATABASE_URL_EXTERNAL="postgresql://user:pass@host:5432/dbname" \
npm run dev
```

## Easier env toggles

Any one of these enables external DB mode:

- `DB_MODE=external-postgres`
- `DATABASE_MODE=external-postgres`
- `USE_EXTERNAL_DB=true` (also accepts `1`, `yes`, `on`)

If none are set, mode defaults to `pglite`.

## Env reference

- `DB_MODE`: `pglite` or `external-postgres`.
- `DATABASE_MODE`: alias for `DB_MODE`.
- `USE_EXTERNAL_DB`: boolean shortcut to force external mode.
- `DATABASE_URL_EXTERNAL`: required in external mode.
- `PGLITE_PORT`: embedded pgwire port (default `5433`).
- `PGLITE_RUN_SETUP`: run backend `setup.js` in pglite mode (default `true`).

See `.env.example` for a starter template.

## What happens in each mode

### `pglite`

- Electron starts embedded PGlite.
- Electron applies backend Prisma SQL migrations directly.
- Electron runs backend `setup.js` (unless `PGLITE_RUN_SETUP=false`).
- Backend uses the embedded DB URL.

### `external-postgres`

- Electron skips PGlite startup.
- Backend uses `DATABASE_URL_EXTERNAL` (or `DATABASE_URL` fallback).
- Migration/setup behavior is handled by your normal backend flow.

## If you later want to remove PGlite completely

1. Keep app running in external mode first (`USE_EXTERNAL_DB=true`) and validate.
2. Remove `src/main/pglite-service.ts` usage from `src/main.ts`.
3. Remove PGlite dependencies from `package.json`:
   - `@electric-sql/pglite`
   - `@electric-sql/pglite-socket`
4. Remove related `asarUnpack` entries for those packages.
5. Remove PGlite-only env vars from docs/config (`PGLITE_*`).

This lets you keep one codebase while switching modes by env during migration.
