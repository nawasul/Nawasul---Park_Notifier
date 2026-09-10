import type { AuditLogEntry } from "./types";

/**
 * NOTE: Once a real backend exists, every admin mutation (suspend user, update QR
 * order status, flag call log, etc.) should call an audit-log-writing function.
 * This file is display-only seed data for the mock phase.
 */
export const mockAuditLog: AuditLogEntry[] = [
  {
    id: "aud_001",
    adminId: "adm_001",
    adminName: "Sara Al-Harbi",
    action: "Suspended user",
    target: "Suspended User usr_003 (Khalid Mansour)",
    timestamp: "2025-09-18T00:30:00Z",
  },
  {
    id: "aud_002",
    adminId: "adm_001",
    adminName: "Sara Al-Harbi",
    action: "Deactivated QR",
    target: "Vehicle veh_004 (DAM 3456)",
    timestamp: "2025-09-18T00:32:00Z",
  },
  {
    id: "aud_003",
    adminId: "adm_002",
    adminName: "Omar Nasser",
    action: "Flagged call log as abusive",
    target: "CallLog cl_005",
    timestamp: "2025-09-17T23:10:00Z",
  },
  {
    id: "aud_004",
    adminId: "adm_002",
    adminName: "Omar Nasser",
    action: "Flagged call log as abusive",
    target: "CallLog cl_006",
    timestamp: "2025-09-17T23:11:00Z",
  },
  {
    id: "aud_005",
    adminId: "adm_003",
    adminName: "Layla Fulfillment",
    action: "Updated QR order status",
    target: "Order ord_005 → printed",
    timestamp: "2025-09-10T11:00:00Z",
  },
  {
    id: "aud_006",
    adminId: "adm_003",
    adminName: "Layla Fulfillment",
    action: "Updated QR order status",
    target: "Order ord_003 → shipped",
    timestamp: "2025-09-05T14:20:00Z",
  },
  {
    id: "aud_007",
    adminId: "adm_002",
    adminName: "Omar Nasser",
    action: "Resolved support ticket",
    target: "Ticket tkt_003",
    timestamp: "2025-09-18T01:00:00Z",
  },
  {
    id: "aud_008",
    adminId: "adm_001",
    adminName: "Sara Al-Harbi",
    action: "Updated rate-limit threshold",
    target: "App config: max notifications/hour = 5",
    timestamp: "2025-09-01T09:00:00Z",
  },
  {
    id: "aud_009",
    adminId: "adm_001",
    adminName: "Sara Al-Harbi",
    action: "Invited admin",
    target: "Invited layla@nawasul.app (fulfillment_staff)",
    timestamp: "2025-05-01T07:50:00Z",
  },
  {
    id: "aud_010",
    adminId: "adm_002",
    adminName: "Omar Nasser",
    action: "Updated internal notes",
    target: "User usr_001",
    timestamp: "2025-09-12T10:00:00Z",
  },
  {
    id: "aud_011",
    adminId: "adm_003",
    adminName: "Layla Fulfillment",
    action: "Set tracking number",
    target: "Order ord_008 → SA5234567890",
    timestamp: "2025-09-06T09:00:00Z",
  },
  {
    id: "aud_012",
    adminId: "adm_001",
    adminName: "Sara Al-Harbi",
    action: "Triggered account deletion",
    target: "User usr_010 (Maha Al-Zahrani)",
    timestamp: "2025-09-07T16:00:00Z",
  },
];

export function getAuditLog(): AuditLogEntry[] {
  return [...mockAuditLog].sort(
    (a, b) => new Date(b.timestamp).getTime() - new Date(a.timestamp).getTime()
  );
}
