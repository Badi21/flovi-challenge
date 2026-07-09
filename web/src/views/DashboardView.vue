<script setup lang="ts">
import { onMounted, onUnmounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import type { RealtimeChannel, User } from '@supabase/supabase-js'
import { supabase } from '@/lib/supabase'
import type { RelocationRequest, RelocationRequestInput } from '@/types/relocation'
import RequestFormPanel from '@/components/RequestFormPanel.vue'

const router = useRouter()
const user = ref<User | null>(null)
const requests = ref<RelocationRequest[]>([])
const isPanelOpen = ref(false)
const editingRequest = ref<RelocationRequest | null>(null)

let channel: RealtimeChannel | null = null

async function fetchRequests() {
  if (!user.value) return

  const { data } = await supabase
    .from('relocation_requests')
    .select('*')
    .eq('dispatcher_id', user.value.id)
    .order('date', { ascending: true })

  requests.value = data ?? []
}

function subscribeToChanges() {
  if (!user.value) return

  channel = supabase
    .channel('relocation_requests_changes')
    .on(
      'postgres_changes',
      {
        event: '*',
        schema: 'public',
        table: 'relocation_requests',
        filter: `dispatcher_id=eq.${user.value.id}`,
      },
      () => fetchRequests(),
    )
    .subscribe()
}

function openCreatePanel() {
  editingRequest.value = null
  isPanelOpen.value = true
}

function openEditPanel(request: RelocationRequest) {
  editingRequest.value = request
  isPanelOpen.value = true
}

function closePanel() {
  isPanelOpen.value = false
  editingRequest.value = null
}

async function handleSubmit(input: RelocationRequestInput) {
  if (!user.value) return

  if (editingRequest.value) {
    await supabase.from('relocation_requests').update(input).eq('id', editingRequest.value.id)
  } else {
    await supabase
      .from('relocation_requests')
      .insert({ ...input, dispatcher_id: user.value.id, status: 'available' })
  }

  closePanel()
}

async function signOut() {
  await supabase.auth.signOut()
  router.replace('/login')
}

onMounted(async () => {
  const { data } = await supabase.auth.getSession()
  if (!data.session) {
    router.replace('/login')
    return
  }

  user.value = data.session.user
  await fetchRequests()
  subscribeToChanges()
})

onUnmounted(() => {
  channel?.unsubscribe()
})
</script>

<template>
  <div class="min-h-screen bg-gray-50">
    <nav class="flex items-center justify-between border-b border-slate-200 bg-white px-6 py-4">
      <span class="text-lg font-semibold tracking-tight text-slate-900">Flovi</span>
      <div class="flex items-center gap-4">
        <span class="text-sm text-slate-500">{{ user?.email }}</span>
        <button
          type="button"
          class="rounded-lg px-3 py-1.5 text-sm font-medium text-slate-600 hover:bg-slate-100"
          @click="signOut"
        >
          Sign out
        </button>
      </div>
    </nav>

    <main class="mx-auto max-w-3xl px-6 py-8">
      <div class="flex items-center justify-between">
        <h1 class="text-xl font-semibold text-slate-900">Relocation Requests</h1>
        <button
          type="button"
          class="rounded-lg bg-slate-900 px-4 py-2 text-sm font-medium text-white hover:bg-slate-800"
          @click="openCreatePanel"
        >
          New Request
        </button>
      </div>

      <p v-if="requests.length === 0" class="mt-8 text-sm text-slate-500">
        No relocation requests yet.
      </p>

      <ul v-else class="mt-6 space-y-3">
        <li
          v-for="request in requests"
          :key="request.id"
          class="rounded-xl bg-white p-4 shadow-sm shadow-gray-200/60"
        >
          <div class="flex items-start justify-between">
            <div>
              <p class="font-medium text-slate-900">
                {{ request.origin }} → {{ request.destination }}
              </p>
              <p class="mt-1 text-sm text-slate-500">{{ request.date }}</p>
              <p v-if="request.notes" class="mt-1 text-sm text-slate-500">{{ request.notes }}</p>
            </div>

            <div class="flex items-center gap-3">
              <span
                class="rounded-full px-2.5 py-1 text-xs font-medium"
                :class="
                  request.status === 'available'
                    ? 'bg-green-100 text-green-700'
                    : 'bg-slate-200 text-slate-600'
                "
              >
                {{ request.status === 'available' ? 'Available' : 'Booked' }}
              </span>
              <button
                type="button"
                class="text-sm font-medium text-slate-600 hover:text-slate-900"
                @click="openEditPanel(request)"
              >
                Edit
              </button>
            </div>
          </div>
        </li>
      </ul>
    </main>

    <RequestFormPanel
      :open="isPanelOpen"
      :editing="editingRequest"
      @close="closePanel"
      @submit="handleSubmit"
    />
  </div>
</template>
