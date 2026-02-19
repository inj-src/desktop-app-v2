# Windows Release + Auto-Update Guide

This project is configured to:

- Build a Windows installer (`nsis`) in GitHub Actions.
- Publish artifacts to GitHub Releases.
- Use in-app auto-update checks via `electron-updater`.

## 1) GitHub Actions workflow

Workflow file: `.github/workflows/windows-release.yml`

Trigger:

- Push a tag like `v1.0.1` (normally via `npm run build:prod`)

Permissions:

- `contents: write` (required to publish release artifacts)

## 2) Source layout expectation

This workflow does not checkout backend/frontend from other repositories.
It only builds from files already present in this repository checkout.

Required before CI release:

- `build-resources/backend`
- `build-resources/frontend`
- Those prepared resources must be committed (or force-added), not ignored.

If missing, CI fails with an instruction to run `npm run prepare:resources` first.

## 3) Build publish config

`package.json` contains GitHub publish settings using env values:

- `GH_RELEASE_OWNER`
- `GH_RELEASE_REPO`

The workflow injects these from the current repository context.

## 4) Auto-update behavior in app

Main-process updater service: `src/main/updater-service.ts`

Behavior:

1. Checks for updates on app startup (packaged app).
2. When update is available, shows dialog: `Download Update` / `Later`.
3. If dialog is closed or `Later` is chosen, it is not shown again until app restart.
4. After download, shows dialog: `Restart and Install` / `Later`.
5. If install dialog is closed or `Later` is chosen, it is not shown again until app restart.

## 5) Local publish test (optional)

If you need to test publishing locally:

```bash
GH_TOKEN=your_token \
GH_RELEASE_OWNER=your-org \
GH_RELEASE_REPO=your-repo \
npm run build -- --publish always --win nsis --x64
```

## 6) Interactive production release flow (`build:prod`)

Use:

```bash
npm run build:prod
```

Flow:

1. Runs `npm run prepare:resources` first.
2. Runs local production build check (`npm run build`).
3. If build succeeds, asks whether to release.
4. If confirmed, pushes your current branch to `origin`.
5. Asks for release tag (default: `v<package.json version>`).
6. Pushes that tag to `origin`.
7. Tag push triggers GitHub Actions Windows release workflow automatically.

Non-interactive variant:

```bash
npm run build:prod -- --yes --tag v1.0.1
```

## 7) `prepare:resources` interactive behavior

Command:

```bash
npm run prepare:resources
```

Behavior:

1. If both `build-resources/backend` and `build-resources/frontend` already exist, you get a checkbox-style prompt:
`b` backend, `f` frontend, `bf` both, `n` none.
2. If either resource folder is missing, no checkbox prompt is shown and it runs a fresh build for both backend and frontend.

## 8) Selecting backend/frontend branch for a build

`prepare:resources` uses whatever branch is currently checked out in each source directory.

Check current branch:

```bash
git -C ../sasthotech-hospital-backend-v1 branch --show-current
git -C ../hospital_v1 branch --show-current
```

Switch branch before build:

```bash
git -C ../sasthotech-hospital-backend-v1 checkout your-backend-branch
git -C ../hospital_v1 checkout your-frontend-branch
```

Optional strict guard (fails build on mismatch):

```bash
EXPECTED_BACKEND_BRANCH=main \
EXPECTED_FRONTEND_BRANCH=main \
npm run build
```

Build metadata with detected branch+commit is written to:

- `build-resources/build-meta.json`
