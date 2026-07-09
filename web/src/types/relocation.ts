export type RelocationStatus = 'available' | 'booked'

export interface RelocationRequest {
  id: string
  dispatcher_id: string
  origin: string
  destination: string
  date: string
  notes: string | null
  status: RelocationStatus
  created_at: string
}

export interface RelocationRequestInput {
  origin: string
  destination: string
  date: string
  notes: string | null
}
