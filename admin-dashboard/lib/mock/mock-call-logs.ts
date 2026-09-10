import type { CallLog } from "./types";

export const mockCallLogs: CallLog[] = [
  {
    id: "cl_001",
    vehicleId: "veh_001",
    ownerId: "usr_001",
    scannerUserId: null,
    timestamp: "2025-09-21T08:15:00Z",
    reason: "Blocking driveway",
    deliveryMethod: "call",
    deliveryStatus: "success",
    flaggedAbusive: false,
  },
  {
    id: "cl_002",
    vehicleId: "veh_001",
    ownerId: "usr_001",
    scannerUserId: "usr_008",
    timestamp: "2025-09-20T18:40:00Z",
    reason: "Lights left on",
    deliveryMethod: "push",
    deliveryStatus: "success",
    flaggedAbusive: false,
  },
  {
    id: "cl_003",
    vehicleId: "veh_002",
    ownerId: "usr_001",
    scannerUserId: null,
    timestamp: "2025-09-19T12:00:00Z",
    reason: "Emergency contact",
    deliveryMethod: "sms",
    deliveryStatus: "success",
    flaggedAbusive: false,
  },
  {
    id: "cl_004",
    vehicleId: "veh_003",
    ownerId: "usr_002",
    scannerUserId: "usr_005",
    timestamp: "2025-09-18T09:30:00Z",
    reason: "Wrong parking spot",
    deliveryMethod: "call",
    deliveryStatus: "failed",
    flaggedAbusive: false,
    metadata: "Voice gateway timeout",
  },
  {
    id: "cl_005",
    vehicleId: "veh_004",
    ownerId: "usr_003",
    scannerUserId: null,
    timestamp: "2025-09-17T22:10:00Z",
    reason: "Other",
    deliveryMethod: "call",
    deliveryStatus: "success",
    flaggedAbusive: true,
    metadata: "Repeated anonymous calls overnight",
  },
  {
    id: "cl_006",
    vehicleId: "veh_004",
    ownerId: "usr_003",
    scannerUserId: null,
    timestamp: "2025-09-17T22:25:00Z",
    reason: "Other",
    deliveryMethod: "call",
    deliveryStatus: "success",
    flaggedAbusive: true,
  },
  {
    id: "cl_007",
    vehicleId: "veh_004",
    ownerId: "usr_003",
    scannerUserId: null,
    timestamp: "2025-09-17T22:40:00Z",
    reason: "Other",
    deliveryMethod: "sms",
    deliveryStatus: "success",
    flaggedAbusive: true,
  },
  {
    id: "cl_008",
    vehicleId: "veh_005",
    ownerId: "usr_004",
    scannerUserId: "usr_002",
    timestamp: "2025-09-16T14:20:00Z",
    reason: "Blocking driveway",
    deliveryMethod: "push",
    deliveryStatus: "success",
    flaggedAbusive: false,
  },
  {
    id: "cl_009",
    vehicleId: "veh_007",
    ownerId: "usr_006",
    scannerUserId: null,
    timestamp: "2025-09-15T11:05:00Z",
    reason: "Accident nearby",
    deliveryMethod: "call",
    deliveryStatus: "success",
    flaggedAbusive: false,
  },
  {
    id: "cl_010",
    vehicleId: "veh_008",
    ownerId: "usr_007",
    scannerUserId: "usr_011",
    timestamp: "2025-09-14T16:50:00Z",
    reason: "Lights left on",
    deliveryMethod: "sms",
    deliveryStatus: "failed",
    flaggedAbusive: false,
  },
  {
    id: "cl_011",
    vehicleId: "veh_009",
    ownerId: "usr_008",
    scannerUserId: null,
    timestamp: "2025-09-13T07:30:00Z",
    reason: "Wrong parking spot",
    deliveryMethod: "call",
    deliveryStatus: "success",
    flaggedAbusive: false,
  },
  {
    id: "cl_012",
    vehicleId: "veh_010",
    ownerId: "usr_009",
    scannerUserId: "usr_001",
    timestamp: "2025-09-12T19:00:00Z",
    reason: "Emergency contact",
    deliveryMethod: "push",
    deliveryStatus: "success",
    flaggedAbusive: false,
  },
  {
    id: "cl_013",
    vehicleId: "veh_012",
    ownerId: "usr_011",
    scannerUserId: null,
    timestamp: "2025-09-11T10:15:00Z",
    reason: "Blocking driveway",
    deliveryMethod: "call",
    deliveryStatus: "success",
    flaggedAbusive: false,
  },
  {
    id: "cl_014",
    vehicleId: "veh_001",
    ownerId: "usr_001",
    scannerUserId: null,
    timestamp: "2025-09-21T09:00:00Z",
    reason: "Lights left on",
    deliveryMethod: "sms",
    deliveryStatus: "success",
    flaggedAbusive: false,
  },
  {
    id: "cl_015",
    vehicleId: "veh_014",
    ownerId: "usr_004",
    scannerUserId: "usr_012",
    timestamp: "2025-09-10T13:45:00Z",
    reason: "Other",
    deliveryMethod: "call",
    deliveryStatus: "success",
    flaggedAbusive: false,
  },
];

export function getCallLogs(): CallLog[] {
  return mockCallLogs;
}

export function getCallLogById(id: string): CallLog | undefined {
  return mockCallLogs.find((c) => c.id === id);
}

export function getCallLogsByVehicleId(vehicleId: string): CallLog[] {
  return mockCallLogs.filter((c) => c.vehicleId === vehicleId);
}

export function getCallLogsByUserId(userId: string): CallLog[] {
  return mockCallLogs.filter(
    (c) => c.ownerId === userId || c.scannerUserId === userId
  );
}

export function flagCallLogAbusive(id: string, flagged = true): CallLog | undefined {
  const log = mockCallLogs.find((c) => c.id === id);
  if (!log) return undefined;
  log.flaggedAbusive = flagged;
  return log;
}
