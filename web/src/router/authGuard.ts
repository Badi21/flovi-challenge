import type { NavigationGuardWithThis } from 'vue-router'
import { supabase } from '@/lib/supabase'

export const authGuard: NavigationGuardWithThis<undefined> = async (to) => {
  if (!to.meta.requiresAuth) return true

  const { data } = await supabase.auth.getSession()
  if (!data.session) {
    return { name: 'login' }
  }

  return true
}
