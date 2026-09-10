import { getTranslations, setRequestLocale } from "next-intl/server";
import { ContactForm } from "@/components/sections/ContactForm";
import { Card } from "@/components/ui/Card";

type Props = { params: Promise<{ locale: string }> };

export async function generateMetadata({ params }: Props) {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "Meta" });
  return {
    title: t("contactTitle"),
    description: t("contactDescription"),
    openGraph: {
      title: t("contactTitle"),
      description: t("contactDescription"),
    },
  };
}

export default async function ContactPage({ params }: Props) {
  const { locale } = await params;
  setRequestLocale(locale);
  const t = await getTranslations("Contact");

  return (
    <div className="mx-auto max-w-6xl px-4 py-16 sm:px-6">
      <h1 className="font-heading text-4xl font-bold text-text-primary">
        {t("title")}
      </h1>
      <p className="mt-4 max-w-2xl text-lg text-text-secondary">{t("subtitle")}</p>

      <div className="mt-12 grid gap-8 lg:grid-cols-5">
        <Card className="lg:col-span-3">
          <ContactForm />
        </Card>
        <div className="flex flex-col gap-4 lg:col-span-2">
          <Card>
            <p className="text-sm font-medium text-text-muted">{t("emailLabel")}</p>
            <a
              href="mailto:hello@nawasul.group"
              className="mt-1 block font-semibold text-primary hover:underline"
            >
              {t("emailValue")}
            </a>
          </Card>
          <Card>
            <p className="text-sm font-medium text-text-muted">
              {t("locationLabel")}
            </p>
            <p className="mt-1 font-semibold text-text-primary">
              {t("locationValue")}
            </p>
          </Card>
        </div>
      </div>
    </div>
  );
}
