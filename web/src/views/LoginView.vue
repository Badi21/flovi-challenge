<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { supabase } from '@/lib/supabase'

const router = useRouter()
const errorMessage = ref<string | null>(null)
const isLoading = ref(false)

onMounted(async () => {
  const { data } = await supabase.auth.getSession()
  if (data.session) {
    router.replace('/dashboard')
  }
})

async function signInWithGoogle() {
  errorMessage.value = null
  isLoading.value = true

  const { error } = await supabase.auth.signInWithOAuth({
    provider: 'google',
    options: {
      redirectTo: window.location.origin + '/dashboard',
    },
  })

  if (error) {
    errorMessage.value = error.message
    isLoading.value = false
  }
}
</script>

<template>
  <div class="flex min-h-screen items-center justify-center bg-gray-50 px-4">
    <div class="w-full max-w-sm rounded-2xl bg-white p-8 shadow-lg shadow-gray-200/60">
      <div class="mb-8 text-center">
        <h1 class="text-2xl font-semibold tracking-tight text-slate-900">Flovi Dispatcher</h1>
        <p class="mt-1 text-sm text-slate-500">Vehicle relocation management</p>
      </div>

      <button
        type="button"
        :disabled="isLoading"
        @click="signInWithGoogle"
        class="flex w-full items-center justify-center gap-3 rounded-lg border border-slate-200 bg-white px-4 py-2.5 text-sm font-medium text-slate-700 shadow-sm transition hover:bg-slate-50 disabled:cursor-not-allowed disabled:opacity-60"
      >
        <svg class="h-5 w-5" viewBox="0 0 24 24" aria-hidden="true">
          <path
            fill="#4285F4"
            d="M23.52 12.27c0-.79-.07-1.54-.2-2.27H12v4.3h6.47c-.28 1.5-1.13 2.77-2.4 3.62v3.01h3.87c2.27-2.09 3.58-5.17 3.58-8.66z"
          />
          <path
            fill="#34A853"
            d="M12 24c3.24 0 5.96-1.07 7.94-2.9l-3.87-3.01c-1.08.72-2.46 1.15-4.07 1.15-3.13 0-5.78-2.11-6.73-4.96H1.24v3.11C3.2 21.3 7.26 24 12 24z"
          />
          <path
            fill="#FBBC05"
            d="M5.27 14.28A7.14 7.14 0 0 1 4.9 12c0-.79.14-1.56.37-2.28V6.61H1.24A11.93 11.93 0 0 0 0 12c0 1.93.46 3.76 1.24 5.39l4.03-3.11z"
          />
          <path
            fill="#EA4335"
            d="M12 4.75c1.77 0 3.35.61 4.6 1.8l3.42-3.42C17.95 1.19 15.24 0 12 0 7.26 0 3.2 2.7 1.24 6.61l4.03 3.11C6.22 6.86 8.87 4.75 12 4.75z"
          />
        </svg>
        Continue with Google
      </button>

      <p v-if="errorMessage" class="mt-3 text-center text-sm text-red-600">
        {{ errorMessage }}
      </p>
    </div>
  </div>
</template>
