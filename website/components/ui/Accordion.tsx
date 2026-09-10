"use client";

import {
  createContext,
  useContext,
  useId,
  useState,
  type ReactNode,
} from "react";

type AccordionContextValue = {
  openId: string | null;
  setOpenId: (id: string | null) => void;
};

const AccordionContext = createContext<AccordionContextValue | null>(null);

export function Accordion({
  children,
  className = "",
}: {
  children: ReactNode;
  className?: string;
}) {
  const [openId, setOpenId] = useState<string | null>(null);

  return (
    <AccordionContext.Provider value={{ openId, setOpenId }}>
      <div className={["flex flex-col gap-3", className].join(" ")}>
        {children}
      </div>
    </AccordionContext.Provider>
  );
}

export function AccordionItem({
  title,
  children,
  defaultOpen = false,
}: {
  title: string;
  children: ReactNode;
  defaultOpen?: boolean;
}) {
  const ctx = useContext(AccordionContext);
  const reactId = useId();
  const [localOpen, setLocalOpen] = useState(defaultOpen);

  const isControlled = Boolean(ctx);
  const open = isControlled ? ctx!.openId === reactId : localOpen;

  function toggle() {
    if (isControlled) {
      ctx!.setOpenId(open ? null : reactId);
    } else {
      setLocalOpen((v) => !v);
    }
  }

  return (
    <div className="overflow-hidden rounded-lg bg-surface shadow-card">
      <button
        type="button"
        onClick={toggle}
        aria-expanded={open}
        className="flex w-full items-center justify-between gap-4 px-5 py-4 text-start font-semibold text-text-primary"
      >
        <span>{title}</span>
        <span
          aria-hidden
          className={[
            "text-primary transition-transform",
            open ? "rotate-45" : "",
          ].join(" ")}
        >
          +
        </span>
      </button>
      {open ? (
        <div className="border-t border-outline-variant px-5 py-4 text-text-secondary leading-relaxed">
          {children}
        </div>
      ) : null}
    </div>
  );
}
