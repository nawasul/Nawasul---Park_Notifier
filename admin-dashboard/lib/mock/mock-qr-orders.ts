import type { QrOrder, QrOrderStatus } from "./types";

export const mockQrOrders: QrOrder[] = [
  {
    id: "ord_001",
    vehicleId: "veh_001",
    userId: "usr_001",
    status: "delivered",
    quantity: 2,
    shippingAddress: "Olaya St, Building 12, Apt 4",
    city: "Riyadh",
    orderDate: "2025-06-14T10:00:00Z",
    trackingNumber: "SA1234567890",
  },
  {
    id: "ord_002",
    vehicleId: "veh_002",
    userId: "usr_001",
    status: "delivered",
    quantity: 1,
    shippingAddress: "Olaya St, Building 12, Apt 4",
    city: "Riyadh",
    orderDate: "2025-06-21T11:00:00Z",
    trackingNumber: "SA1234567891",
  },
  {
    id: "ord_003",
    vehicleId: "veh_003",
    userId: "usr_002",
    status: "shipped",
    quantity: 1,
    shippingAddress: "Corniche Rd, Villa 8",
    city: "Jeddah",
    orderDate: "2025-08-28T09:00:00Z",
    trackingNumber: "SA2234567890",
  },
  {
    id: "ord_004",
    vehicleId: "veh_004",
    userId: "usr_003",
    status: "delivered",
    quantity: 1,
    shippingAddress: "King Fahd Rd, Apt 22",
    city: "Dammam",
    orderDate: "2025-07-20T08:00:00Z",
    trackingNumber: "SA3234567890",
  },
  {
    id: "ord_005",
    vehicleId: "veh_005",
    userId: "usr_004",
    status: "printed",
    quantity: 2,
    shippingAddress: "Diplomatic Quarter, House 3",
    city: "Riyadh",
    orderDate: "2025-09-01T12:00:00Z",
    trackingNumber: null,
  },
  {
    id: "ord_006",
    vehicleId: "veh_006",
    userId: "usr_005",
    status: "ordered",
    quantity: 1,
    shippingAddress: "Ajyad St, Apt 9",
    city: "Mecca",
    orderDate: "2025-09-12T10:00:00Z",
    trackingNumber: null,
  },
  {
    id: "ord_007",
    vehicleId: "veh_007",
    userId: "usr_006",
    status: "delivered",
    quantity: 1,
    shippingAddress: "Quba Rd, Villa 2",
    city: "Medina",
    orderDate: "2025-08-17T14:00:00Z",
    trackingNumber: "SA4234567890",
  },
  {
    id: "ord_008",
    vehicleId: "veh_008",
    userId: "usr_007",
    status: "shipped",
    quantity: 1,
    shippingAddress: "Corniche, Tower B, 15F",
    city: "Khobar",
    orderDate: "2025-09-05T09:30:00Z",
    trackingNumber: "SA5234567890",
  },
  {
    id: "ord_009",
    vehicleId: "veh_009",
    userId: "usr_008",
    status: "ordered",
    quantity: 1,
    shippingAddress: "Al-Andalus District, Apt 6",
    city: "Jeddah",
    orderDate: "2025-09-18T11:00:00Z",
    trackingNumber: null,
  },
  {
    id: "ord_010",
    vehicleId: "veh_010",
    userId: "usr_009",
    status: "printed",
    quantity: 2,
    shippingAddress: "Al-Nakheel, Compound Gate 2",
    city: "Riyadh",
    orderDate: "2025-09-08T10:00:00Z",
    trackingNumber: null,
  },
  {
    id: "ord_011",
    vehicleId: "veh_012",
    userId: "usr_011",
    status: "ordered",
    quantity: 1,
    shippingAddress: "Shafa District, House 14",
    city: "Taif",
    orderDate: "2025-09-20T13:00:00Z",
    trackingNumber: null,
  },
  {
    id: "ord_012",
    vehicleId: "veh_013",
    userId: "usr_012",
    status: "ordered",
    quantity: 2,
    shippingAddress: "Al-Malqa, Villa 21",
    city: "Riyadh",
    orderDate: "2025-09-21T10:00:00Z",
    trackingNumber: null,
  },
  {
    id: "ord_013",
    vehicleId: "veh_014",
    userId: "usr_004",
    status: "delivered",
    quantity: 1,
    shippingAddress: "Diplomatic Quarter, House 3",
    city: "Riyadh",
    orderDate: "2025-08-09T15:00:00Z",
    trackingNumber: "SA6234567890",
  },
];

export function getQrOrders(): QrOrder[] {
  return mockQrOrders;
}

export function getQrOrderById(id: string): QrOrder | undefined {
  return mockQrOrders.find((o) => o.id === id);
}

export function getQrOrdersByVehicleId(vehicleId: string): QrOrder[] {
  return mockQrOrders.filter((o) => o.vehicleId === vehicleId);
}

export function getQrOrdersByUserId(userId: string): QrOrder[] {
  return mockQrOrders.filter((o) => o.userId === userId);
}

export function updateQrOrderStatus(ids: string[], status: QrOrderStatus): QrOrder[] {
  const updated: QrOrder[] = [];
  for (const id of ids) {
    const order = mockQrOrders.find((o) => o.id === id);
    if (order) {
      order.status = status;
      updated.push(order);
    }
  }
  return updated;
}

export function updateQrOrderTracking(id: string, trackingNumber: string): QrOrder | undefined {
  const order = mockQrOrders.find((o) => o.id === id);
  if (!order) return undefined;
  order.trackingNumber = trackingNumber;
  return order;
}
