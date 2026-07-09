# Reflection — Flovi AI Build Challenge

## What worked well

**Supabase as the backbone.** Choosing Supabase early eliminated entire categories of work: Google OAuth, realtime subscriptions, row-level security, and the database — all handled by one service. The time saved not building auth from scratch went directly into product features.

**Decomposing before prompting.** The biggest mistake in AI-assisted development is pasting a wall of requirements into one prompt. I broke every feature into a single, specific task with explicit constraints (stack, table schema, behavior on error). The quality of the output was directly proportional to the precision of the input.

**The PROMPT_LOG as a forcing function.** Documenting each prompt decision in real time forced me to think before I typed. If I couldn't explain *why* I was asking for something, I wasn't ready to ask for it.

**TypeScript and Dart type systems as a safety net.** Running `vue-tsc -b` and `flutter analyze` after every generated file caught issues before they compounded. The AI generated structurally correct code, but the type checker caught subtle mismatches (deprecated `anonKey` → `publishableKey`, `baseUrl` deprecation in TS 6).

## What broke or needed correction

**The `redirectTo` issue in Flutter.** The original prompt hardcoded the Vue dispatcher URL as the OAuth callback — which would have sent the driver back to the wrong app after login. Caught it before writing code by reasoning through the redirect flow. Fixed with a dynamic `Uri.base.origin` approach that works in both local and production without touching code.

**The default Flutter test.** `flutter create` generates a counter increment test that immediately fails against a real app structure. The AI didn't flag this. I replaced it with a meaningful smoke test for `LoginScreen` before committing.

**`realtime` not enabled on the Supabase table.** The code was correct, but realtime subscriptions silently do nothing if the table doesn't have replication enabled in the Supabase dashboard. This is a configuration step the AI can't do — it only generates the client code.

**`flow_state_already_used` error.** Spent 10 minutes convinced there was a bug in my OAuth flow. The error was cryptic — Supabase doesn't tell you the state was consumed by a previous session. Turned out I had killed the Flutter process mid-login and the OAuth state was already used. No code change needed, but it's a good example of how AI-generated auth code can surface misleading errors when the dev environment is messy.

## Where AI got in the way

**Duplicated auth logic.** The first generation of `DashboardView.vue` included session guard logic inline in the component — the same check already handled by the router's `AuthGuard`. If I hadn't known the architecture, I would have left two sources of truth silently diverging. The AI had no way to know the guard existed elsewhere; I had to catch it.

**No opinion on architecture.** The AI executes what you specify but doesn't push back on structural decisions. The choice to keep realtime sync as a single source of truth (refetch from DB on every channel event, rather than mutating local state) was mine — the AI would have generated either pattern with equal confidence.

## If I had another hour

1. **Delete request** — dispatchers can't currently remove a request. One button, one `DELETE` query, one RLS policy update.
2. **My Bookings realtime** — the available gigs tab updates live; My Bookings doesn't. Consistent behavior matters for a real product.
3. **Error boundary on the Vue dashboard** — right now a failed Supabase call silently returns an empty list. A visible error state with a retry button would make the app production-ready.
4. **Flutter production OAuth test** — I verified the booking flow locally, not on `mobile-ten-khaki.vercel.app`. A real end-to-end test on the deployed URL is the last missing check.

## What this tells me about how software development is changing

The constraint is no longer *can you write the code* — it's *do you know what to ask for and whether the answer is correct*.

The engineers who will thrive are the ones who can decompose a problem precisely, recognize when generated output is wrong (not just when it errors), and understand the systems well enough to catch silent failures. AI makes mediocre engineers faster at writing mediocre code. It makes strong engineers dramatically faster at building real systems — because they spend their time on decisions, not syntax.

The PROMPT_LOG in this repo is the real artifact. The code is the output.
