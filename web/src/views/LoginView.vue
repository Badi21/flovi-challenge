<script setup lang="ts">
import { supabase } from '@/lib/supabase'

async function signInWithGoogle() {
  await supabase.auth.signInWithOAuth({ provider: 'google' })
}
</script>

<template>
  <div>
    <h1>Login</h1>
    <button @click="signInWithGoogle">Sign in with Google</button>
  </div>
</template>
