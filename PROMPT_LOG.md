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
