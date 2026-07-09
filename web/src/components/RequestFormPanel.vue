<script setup lang="ts">
import { reactive, watch } from 'vue'
import type { RelocationRequest, RelocationRequestInput } from '@/types/relocation'

const props = defineProps<{
  open: boolean
  editing: RelocationRequest | null
}>()

const emit = defineEmits<{
  close: []
  submit: [input: RelocationRequestInput]
}>()

const form = reactive<RelocationRequestInput>({
  origin: '',
  destination: '',
  date: '',
  notes: '',
})

function resetForm(source: RelocationRequest | null) {
  form.origin = source?.origin ?? ''
  form.destination = source?.destination ?? ''
  form.date = source?.date ?? ''
  form.notes = source?.notes ?? ''
}

watch(
  () => [props.open, props.editing] as const,
  ([isOpen, editing]) => {
    if (isOpen) resetForm(editing)
  },
  { immediate: true },
)

function handleSubmit() {
  emit('submit', {
    origin: form.origin,
    destination: form.destination,
    date: form.date,
    notes: form.notes?.trim() ? form.notes : null,
  })
}
</script>

<template>
  <div v-if="open" class="fixed inset-0 z-50 flex justify-end bg-black/30" @click.self="emit('close')">
    <aside class="h-full w-full max-w-md bg-white p-6 shadow-xl">
      <h2 class="text-lg font-semibold text-slate-900">
        {{ editing ? 'Edit Request' : 'New Request' }}
      </h2>

      <form class="mt-6 space-y-4" @submit.prevent="handleSubmit">
        <div>
          <label for="origin" class="block text-sm font-medium text-slate-700">Origin</label>
          <input
            id="origin"
            v-model="form.origin"
            type="text"
            required
            class="mt-1 w-full rounded-lg border border-slate-200 px-3 py-2 text-sm text-slate-900 focus:border-slate-400 focus:outline-none"
          />
        </div>

        <div>
          <label for="destination" class="block text-sm font-medium text-slate-700">Destination</label>
          <input
            id="destination"
            v-model="form.destination"
            type="text"
            required
            class="mt-1 w-full rounded-lg border border-slate-200 px-3 py-2 text-sm text-slate-900 focus:border-slate-400 focus:outline-none"
          />
        </div>

        <div>
          <label for="date" class="block text-sm font-medium text-slate-700">Date</label>
          <input
            id="date"
            v-model="form.date"
            type="date"
            required
            class="mt-1 w-full rounded-lg border border-slate-200 px-3 py-2 text-sm text-slate-900 focus:border-slate-400 focus:outline-none"
          />
        </div>

        <div>
          <label for="notes" class="block text-sm font-medium text-slate-700">Notes</label>
          <textarea
            id="notes"
            v-model="form.notes"
            rows="3"
            class="mt-1 w-full rounded-lg border border-slate-200 px-3 py-2 text-sm text-slate-900 focus:border-slate-400 focus:outline-none"
          />
        </div>

        <div class="flex justify-end gap-3 pt-2">
          <button
            type="button"
            class="rounded-lg px-4 py-2 text-sm font-medium text-slate-600 hover:bg-slate-100"
            @click="emit('close')"
          >
            Cancel
          </button>
          <button
            type="submit"
            class="rounded-lg bg-slate-900 px-4 py-2 text-sm font-medium text-white hover:bg-slate-800"
          >
            Save
          </button>
        </div>
      </form>
    </aside>
  </div>
</template>
