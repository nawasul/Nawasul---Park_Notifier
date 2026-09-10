import { NextIntlClientProvider, hasLocale } from "next-intl";
import { getMessages, setRequestLocale } from "next-intl/server";
import { notFound } from "next/navigation";
import { Footer } from "@/components/sections/Footer";
import { LocaleHtmlAttributes } from "@/components/sections/LocaleHtmlAttributes";
import { Navbar } from "@/components/sections/Navbar";
import { routing } from "@/i18n/routing";

type Props = {
  children: React.ReactNode;
  params: Promise<{ locale: string }>;
};

export function generateStaticParams() {
  return routing.locales.map((locale) => ({ locale }));
}

export default async function LocaleLayout({ children, params }: Props) {
  const { locale } = await params;
  if (!hasLocale(routing.locales, locale)) {
    notFound();
  }

  setRequestLocale(locale);
  const messages = await getMessages();
  const dir = locale === "ar" ? "rtl" : "ltr";

  return (
    <NextIntlClientProvider messages={messages}>
      <LocaleHtmlAttributes />
      <div lang={locale} dir={dir} className="flex min-h-full flex-1 flex-col">
        <Navbar />
        <main className="flex-1">{children}</main>
        <Footer />
      </div>
    </NextIntlClientProvider>
  );
}
