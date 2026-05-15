---
name: bootstrap-app
description: Bootstrap a new app with Structured Vibe Coding — generates all docs and structure from a single idea. Works with any AI model inside Handoff.
version: 1.0
---

# Bootstrap — New App

> ⚠️ **Modelo recomendado:** GPT-5 / Gemini 2.5 Pro / Mistral Large o el modelo más capaz disponible.
> Modelos rápidos o pequeños pueden quedarse cortos en bootstrap por la cantidad de tool calls.

> **Working agreement** — Before doing anything, read `WORKING-AGREEMENT.md` at the repo root. The rule applies here too: analyze → summarize → propose → wait for OK → write the spec → only then act. If `WORKING-AGREEMENT.md` doesn't exist yet, create it from this blueprint's template.

You are the architect of this project. Follow this blueprint exactly.
The goal: a functional, stable, and scalable app from the first commit.

**Destination:** All projects are created inside `~/proyectos/`. Create that folder first if it doesn't exist.

**Roles:** Before making architectural decisions, read the relevant role from `.handoff/roles/`:
- Backend / API / DB decisions → read `senior-backend.md`
- UI / components / UX decisions → read `senior-frontend.md`
- Design system / flows / conversion → read `senior-design.md`

---

## Step 0 — Understand the idea

Ask questions ONE AT A TIME. Wait for the answer before asking the next one.

**First, ask only this:**
"¿Qué app quieres construir? Descríbela en una o dos oraciones."

Wait for the answer. Then ask:
"¿Qué stack prefieres?
1. SvelteKit full-stack (frontend + backend en un solo repo) — recomendado para la mayoría
2. SvelteKit + FastAPI separados (cuando necesitas Python, ML o integraciones de IA)
3. Otro (descríbelo)"

Wait for the answer. Then use both answers to:
- Name the project (slug format, e.g. `meeting-to-tasks`)
- Fill `CONTEXT.md` with the real problem, not placeholders
- Write `docs/vision/product-vision.md` adapted to that idea
- Write `docs/constitution/constitution.md` with principles for that domain
- Write `docs/plan/v1-mvp.md` with ADRs relevant to that stack and problem
- Write `docs/clarify/assumptions.md` with real open questions for that product

Do not proceed to Step 1 until you have both answers.
Do not use generic placeholders anywhere — every doc must reflect the actual project.

**Stack rules:**
- Option 1 (SvelteKit full-stack): use SvelteKit server routes (`+server.ts`) as the API layer. Never mention FastAPI or Python backend.
- Option 2 (SvelteKit + FastAPI): generate both repos with a clear API contract.
- Option 3: adapt the blueprint to the described stack.

---

## Default stack

| Layer | Technology | Notes |
|---|---|---|
| Backend | Python 3.11+ · FastAPI | Strict typing, async, auto OpenAPI |
| Frontend | SvelteKit | SPA, minimal bundle, Svelte 5 `$state()` |
| Database | PostgreSQL (prod) / SQLite (dev) · SQLAlchemy | ORM + migrations |
| Auth | Firebase Auth (Google + Microsoft) | HTTP-only cookie |
| Payments | Stripe (global) · Reveniu (LATAM) | Choose by market |
| Deploy | Railway | Managed PostgreSQL + app in one place |
| AI | Model-agnostic via API | Haiku/Flash for cheap tasks, Sonnet/GPT-4o for analysis |
| Quality | ruff · mypy · pytest | No exceptions |

> **Stack-agnostic:** The blueprint structure works with any language or framework. Replace what doesn't apply.

---

## Step 1 — Create project structure

Create the folder at `~/proyectos/<project-name>/` and build exactly this structure:

```
~/proyectos/<project-name>/
├── HANDOFF.md                   # agent rules + context pointer (read by Handoff at session start)
├── CONTEXT.md                   # living AI context (auto-updated after commits)
├── .blueprint                   # config: BLUEPRINT_VERSION, PROJECT_NAME, STACK
├── .env.example                 # documented env vars — include at minimum:
│                                #   DATABASE_URL=
│                                #   SECRET_KEY=
│                                #   DEV_MODE=false
│                                #   DEV_USER_EMAIL=dev@local.dev
│                                #   DEV_USER_NAME=Developer
├── .gitignore
├── Makefile
│
├── docs/
│   ├── vision/
│   │   └── product-vision.md    # what, for whom, why now
│   ├── constitution/
│   │   └── constitution.md      # immutable principles
│   ├── plan/
│   │   └── v1-mvp.md            # technical plan + ADRs
│   ├── clarify/
│   │   └── assumptions.md       # assumptions + open questions
│   ├── modular/
│   │   └── modules.md           # module contracts
│   ├── sdd/
│   │   └── arquitectura.md      # system design document
│   └── specs/                   # one spec per feature
│       └── _spec.template.md
│
├── scripts/
│   ├── update_docs.py           # auto-updates living docs after commits
│   └── install_hooks.sh         # installs git post-commit hook
│
├── .github/
│   ├── workflows/
│   │   └── ci.yml               # quality gate on every push
│   └── PULL_REQUEST_TEMPLATE.md
│
├── .handoff/
│   └── roles/                   # specialized roles for this project
│       ├── senior-backend.md
│       ├── senior-frontend.md
│       ├── senior-design.md
│       └── security-review.md
│
├── src/                         # source code
└── tests/
    └── conftest.py
```

