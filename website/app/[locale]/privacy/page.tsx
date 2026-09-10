import { getTranslations, setRequestLocale } from "next-intl/server";

type Props = { params: Promise<{ locale: string }> };

export async function generateMetadata({ params }: Props) {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "Meta" });
  return {
    title: t("privacyTitle"),
    description: t("privacyDescription"),
  };
}

export default async function PrivacyPage({ params }: Props) {
  const { locale } = await params;
  setRequestLocale(locale);
  const t = await getTranslations("Privacy");

  return (
    <article className="mx-auto max-w-3xl px-4 py-16 sm:px-6">
      <h1 className="font-heading text-4xl font-bold text-text-primary">
        {t("title")}
      </h1>
      <p className="mt-2 text-sm text-text-muted">{t("updated")}</p>
      <div className="mt-8 space-y-5 text-text-secondary leading-relaxed">
        <p>{t("p1")}</p>
        <p>{t("p2")}</p>
        <p>{t("p3")}</p>
        <p>{t("p4")}</p>
        <p>{t("p5")}</p>
      </div>
    </article>
  );
}
