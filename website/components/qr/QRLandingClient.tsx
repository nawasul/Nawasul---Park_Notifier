"use client";

import { useEffect, useMemo, useState } from "react";
import {
  getQrInfo,
  notifyQrOwner,
  QrNotFoundError,
  type NotifyReason,
  type QrVehicleInfo,
} from "@/lib/api";
import { QRErrorState } from "@/components/qr/QRErrorState";
import { QRNotifyButton } from "@/components/qr/QRNotifyButton";
import { QRReasonChips } from "@/components/qr/QRReasonChips";
import { QRSuccessState } from "@/components/qr/QRSuccessState";
import { QRVehicleSummary } from "@/components/qr/QRVehicleSummary";

type QrCopy = {
  loading: string;
  notify: string;
  notifying: string;
  reasonLabel: string;
  reasonBlocking: string;
  reasonLights: string;
  reasonFlat: string;
  reasonOther: string;
  successTitle: string;
  successBody: string;
  errorTitle: string;
  errorBody: string;
  vehicleLabel: string;
  privacyNote: string;
};

type Status = "loading" | "ready" | "success" | "error";

export function QRLandingClient({
  code,
  copy,
}: {
  code: string;
  copy: QrCopy;
}) {
  const [status, setStatus] = useState<Status>("loading");
  const [info, setInfo] = useState<QrVehicleInfo | null>(null);
  const [reason, setReason] = useState<NotifyReason | null>(null);
  const [notifying, setNotifying] = useState(false);

  const reasonLabels = useMemo(
    () => ({
      blocking: copy.reasonBlocking,
      lights: copy.reasonLights,
      flat_tire: copy.reasonFlat,
      other: copy.reasonOther,
    }),
    [copy]
  );

  useEffect(() => {
    let cancelled = false;
    setStatus("loading");
    getQrInfo(code)
      .then((data) => {
        if (cancelled) return;
        setInfo(data);
        setStatus("ready");
      })
      .catch((err) => {
        if (cancelled) return;
        if (err instanceof QrNotFoundError) {
          setStatus("error");
        } else {
          setStatus("error");
        }
      });
    return () => {
      cancelled = true;
    };
  }, [code]);

  async function handleNotify() {
    setNotifying(true);
    try {
      await notifyQrOwner(code, { reason: reason ?? undefined });
      setStatus("success");
    } catch {
      setStatus("error");
    } finally {
      setNotifying(false);
    }
  }

  if (status === "loading") {
    return (
      <p className="py-12 text-center text-text-secondary">{copy.loading}</p>
    );
  }

  if (status === "error") {
    return <QRErrorState title={copy.errorTitle} body={copy.errorBody} />;
  }

  if (status === "success") {
    return (
      <QRSuccessState title={copy.successTitle} body={copy.successBody} />
    );
  }

  if (!info) return null;

  return (
    <div className="flex flex-col gap-6">
      <QRVehicleSummary info={info} vehicleLabel={copy.vehicleLabel} />
      <p className="text-center text-xs text-text-muted">{copy.privacyNote}</p>
      <QRReasonChips
        label={copy.reasonLabel}
        labels={reasonLabels}
        value={reason}
        onChange={setReason}
      />
      <QRNotifyButton
        label={copy.notify}
        loadingLabel={copy.notifying}
        loading={notifying}
        onClick={handleNotify}
      />
    </div>
  );
}
