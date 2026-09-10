"use client";

import Chip from "@mui/material/Chip";
import { useTheme } from "@mui/material/styles";

type Tone = "default" | "success" | "warning" | "error" | "info" | "primary";

const STATUS_TONE: Record<string, Tone> = {
  // account
  active: "success",
  suspended: "warning",
  deleted: "error",
  // qr order
  ordered: "info",
  printed: "warning",
  shipped: "primary",
  delivered: "success",
  // qr / vehicle
  inactive: "error",
  pending: "warning",
  // subscription
  cancelled: "warning",
  expired: "error",
  free: "default",
  pro: "primary",
  premium: "success",
  // delivery
  success: "success",
  failed: "error",
  // tickets
  open: "warning",
  in_progress: "info",
  resolved: "success",
  // flags
  flagged: "error",
};

function labelize(value: string): string {
  return value
    .split("_")
    .map((w) => w.charAt(0).toUpperCase() + w.slice(1))
    .join(" ");
}

type StatusChipProps = {
  status: string;
  label?: string;
  tone?: Tone;
};

export function StatusChip({ status, label, tone }: StatusChipProps) {
  const theme = useTheme();
  const resolved = tone ?? STATUS_TONE[status.toLowerCase()] ?? "default";

  const colors: Record<Tone, { bg: string; fg: string }> = {
    default: { bg: theme.palette.grey[100], fg: theme.palette.text.secondary },
    success: { bg: theme.palette.success.light, fg: theme.palette.success.main },
    warning: { bg: theme.palette.warning.light, fg: theme.palette.warning.main },
    error: { bg: theme.palette.error.light, fg: theme.palette.error.main },
    info: { bg: theme.palette.grey[200], fg: theme.palette.text.primary },
    primary: { bg: theme.palette.primary.light, fg: theme.palette.primary.main },
  };

  const c = colors[resolved];

  return (
    <Chip
      size="small"
      label={label ?? labelize(status)}
      sx={{
        bgcolor: c.bg,
        color: c.fg,
        fontWeight: 600,
        borderRadius: 1.5,
      }}
    />
  );
}
