"use client";

import type { NotifyReason } from "@/lib/api";

const REASONS: { id: NotifyReason; key: string }[] = [
  { id: "blocking", key: "reasonBlocking" },
  { id: "lights", key: "reasonLights" },
  { id: "flat_tire", key: "reasonFlat" },
  { id: "other", key: "reasonOther" },
];

export function QRReasonChips({
  label,
  labels,
  value,
  onChange,
}: {
  label: string;
  labels: Record<NotifyReason, string>;
  value: NotifyReason | null;
  onChange: (reason: NotifyReason | null) => void;
}) {
  return (
    <div>
      <p className="mb-3 text-sm font-medium text-text-secondary">{label}</p>
      <div className="flex flex-wrap gap-2">
        {REASONS.map((r) => {
          const selected = value === r.id;
          return (
            <button
              key={r.id}
              type="button"
              onClick={() => onChange(selected ? null : r.id)}
              className={[
                "rounded-pill border px-3 py-2 text-sm font-medium transition",
                selected
                  ? "border-primary bg-primary-container text-primary"
                  : "border-outline-variant bg-surface text-text-secondary",
              ].join(" ")}
            >
              {labels[r.id]}
            </button>
          );
        })}
      </div>
    </div>
  );
}
