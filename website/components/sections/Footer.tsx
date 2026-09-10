import { useTranslations } from "next-intl";
import { Link } from "@/i18n/navigation";

export function Footer() {
  const t = useTranslations("Footer");
  const year = new Date().getFullYear();

  return (
    <footer className="mt-auto border-t border-outline-variant bg-dark text-on-primary">
      <div className="mx-auto grid max-w-6xl gap-10 px-4 py-12 sm:px-6 md:grid-cols-4">
        <div className="md:col-span-1">
          <p className="font-heading text-lg font-bold">
            <span className="text-primary">Nawasul</span> Group
          </p>
          <p className="mt-3 text-sm text-surface-container-high leading-relaxed">
            {t("tagline")}
          </p>
        </div>

        <div>
          <p className="mb-3 text-sm font-semibold uppercase tracking-wide text-surface-container-high">
            {t("company")}
          </p>
          <ul className="space-y-2 text-sm">
            <li>
              <Link href="/about" className="hover:text-primary">
                {t("about")}
              </Link>
            </li>
            <li>
              <Link href="/contact" className="hover:text-primary">
                {t("contact")}
              </Link>
            </li>
          </ul>
        </div>

        <div>
          <p className="mb-3 text-sm font-semibold uppercase tracking-wide text-surface-container-high">
            {t("products")}
          </p>
          <ul className="space-y-2 text-sm">
            <li>
              <Link href="/products" className="hover:text-primary">
                {t("products")}
              </Link>
            </li>
            <li>
              <Link href="/products/nawasul" className="hover:text-primary">
                {t("nawasul")}
              </Link>
            </li>
          </ul>
        </div>

        <div>
          <p className="mb-3 text-sm font-semibold uppercase tracking-wide text-surface-container-high">
            {t("legal")}
          </p>
          <ul className="space-y-2 text-sm">
            <li>
              <Link href="/privacy" className="hover:text-primary">
                {t("privacy")}
              </Link>
            </li>
            <li>
              <Link href="/terms" className="hover:text-primary">
                {t("terms")}
              </Link>
            </li>
          </ul>
        </div>
      </div>
      <div className="border-t border-white/10 py-4 text-center text-xs text-surface-container-high">
        {t("rights", { year })}
      </div>
    </footer>
  );
}
