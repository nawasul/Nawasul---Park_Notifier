import { getTranslations, setRequestLocale } from "next-intl/server";
import { PricingTable } from "@/components/sections/PricingTable";

type Props = { params: Promise<{ locale: string }> };

export async function generateMetadata({ params }: Props) {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "Meta" });
  return {
    title: t("pricingTitle"),
    description: t("pricingDescription"),
  };
}

export default async function PricingPage({ params }: Props) {
  const { locale } = await params;
  setRequestLocale(locale);
  const t = await getTranslations("Pricing");

  return (
    <div className="mx-auto max-w-6xl px-4 py-16 sm:px-6">
      <h1 className="font-heading text-4xl font-bold text-text-primary">
        {t("title")}
      </h1>
      <p className="mt-4 max-w-2xl text-lg text-text-secondary">{t("subtitle")}</p>
      <div className="mt-12">
        <PricingTable />
      </div>
    </div>
  );
}
