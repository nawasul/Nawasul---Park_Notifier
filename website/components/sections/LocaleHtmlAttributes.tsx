"use client";

import { useLocale } from "next-intl";
import { useEffect } from "react";

/** Syncs <html> lang/dir for marketing pages (root layout cannot read [locale]). */
export function LocaleHtmlAttributes() {
  const locale = useLocale();

  useEffect(() => {
    const html = document.documentElement;
    html.lang = locale;
    html.dir = locale === "ar" ? "rtl" : "ltr";
  }, [locale]);

  return null;
}
