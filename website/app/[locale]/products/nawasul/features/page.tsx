import { getTranslations, setRequestLocale } from "next-intl/server";
import { Card } from "@/components/ui/Card";

type Props = { params: Promise<{ locale: string }> };

export async function generateMetadata({ params }: Props) {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "Meta" });
  return {
    title: t("featuresTitle"),
    description: t("featuresDescription"),
  };
}

export default async function FeaturesPage({ params }: Props) {
  const { locale } = await params;
  setRequestLocale(locale);
  const t = await getTranslations("Features");

  const features = [
    { title: t("f1Title"), body: t("f1Body") },
    { title: t("f2Title"), body: t("f2Body") },
    { title: t("f3Title"), body: t("f3Body") },
    { title: t("f4Title"), body: t("f4Body") },
    { title: t("f5Title"), body: t("f5Body") },
    { title: t("f6Title"), body: t("f6Body") },
  ];

  return (
    <div className="mx-auto max-w-6xl px-4 py-16 sm:px-6">
      <h1 className="font-heading text-4xl font-bold text-text-primary">
        {t("title")}
      </h1>
      <p className="mt-4 max-w-2xl text-lg text-text-secondary">{t("subtitle")}</p>
      <div className="mt-12 grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
        {features.map((f) => (
          <Card key={f.title}>
            <h2 className="font-heading text-xl font-semibold text-primary">
              {f.title}
            </h2>
            <p className="mt-3 text-text-secondary leading-relaxed">{f.body}</p>
          </Card>
        ))}
      </div>
    </div>
  );
}
