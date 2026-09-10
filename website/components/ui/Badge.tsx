import type { HTMLAttributes, ReactNode } from "react";

type BadgeTone = "live" | "coming_soon" | "success" | "warning" | "error" | "neutral";

type BadgeProps = HTMLAttributes<HTMLSpanElement> & {
  children: ReactNode;
  tone?: BadgeTone;
  className?: string;
};

const toneClasses: Record<BadgeTone, string> = {
  live: "bg-success-container text-success",
  coming_soon: "bg-warning-container text-warning",
  success: "bg-success-container text-success",
  warning: "bg-warning-container text-warning",
  error: "bg-error-container text-error",
  neutral: "bg-secondary-container text-text-secondary",
};

export function Badge({
  children,
  tone = "neutral",
  className = "",
  ...props
}: BadgeProps) {
  return (
    <span
      className={[
        "inline-flex items-center rounded-pill px-3 py-1 text-caption font-medium text-xs tracking-wide",
        toneClasses[tone],
        className,
      ].join(" ")}
      {...props}
    >
      {children}
    </span>
  );
}

export function StatusPill(props: BadgeProps) {
  return <Badge {...props} />;
}