After creating the structure, copy the role files from `~/.handoff/roles/` (or the blueprint source) into `.handoff/roles/`. Then update the `## Stack del proyecto` section of each role to match the actual project stack.

---

## Step 2 — Fill HANDOFF.md

Generate `HANDOFF.md` with the real project data (not placeholders):

```markdown
# HANDOFF.md — <Project Name>

## What is this
<One line: what it does and for whom>

## Read first
Always read `CONTEXT.md` before starting any task — it has current state, architecture, and recent changes.

## Stack
<fill with actual stack>

## Quality commands
make quality   # always before committing
make dev       # development server
make test      # tests only

## Roles — when to activate them
Read the role file before working in that area:
| Area | Role | File |
|---|---|---|
| APIs, database, performance | Senior Backend | `.handoff/roles/senior-backend.md` |
| Components, UX, accessibility | Senior Frontend | `.handoff/roles/senior-frontend.md` |
| User flows, visual design | Senior Design | `.handoff/roles/senior-design.md` |
| Security audit, OWASP | Security Review | `.handoff/roles/security-review.md` |

## Rules
1. `make quality` must pass before every commit
2. Every new feature: write spec in `docs/specs/<name>.md` BEFORE coding
3. Every architectural decision: add ADR in `docs/plan/v1-mvp.md`
4. Never commit `.env` — only `.env.example`
5. No tests, no merge

## What NOT to do
- ❌ Never truncate context when switching areas
- ❌ Never assume stack — read CONTEXT.md first
- ❌ Never respond without reading the actual code first
```

---

## Step 3 — Fill CONTEXT.md

```markdown
# CONTEXT.md — <Project Name>

## What is this
<One line: what it does and for whom>

## Current state
- 🚧 Setup

## Architecture in one screen
<ASCII diagram>

## Key modules
| What I'm looking for | Where it is |
|---|---|

## Quality rules
make quality  # linting + types + tests

## Key decisions
| Decision | Why |
|---|---|

## What NOT to do
- ❌

## Recent Changes
_Auto-updated by scripts/update_docs.py after each commit_
```

---

## Step 4 — Auto-context hook (git post-commit)

Install the git hook so living docs update automatically after every commit:

```bash
bash scripts/install_hooks.sh
```

`scripts/update_docs.py` runs after every commit and updates:
- `CONTEXT.md` → `## Recent Changes`
- `docs/constitution/constitution.md` → `## Project Status`
- `docs/clarify/assumptions.md` → `## Last Review`
- `docs/plan/v1-mvp.md` → `## Build Progress`
- `docs/specs/*.md` → `<!-- status: ... -->` marker

---

## Step 5 — Quality gate (Makefile)

Generate the Makefile based on the chosen stack:

**Option 1 — SvelteKit full-stack:**
```makefile
install-dev:
	npm install

quality:
	npm run check
	npm run lint
	npm run test

dev:
	npm run dev

build:
	npm run build

test:
	npm run test
```

**Option 2 — SvelteKit + FastAPI:**
```makefile
install-dev:
	pip install -r requirements.txt -r requirements-dev.txt
	cd frontend && npm install

quality:
	.venv/bin/ruff check src/ tests/ main.py --fix
	.venv/bin/ruff format src/ tests/ main.py
	.venv/bin/mypy src/
	.venv/bin/pytest tests/ -v
	cd frontend && npm run check

dev-api:
	.venv/bin/uvicorn main:app --reload

dev-frontend:
	cd frontend && npm run dev

test:
	.venv/bin/pytest tests/ -v

build:
	cd frontend && npm run build
```

**Option 3:** adapt to the described stack.

---

## Step 6 — CI/CD

Generate `.github/workflows/ci.yml` based on the chosen stack (same patterns as Makefile above).

---

## Before finishing — ask the user

"Do you want to start the project locally now?
1. Yes — install dependencies and start the dev server
2. Yes + deploy — start local and configure Railway deploy
3. Not yet"

- If **1**: run `make install-dev && make dev`
- If **2**: run `make install-dev && make dev`, then `railway login && railway init && railway up`
- If **3**: continue without starting

---

## Rules always active

1. `make quality` must pass before finishing any task
2. Each new feature: write spec in `docs/specs/<name>.md` **before** coding
3. Each architectural decision: add ADR in `docs/plan/v1-mvp.md`
4. After every commit: living docs update automatically (git hook)
5. Never commit `.env` — only `.env.example` with descriptions
6. No tests, no merge

---

## Final summary — always print this at the end

```
✅ Bootstrap complete — ~/proyectos/<project-name>/

To continue, write any of these:
→ "continue with recommended" — agent reads CONTEXT.md and knows what comes next
→ "iterate and improve" — agent reviews docs/ and completes what's missing
→ "update docs" — agent runs scripts/update_docs.py manually

🔄 Docs update automatically after every commit (git hook active):
  CONTEXT.md · constitution.md · plan/v1-mvp.md · specs/*.md

🤖 Roles available in .handoff/roles/ — activate before working in each area
```

---

## Stack variants

### Backend API only
- Remove `frontend/`
- Add `contracts/openapi.yml` from day 1

### Frontend only
- Use SvelteKit server routes (`+server.ts`) as the backend
- One repo, one deploy

### With AI pipeline
```
Input
  ▼ Layer 1: Local validation      Cost: $0.00
  ▼ Layer 2: Cheap model call      Cost: ~$0.001
  ▼ Layer 3: Full model analysis   Cost: ~$0.025
```
Never call the expensive model without passing through the cheap one first.
