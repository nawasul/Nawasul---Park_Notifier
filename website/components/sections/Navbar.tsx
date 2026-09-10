"use client";

import { useLocale, useTranslations } from "next-intl";
import { useState } from "react";
import { Link, usePathname } from "@/i18n/navigation";
import { routing, type AppLocale } from "@/i18n/routing";

const navItems = [
  { href: "/", key: "home" as const },
  { href: "/about", key: "about" as const },
  { href: "/products", key: "products" as const },
  { href: "/contact", key: "contact" as const },
];

export function Navbar() {
  const t = useTranslations("Nav");
  const locale = useLocale();
  const pathname = usePathname();
  const [open, setOpen] = useState(false);

  return (
    <header className="sticky top-0 z-40 border-b border-outline-variant/60 bg-background/90 backdrop-blur-md">
      <div className="mx-auto flex h-16 max-w-6xl items-center justify-between gap-4 px-4 sm:px-6">
        <Link
          href="/"
          className="font-heading text-lg font-bold tracking-tight text-text-primary"
        >
          <span className="text-primary">Nawasul</span> Group
        </Link>

        <nav className="hidden items-center gap-6 md:flex" aria-label="Main">
          {navItems.map((item) => (
            <Link
              key={item.href}
              href={item.href}
              className={[
                "text-sm font-medium transition hover:text-primary",
                pathname === item.href
                  ? "text-primary"
                  : "text-text-secondary",
              ].join(" ")}
            >
              {t(item.key)}
            </Link>
          ))}
          <LanguageSwitcher locale={locale as AppLocale} />
        </nav>

        <div className="flex items-center gap-3 md:hidden">
          <LanguageSwitcher locale={locale as AppLocale} />
          <button
            type="button"
            className="rounded-md border border-outline-variant bg-surface px-3 py-2 text-sm font-medium"
            aria-expanded={open}
            aria-label={open ? t("closeMenu") : t("openMenu")}
            onClick={() => setOpen((v) => !v)}
          >
            {open ? "✕" : "☰"}
          </button>
        </div>
      </div>

      {open ? (
        <nav
          className="border-t border-outline-variant bg-surface px-4 py-4 md:hidden"
          aria-label="Mobile"
        >
          <ul className="flex flex-col gap-3">
            {navItems.map((item) => (
              <li key={item.href}>
                <Link
                  href={item.href}
                  className="block py-2 text-base font-medium text-text-primary"
                  onClick={() => setOpen(false)}
                >
                  {t(item.key)}
                </Link>
              </li>
            ))}
          </ul>
        </nav>
      ) : null}
    </header>
  );
}

function LanguageSwitcher({ locale }: { locale: AppLocale }) {
  const pathname = usePathname();
  const t = useTranslations("Nav");

  return (
    <div className="flex items-center gap-1 rounded-pill border border-outline-variant bg-surface p-1 text-xs font-semibold">
      <span className="sr-only">{t("language")}</span>
      {routing.locales.map((loc) => (
        <Link
          key={loc}
          href={pathname}
          locale={loc}
          className={[
            "rounded-pill px-2.5 py-1 uppercase transition",
            locale === loc
              ? "bg-primary text-on-primary"
              : "text-text-secondary hover:text-primary",
          ].join(" ")}
          aria-current={locale === loc ? "true" : undefined}
        >
          {loc}
        </Link>
      ))}
    </div>
  );
}
