import type { HTMLAttributes, ReactNode } from "react";

type CardProps = HTMLAttributes<HTMLDivElement> & {
  children: ReactNode;
  className?: string;
};

export function Card({ children, className = "", ...props }: CardProps) {
  return (
    <div
      className={[
        "rounded-lg bg-surface p-6 shadow-card",
        className,
      ].join(" ")}
      {...props}
    >
      {children}
    </div>
  );
}
