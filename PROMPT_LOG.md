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

---

## [04:33] — LoginView.vue completo
**Pedí:** página de login completa — card centrada, fondo gris claro, título "Flovi Dispatcher" + subtítulo "Vehicle relocation management", botón "Continue with Google" con SVG inline, `signInWithOAuth` con `redirectTo`, manejo de error en rojo, redirect a `/dashboard` si ya hay sesión, TS estricto + Composition API.
**Generó:** busqué flovi.io primero (paleta navy/blanco, minimalista, alto contraste) pa que el diseño no fuera genérico. Reescribí `LoginView.vue`: `onMounted` chequea sesión y usa `router.replace`, botón con estado `isLoading` (disabled durante OAuth redirect), SVG del logo de Google con los 4 colores oficiales inline, mensaje de error reactivo bajo el botón.
**Cambié:** nada del pedido — verifiqué contra la key real que confirmaste en `.env.local` (no la vi, solo comprobé que sigue git-ignorada).
**Por qué:** `vue-tsc -b` limpio, levanté `npm run dev` y revisé en Chrome real (screenshot + consola sin errores) — cliente Supabase inicializa bien con la key real, sin excepciones de env vars.

---

## [04:38] — DashboardView.vue completo
**Pedí:** dashboard completo — navbar (logo, email, sign out), lista de `relocation_requests` con tarjetas (origin→destination, fecha, notas, badge status), botón "New Request" y "Edit" por tarjeta abriendo el mismo form panel, INSERT/UPDATE con `dispatcher_id = user.id`, carga inicial filtrada por dispatcher, suscripción realtime, sign out + redirect a `/login` si no hay sesión.
**Generó:** extraje el form a `components/RequestFormPanel.vue` (panel lateral, no inline en Dashboard — form con validación HTML nativa `required`, watch sobre `open`+`editing` pa resetear/precargar campos) y tipos en `types/relocation.ts`. En `DashboardView.vue`: `fetchRequests()` filtra por `dispatcher_id`, canal realtime con filtro `dispatcher_id=eq.${user.id}` que dispara refetch en cualquier evento (INSERT/UPDATE/DELETE), cleanup en `onUnmounted`. Guard de sesión en `onMounted` — sin sesión, redirect a `/login`.
**Cambié:** nada del pedido explícito. Decisión propia: en vez de mutar el array local tras guardar, dejo que el realtime dispare el refetch — una sola fuente de verdad, evita desincronización entre lo que se guardó y lo que se muestra.
**Por qué:** `vue-tsc -b` y `npm run build` limpios. Visual real con sesión activa queda pendiente — como dijiste, el testing de login→dashboard lo hacemos después.

---

## [04:45] — Verificación manual: login → dashboard
**Pedí:** (confirmación, no petición) — probaste el flujo real: login con Google redirige bien a `/dashboard`.
**Generó:** nada de código — solo registro el resultado.
**Cambié:** nada.
**Por qué:** confirma que `signInWithOAuth` + `redirectTo` + `authGuard` + detección de sesión (`detectSessionInUrl` default) funcionan juntos en producción real, no solo en teoría/build.

---

## [04:46] — Verificación manual: crear request
**Pedí:** (confirmación) — probaste crear una relocation request desde el panel y salió bien.
**Generó:** nada de código — registro el resultado.
**Cambié:** nada.
**Por qué:** confirma INSERT con `dispatcher_id = user.id`, status `available` por defecto, y refetch vía canal realtime mostrando la tarjeta nueva sin recargar página.

---

## [04:50] — Deploy a producción (Vercel)
**Pedí:** subir a producción con Vercel CLI y devolver URL. Usar `main` como rama de producción — merge de `dev` primero, seguir luego en `dev`.
**Generó:** merge fast-forward `dev` → `main` (sin commits propios en `main`, historial lineal intacto) + push. `vercel link` al proyecto (`badi21s-projects/web`), env vars de producción `VITE_SUPABASE_URL` y `VITE_SUPABASE_PUBLISHABLE_KEY` vía `vercel env add`, `vercel --prod`.
**Cambié:** primer deploy dio 404 en `/login` y `/dashboard` (solo `/` servía) — Vercel static hosting sin SPA fallback rompe `vue-router` en modo history. Añadí `web/vercel.json` con rewrite catch-all a `index.html` y redeploy.
**Por qué:** verifiqué las 3 rutas con `curl` (200 en `/`, `/login`, `/dashboard`) antes de dar la URL por buena — sin el rewrite, el `redirectTo: '/dashboard'` del login con Google hubiera devuelto 404 en producción.

**URL producción:** https://web-six-nu-yy1480hzgt.vercel.app

**Pendiente (no lo puedo hacer yo):** añadir esa URL a la lista de "Redirect URLs" en Supabase Dashboard → Authentication → URL Configuration. Sin eso, Supabase puede rechazar el `redirectTo` en producción aunque local funcione (localhost suele estar ya en la lista por defecto).

---

## [05:05] — Scaffold Driver App (Flutter, /mobile)
**Pedí:** `flutter create mobile --org io.flovi --project-name flovi_driver`, `supabase_flutter ^2.0.0`, init Supabase en `main.dart` con url+anonKey dados, redirect LoginScreen/GigsScreen según sesión, `LoginScreen` (centrado, "Flovi Driver" + subtítulo, botón Google con `redirectTo: 'https://web-six-nu-yy1480hzgt.vercel.app/auth/callback'`, error en snackbar), `GigsScreen` placeholder, y que `flutter run -d chrome` funcione.
**Generó:** antes de tocar código, marqué que ese `redirectTo` apunta al dominio de la web dispatcher, no a la Driver App — con eso, tras loguear en local (`flutter run -d chrome`, corre en localhost:PUERTO), Google devuelve al usuario a producción del dispatcher en vez de a la Driver App local, y de paso `/auth/callback` no existe en el router Vue. Preguntado, elegiste `redirectTo` dinámico (`Uri.base.origin`, solo en web vía `kIsWeb`) — funciona en local y en el dominio real cuando se despliegue, sin tocar código después.
**Cambié:** `anonKey` → `publishableKey` en `Supabase.initialize` — `flutter analyze` marcó `anonKey` deprecado en `supabase_flutter` 2.15 (mismo naming "publishable key" que ya usa el proyecto). Reescribí `test/widget_test.dart` — el test template por defecto (contador +1) fallaba contra el nuevo `main.dart`; ahora verifica que `LoginScreen` muestra título/subtítulo/botón.
**Por qué:** `flutter analyze` limpio, `flutter test` pasa, `flutter build web` limpio, y arranqué `flutter run -d chrome` real — confirmado en Chrome (screenshot): Supabase inicializa, sin sesión muestra LoginScreen con el diseño pedido.
