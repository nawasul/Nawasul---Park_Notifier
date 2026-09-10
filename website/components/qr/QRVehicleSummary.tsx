import type { QrVehicleInfo } from "@/lib/api";

export function QRVehicleSummary({
  info,
  vehicleLabel,
}: {
  info: QrVehicleInfo;
  vehicleLabel: string;
}) {
  return (
    <div className="rounded-lg bg-surface p-5 shadow-card">
      <p className="text-xs font-semibold uppercase tracking-wide text-text-muted">
        {vehicleLabel}
      </p>
      <p className="mt-2 font-heading text-xl font-semibold text-text-primary">
        {info.vehicleMake} {info.vehicleModel}
      </p>
      <p className="mt-1 text-text-secondary">{info.plateNumberMasked}</p>
    </div>
  );
}
