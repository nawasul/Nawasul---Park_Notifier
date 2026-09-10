"use client";

import { Button } from "@/components/ui/Button";

export function QRNotifyButton({
  label,
  loadingLabel,
  loading,
  onClick,
}: {
  label: string;
  loadingLabel: string;
  loading: boolean;
  onClick: () => void;
}) {
  return (
    <Button
      className="w-full"
      size="lg"
      disabled={loading}
      onClick={onClick}
    >
      {loading ? loadingLabel : label}
    </Button>
  );
}
