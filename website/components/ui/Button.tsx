import type { ButtonHTMLAttributes, ReactNode } from "react";

type Variant = "primary" | "secondary" | "outline";
type Size = "md" | "sm" | "lg";

type ButtonProps = ButtonHTMLAttributes<HTMLButtonElement> & {
  variant?: Variant;
  size?: Size;
  children: ReactNode;
  className?: string;
};

const variantClasses: Record<Variant, string> = {
  primary:
    "bg-primary text-on-primary shadow-button hover:brightness-105 active:brightness-95",
  secondary:
    "bg-secondary-container text-primary hover:bg-surface-container-high",
  outline:
    "bg-transparent border-[1.5px] border-primary text-primary hover:bg-primary-container",
};

const sizeClasses: Record<Size, string> = {
  sm: "h-10 px-4 text-sm",
  md: "h-14 px-6 text-base",
  lg: "h-14 px-8 text-base",
};

export function Button({
  variant = "primary",
  size = "md",
  className = "",
  children,
  disabled,
  type = "button",
  ...props
}: ButtonProps) {
  return (
    <button
      type={type}
      disabled={disabled}
      className={[
        "inline-flex items-center justify-center gap-2 rounded-md font-semibold transition",
        "focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary",
        "disabled:pointer-events-none disabled:opacity-50",
        variantClasses[variant],
        sizeClasses[size],
        className,
      ].join(" ")}
      {...props}
    >
      {children}
    </button>
  );
}
