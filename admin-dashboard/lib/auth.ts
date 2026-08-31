/** Auth helpers stub for admin session handling. */

export type AdminSession = {
  token: string;
  email: string;
} | null;

export function getAdminSession(): AdminSession {
  return null;
}

export function isAuthenticated(): boolean {
  return getAdminSession() !== null;
}
