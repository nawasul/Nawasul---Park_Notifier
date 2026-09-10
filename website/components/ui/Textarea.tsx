import type { TextareaHTMLAttributes } from "react";

type TextareaProps = TextareaHTMLAttributes<HTMLTextAreaElement> & {
  label?: string;
  error?: string;
  className?: string;
};

export function Textarea({
  label,
  error,
  id,
  className = "",
  ...props
}: TextareaProps) {
  const inputId = id ?? props.name;

  return (
    <label className="flex flex-col gap-2 text-sm text-text-primary">
      {label ? <span className="font-medium">{label}</span> : null}
      <textarea
        id={inputId}
        className={[
          "min-h-32 w-full rounded-md border-[1.5px] border-outline-variant bg-surface px-4 py-3",
          "text-base text-text-primary placeholder:text-text-muted",
          "focus:border-primary focus:border-2 focus:outline-none",
          error ? "border-error" : "",
          className,
        ].join(" ")}
        {...props}
      />
      {error ? <span className="text-sm text-error">{error}</span> : null}
    </label>
  );
}
