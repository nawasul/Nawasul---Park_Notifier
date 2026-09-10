/** Server-safe auth helpers. Client session lives in AuthProvider + localStorage. */

export type { AdminSession } from "@/components/providers/AuthProvider";
export type { AdminRole } from "@/lib/mock/types";

export function isAuthenticatedClient(): boolean {
  if (typeof window === "undefined") return false;
  try {
    return Boolean(localStorage.getItem("nawasul_admin_session"));
  } catch {
    return false;
  }
}
