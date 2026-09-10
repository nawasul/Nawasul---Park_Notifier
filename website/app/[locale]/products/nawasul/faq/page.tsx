import { getTranslations, setRequestLocale } from "next-intl/server";
import { FAQAccordion } from "@/components/sections/FAQAccordion";

type Props = { params: Promise<{ locale: string }> };

export async function generateMetadata({ params }: Props) {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "Meta" });
  return {
    title: t("faqTitle"),
    description: t("faqDescription"),
  };
}

export default async function FaqPage({ params }: Props) {
  const { locale } = await params;
  setRequestLocale(locale);
  const t = await getTranslations("Faq");

  return (
    <div className="mx-auto max-w-3xl px-4 py-16 sm:px-6">
      <h1 className="font-heading text-4xl font-bold text-text-primary">
        {t("title")}
      </h1>
      <p className="mt-4 text-lg text-text-secondary">{t("subtitle")}</p>
      <div className="mt-10">
        <FAQAccordion />
      </div>
    </div>
  );
}
