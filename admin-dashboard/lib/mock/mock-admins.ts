import type { AdminUser } from "./types";

/** Demo password for all seeded admins: `nawasul-admin` */
export const DEMO_PASSWORD = "nawasul-admin";

export const mockAdmins: AdminUser[] = [
  {
    id: "adm_001",
    name: "Sara Al-Harbi",
    email: "sara@nawasul.app",
    role: "super_admin",
    password: DEMO_PASSWORD,
    createdAt: "2025-01-10T09:00:00Z",
  },
  {
    id: "adm_002",
    name: "Omar Nasser",
    email: "omar@nawasul.app",
    role: "support_agent",
    password: DEMO_PASSWORD,
    createdAt: "2025-03-15T11:30:00Z",
  },
  {
    id: "adm_003",
    name: "Layla Fulfillment",
    email: "layla@nawasul.app",
    role: "fulfillment_staff",
    password: DEMO_PASSWORD,
    createdAt: "2025-05-01T08:00:00Z",
  },
];

export function getAdmins(): AdminUser[] {
  return mockAdmins;
}

export function getAdminById(id: string): AdminUser | undefined {
  return mockAdmins.find((a) => a.id === id);
}

export function authenticateAdmin(email: string, password: string): AdminUser | null {
  const admin = mockAdmins.find(
    (a) => a.email.toLowerCase() === email.trim().toLowerCase() && a.password === password
  );
  return admin ?? null;
}
