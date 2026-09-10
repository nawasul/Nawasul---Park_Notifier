import type { Metadata } from "next";
import { cookies } from "next/headers";
import { NextIntlClientProvider } from "next-intl";
import { QRLandingClient } from "@/components/qr/QRLandingClient";
import { routing, type AppLocale } from "@/i18n/routing";

type Props = {
  params: Promise<{ code: string }>;
};

export const metadata: Metadata = {
  title: "Notify Owner | Nawasul",
  description: "Notify a vehicle owner privately via Nawasul QR.",
  robots: { index: false, follow: false },
};

async function resolveLocale(): Promise<AppLocale> {
  const jar = await cookies();
  const fromCookie = jar.get("NEXT_LOCALE")?.value;
  if (fromCookie && routing.locales.includes(fromCookie as AppLocale)) {
    return fromCookie as AppLocale;
  }
  return routing.defaultLocale;
}

export default async function QrPage({ params }: Props) {
  const { code } = await params;
  const locale = await resolveLocale();
  const messages = (await import(`../../../messages/${locale}.json`)).default;
  const t = messages.Qr;
  const dir = locale === "ar" ? "rtl" : "ltr";

  const copy = {
    loading: t.loading,
    notify: t.notify,
    notifying: t.notifying,
    reasonLabel: t.reasonLabel,
    reasonBlocking: t.reasonBlocking,
    reasonLights: t.reasonLights,
    reasonFlat: t.reasonFlat,
    reasonOther: t.reasonOther,
    successTitle: t.successTitle,
    successBody: t.successBody,
    errorTitle: t.errorTitle,
    errorBody: t.errorBody,
    vehicleLabel: t.vehicleLabel,
    privacyNote: t.privacyNote,
  };

  return (
    <NextIntlClientProvider locale={locale} messages={messages}>
      <div
        lang={locale}
        dir={dir}
        className="mx-auto flex min-h-full w-full max-w-md flex-1 flex-col px-4 py-6"
      >
        <header className="mb-8 text-center">
          <p className="font-heading text-lg font-bold text-primary">{t.brand}</p>
        </header>

        <QRLandingClient code={code} copy={copy} />

        <footer className="mt-auto pt-10 text-center">
          <a
            href={`/${locale}/products/nawasul`}
            className="text-sm text-text-muted underline-offset-2 hover:text-primary hover:underline"
          >
            {t.whatIs}
          </a>
        </footer>
      </div>
    </NextIntlClientProvider>
  );
}
