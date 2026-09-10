import type { Vehicle } from "./types";

export const mockVehicles: Vehicle[] = [
  {
    id: "veh_001",
    make: "Toyota",
    model: "Camry",
    year: 2022,
    plateNumber: "ABC 1234",
    ownerId: "usr_001",
    qrStatus: "active",
    flaggedForReview: false,
    createdAt: "2025-06-13T10:00:00Z",
  },
  {
    id: "veh_002",
    make: "Lexus",
    model: "RX 350",
    year: 2023,
    plateNumber: "XYZ 5678",
    ownerId: "usr_001",
    qrStatus: "active",
    flaggedForReview: false,
    createdAt: "2025-06-20T11:00:00Z",
  },
  {
    id: "veh_003",
    make: "Hyundai",
    model: "Tucson",
    year: 2021,
    plateNumber: "JED 9012",
    ownerId: "usr_002",
    qrStatus: "active",
    flaggedForReview: false,
    createdAt: "2025-07-02T09:00:00Z",
  },
  {
    id: "veh_004",
    make: "Nissan",
    model: "Patrol",
    year: 2020,
    plateNumber: "DAM 3456",
    ownerId: "usr_003",
    qrStatus: "inactive",
    flaggedForReview: true,
    createdAt: "2025-07-19T08:00:00Z",
  },
  {
    id: "veh_005",
    make: "BMW",
    model: "X5",
    year: 2024,
    plateNumber: "RYD 7788",
    ownerId: "usr_004",
    qrStatus: "active",
    flaggedForReview: false,
    createdAt: "2025-08-03T12:00:00Z",
  },
  {
    id: "veh_006",
    make: "Kia",
    model: "Sportage",
    year: 2022,
    plateNumber: "MEC 1122",
    ownerId: "usr_005",
    qrStatus: "pending",
    flaggedForReview: false,
    createdAt: "2025-08-11T10:00:00Z",
  },
  {
    id: "veh_007",
    make: "Mercedes",
    model: "C200",
    year: 2023,
    plateNumber: "MED 3344",
    ownerId: "usr_006",
    qrStatus: "active",
    flaggedForReview: false,
    createdAt: "2025-08-16T14:00:00Z",
  },
  {
    id: "veh_008",
    make: "Ford",
    model: "Explorer",
    year: 2021,
    plateNumber: "KHB 5566",
    ownerId: "usr_007",
    qrStatus: "active",
    flaggedForReview: false,
    createdAt: "2025-08-21T09:30:00Z",
  },
  {
    id: "veh_009",
    make: "Honda",
    model: "Accord",
    year: 2020,
    plateNumber: "JED 7788",
    ownerId: "usr_008",
    qrStatus: "active",
    flaggedForReview: false,
    createdAt: "2025-08-26T11:00:00Z",
  },
  {
    id: "veh_010",
    make: "Genesis",
    model: "G80",
    year: 2024,
    plateNumber: "RYD 9900",
    ownerId: "usr_009",
    qrStatus: "active",
    flaggedForReview: false,
    createdAt: "2025-09-02T10:00:00Z",
  },
  {
    id: "veh_011",
    make: "Chevrolet",
    model: "Tahoe",
    year: 2019,
    plateNumber: "ABH 1212",
    ownerId: "usr_010",
    qrStatus: "inactive",
    flaggedForReview: false,
    createdAt: "2025-09-06T08:00:00Z",
  },
  {
    id: "veh_012",
    make: "Mazda",
    model: "CX-5",
    year: 2023,
    plateNumber: "TAF 3434",
    ownerId: "usr_011",
    qrStatus: "active",
    flaggedForReview: false,
    createdAt: "2025-09-11T13:00:00Z",
  },
  {
    id: "veh_013",
    make: "Toyota",
    model: "Land Cruiser",
    year: 2024,
    plateNumber: "RYD 5656",
    ownerId: "usr_012",
    qrStatus: "pending",
    flaggedForReview: false,
    createdAt: "2025-09-16T10:00:00Z",
  },
  {
    id: "veh_014",
    make: "GMC",
    model: "Yukon",
    year: 2022,
    plateNumber: "RYD 7878",
    ownerId: "usr_004",
    qrStatus: "active",
    flaggedForReview: false,
    createdAt: "2025-08-08T15:00:00Z",
  },
];

export function getVehicles(): Vehicle[] {
  return mockVehicles;
}

export function getVehicleById(id: string): Vehicle | undefined {
  return mockVehicles.find((v) => v.id === id);
}

export function getVehiclesByOwnerId(ownerId: string): Vehicle[] {
  return mockVehicles.filter((v) => v.ownerId === ownerId);
}

export function deactivateVehicleQr(id: string): Vehicle | undefined {
  const vehicle = mockVehicles.find((v) => v.id === id);
  if (!vehicle) return undefined;
  vehicle.qrStatus = "inactive";
  return vehicle;
}

export function flagVehicleForReview(id: string, flagged = true): Vehicle | undefined {
  const vehicle = mockVehicles.find((v) => v.id === id);
  if (!vehicle) return undefined;
  vehicle.flaggedForReview = flagged;
  return vehicle;
}
