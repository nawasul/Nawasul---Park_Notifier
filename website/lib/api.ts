/**
 * Typed API helpers for the FastAPI backend.
 * Currently MOCKED — swap mock bodies for real `apiFetch` calls later.
 */

const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL ?? "http://localhost:8000";

export async function apiFetch<T>(
  path: string,
  init?: RequestInit
): Promise<T> {
  const response = await fetch(`${API_BASE_URL}${path}`, {
    ...init,
    headers: {
      "Content-Type": "application/json",
      ...init?.headers,
    },
  });

  if (!response.ok) {
    throw new Error(`API error: ${response.status} ${response.statusText}`);
  }

  return response.json() as Promise<T>;
}

export type QrVehicleInfo = {
  vehicleMake: string;
  vehicleModel: string;
  plateNumberMasked: string;
  ownerFirstName: string;
};

export type NotifyReason =
  | "blocking"
  | "lights"
  | "flat_tire"
  | "other";

export type NotifyQrResult = {
  success: true;
  message: string;
};

export class QrNotFoundError extends Error {
  constructor(code: string) {
    super(`QR code not found: ${code}`);
    this.name = "QrNotFoundError";
  }
}

const MOCK_VEHICLES: Record<string, QrVehicleInfo> = {
  DEMO01: {
    vehicleMake: "Toyota",
    vehicleModel: "Camry",
    plateNumberMasked: "ABC •••4",
    ownerFirstName: "Ahmed",
  },
  DEMO02: {
    vehicleMake: "Hyundai",
    vehicleModel: "Sonata",
    plateNumberMasked: "XYZ •••9",
    ownerFirstName: "Layla",
  },
};

function delay(ms: number) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

/** GET /api/v1/qr/{code} — mocked */
export async function getQrInfo(code: string): Promise<QrVehicleInfo> {
  await delay(400);
  const key = code.trim().toUpperCase();
  const info = MOCK_VEHICLES[key];
  if (!info) {
    throw new QrNotFoundError(code);
  }
  return info;
  // Real swap-in:
  // return apiFetch<QrVehicleInfo>(`/api/v1/qr/${encodeURIComponent(code)}`);
}

/** POST /api/v1/qr/{code}/notify — mocked */
export async function notifyQrOwner(
  code: string,
  payload?: { reason?: NotifyReason }
): Promise<NotifyQrResult> {
  await delay(600);
  const key = code.trim().toUpperCase();
  if (!MOCK_VEHICLES[key]) {
    throw new QrNotFoundError(code);
  }
  void payload;
  return {
    success: true,
    message: "Owner has been notified via call/notification",
  };
  // Real swap-in:
  // return apiFetch<NotifyQrResult>(`/api/v1/qr/${encodeURIComponent(code)}/notify`, {
  //   method: "POST",
  //   body: JSON.stringify(payload ?? {}),
  // });
}
