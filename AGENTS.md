# AGENTS.md — `buildwithtrace/homebrew-tap` (Trace CLI Homebrew tap)

> The Homebrew distribution channel for the `buildwithtrace` CLI:
> `brew install buildwithtrace/tap/buildwithtrace`. The formula is REWRITTEN
> downstream by the CLI's release CI — do not hand-edit url/version/sha256.
>
> **SELF-UPDATING:** keep this file current. When this repo's role, layout, or
> the formula-rewrite mechanism changes, update this file in the same change.

---

## Trace polyrepo map

> This section is IDENTICAL across all five split repos so every repo
> cross-references the others. "One engine, several deliverables."

| Package | Registry | Role | Repo (personal / org) |
|---|---|---|---|
| `buildwithtrace-sdk` | PyPI | Python **core engine** (client, tool executor, standalone agent loop, converter, BYOK) | elcruzo/trace-sdk-python / buildwithtrace/sdk-python |
| `@buildwithtrace/sdk` | npm | TS/JS library (reimplementation, kept in parity with the Python core) | elcruzo/trace-sdk-node / buildwithtrace/sdk-node |
| `buildwithtrace` (CLI) | PyPI + npm npx-wrapper | Terminal app — thin wrapper over `buildwithtrace-sdk`; adds commands, MCP server, auth, UX | elcruzo/trace-cli / buildwithtrace/cli |
| `buildwithtrace/github-action` | GH Marketplace | CI wrapper that installs + runs the CLI (rolling `v1`) | elcruzo/trace-github-action / buildwithtrace/github-action |
| homebrew-tap | brew | Distribution channel for the CLI (`brew install buildwithtrace/tap/buildwithtrace`); formula rewritten by CLI release CI | elcruzo/trace-homebrew-tap / buildwithtrace/homebrew-tap |

**SDK-as-core.** `buildwithtrace-sdk` (Python) is the single core engine. The CLI
is a thin wrapper that imports it. There is no logic duplication between the CLI
and the Python SDK.

**Node ↔ Python parity caveat.** `@buildwithtrace/sdk` is a TypeScript
**reimplementation** of the agent client (JS cannot call the Python core), so it
must be kept in feature-parity with the Python core **by hand**. This is the one
real duplication in the polyrepo.

**Unified version + release + OIDC model.**
- Every client-facing artifact is standardized at **0.1.0** (`buildwithtrace-sdk`,
  `@buildwithtrace/sdk`, and the `buildwithtrace` CLI).
- Clients default to the backend's dynamic **`latest`** API version (`/api/latest`),
  overridable via `--api-version` / `api_version`.
- **Push to `main` = sync + tests, never publishes.** A release happens only on a
  `v*` tag. The (gitignored, local) `sdk-python/publish.sh` bumps + tags + pushes
  `sdk-python` + `sdk-node` + `trace-cli` to one version; each repo's tag triggers
  its own **OIDC** publish (PyPI / npm — no stored tokens).
- **Ordering constraint:** `buildwithtrace-sdk` must publish to PyPI **before** the
  CLI (the CLI depends on it).
- The Homebrew formula here is rewritten downstream by the CLI's release CI
  (sha256 computed post-build). `github-action` uses a rolling `v1` tag.

---

## This repo: the Homebrew tap

A distribution channel only — no product logic. It carries one formula.

### Layout

| File | Role |
|---|---|
| `Formula/buildwithtrace.rb` | The CLI formula. Installs `buildwithtrace` into a virtualenv (`python@3.12`) via `pip_install_and_link`, then writes a single `bin/buildwithtrace` wrapper. **Deliberately does NOT link a `trace` binary** (collides with macOS `/usr/bin/trace`). |
| `README.md` | Install / upgrade / usage. |

### The formula is machine-rewritten — do NOT hand-edit

`url`, `version`, and `sha256` in `Formula/buildwithtrace.rb` are REWRITTEN by the
CLI's `update-homebrew` release job (in `trace-cli/.github/workflows/release.yml`)
after the CLI's release tarball exists — the sha256 can't be known until the
release artifact is built. That job checks this repo out (via `HOMEBREW_TAP_TOKEN`),
`sed`s the three fields to point at the new
`github.com/buildwithtrace/cli/releases/download/<tag>/buildwithtrace-<ver>.tar.gz`
+ its computed sha256, and commits. The committed `main` ships a `0.1.0` placeholder
url + `sha256 "REPLACE_WITH_REAL_SHA256"`, resolved automatically on the first real
release. `publish.sh` does NOT bump this formula — it can't (no post-build sha256).

### Release / sync

- No release workflow of its own. Updates arrive as commits from the CLI's
  `update-homebrew` job.
- `sync-to-org.yml` mirrors `main` → `buildwithtrace/homebrew-tap` via
  `ORG_PUSH_TOKEN`.

### Install

```bash
brew tap buildwithtrace/tap
brew install buildwithtrace        # or: brew install buildwithtrace/tap/buildwithtrace
```

---

## Related repos

- **`elcruzo/trace-cli`** → `buildwithtrace/cli` — the `buildwithtrace` CLI this
  tap distributes; its release CI rewrites the formula here.
- **`elcruzo/trace-sdk-python`** → `buildwithtrace/sdk-python` — PyPI
  `buildwithtrace-sdk`, the core engine the CLI wraps.
- **`elcruzo/trace-sdk-node`** → `buildwithtrace/sdk-node` — npm
  `@buildwithtrace/sdk` (TS reimplementation, hand-parity with the Python core).
- **`elcruzo/trace-github-action`** → `buildwithtrace/github-action` — CI action
  that installs + runs the CLI (rolling `v1`).
