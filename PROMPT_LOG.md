# Prompt Log — Flovi AI Challenge

## Estrategia general
Stack elegido: Vue 3 + Vite + Tailwind / Flutter 3 / Supabase / Vercel
Razón backend: Supabase cubre OAuth Google + DB + realtime sin servidor propio.

---

## [03:47] — Estructura inicial de proyecto con Claude/GSD
**Pedí:** buena estructura pa que Claude y agents estén organizados en proyecto — CLAUDE.md, notas, roadmap, políticas de desarrollo, docs necesarias antes de programar con Vue3 + Flutter3.
**Generó:** propuesta de usar skill `gsd-new-project` (sistema GSD) pa generar `.planning/PROJECT.md`, `REQUIREMENTS.md`, `ROADMAP.md`, `CLAUDE.md` mediante cuestionario guiado.
**Cambié:** pedí versión simple — es challenge, no proyecto elaborado. Evitar sobre-estructurar roadmap/requisitos.
**Por qué:** alcance real es una prueba técnica, no producto con múltiples milestones.

---

## [03:55] — Repositorio Git y GitHub
**Pedí:** iniciar git con credenciales existentes (token), crear repo con README, aplicar buenas prácticas de protección.
**Generó:** verificación de `gh auth status` (ya autenticado como Badi21, scope `repo`). Creé `README.md`, `.gitignore` (Vue3 + Flutter3), commit inicial, rama `main`, repo privado `Badi21/flovi-challenge` vía `gh repo create --push`.
**Cambié:** branch protection falló (403) — GitHub Pro requerido pa repos privados. Activé alternativa gratis: Dependabot alerts + security updates, merge policy squash-only con delete-branch-on-merge.
**Por qué:** mantener protección real disponible en plan free sin bloquear al ser único dev.

---

## [04:00] — Repo público + branch protection
**Pedí:** hacer proyecto público.
**Generó:** `gh repo edit --visibility public`.
**Cambié:** con repo público, branch protection ya gratis — activé en `main`: no force-push, no delete, historial lineal.
**Por qué:** visibilidad pública desbloquea protección nativa de GitHub sin costo; sin ella, `main` quedaba sin ninguna barrera contra push destructivo.

---

## [04:03] — Este archivo
**Pedí:** crear `PROMPT_LOG.md` en raíz, ahora, no al final.
**Generó:** este log, reconstruido desde las decisiones reales tomadas en sesión hasta este punto.
**Cambié:** nada — se registra en el momento pedido.
**Por qué:** trazabilidad honesta de decisiones, no reconstrucción retroactiva.

---

## [04:05] — Rama dev
**Pedí:** commit+push de `PROMPT_LOG.md`, crear rama `dev` como rama principal de desarrollo pa luego sacar features desde ahí.
**Generó:** commit en `main`, push, `git checkout -b dev` + `git push -u origin dev`.
**Cambié:** nada — `main` sigue default branch en GitHub, protegida. `dev` sin protection propia todavía (pendiente confirmar si se quiere igual de restrictiva).
**Por qué:** separar rama estable/protegida de la rama de trabajo activo.

---

## [04:26] — Scaffold Dispatcher App (web)
**Pedí:** scaffoldear `/web` — Vite + Vue3 + TS, Tailwind v4, `@supabase/supabase-js`, `src/lib/supabase.ts` con env vars, `.env.local`, Vue Router (`/login`, `/dashboard` protegida, `/` redirige), AuthGuard antes de rutas protegidas. Sin componentes UI, solo scaffold y wiring.
**Generó:** `npm create vite@latest web -- --template vue-ts`, instalé `tailwindcss` + `@tailwindcss/vite`, `@supabase/supabase-js`, `vue-router`. Creé `src/lib/supabase.ts`, `src/router/authGuard.ts` (guard separado, no inline), `src/router/index.ts`, vistas mínimas `LoginView.vue`/`DashboardView.vue`, alias `@` en `vite.config.ts` + `tsconfig.app.json`, `.env.local` con la URL real de Supabase + placeholder de key, `.env.example` sin datos reales.
**Cambié:** limpié demo scaffold de Vite (HelloWorld, hero.png, vue.svg, CSS de ejemplo) — no pedido pero dejarlo hubiera contradicho "sin componentes UI todavía". `tsconfig.app.json` necesitó `ignoreDeprecations: "6.0"` — TS 6 ya marca `baseUrl` deprecado pero `paths` todavía lo requiere.
**Por qué:** verifiqué con `vue-tsc -b`, `npm run dev` (curl a localhost) y `npm run build` — los tres limpios antes de entregar.
