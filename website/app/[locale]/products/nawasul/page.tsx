import { getTranslations, setRequestLocale } from "next-intl/server";
import { Link } from "@/i18n/navigation";
import { Button } from "@/components/ui/Button";
import { Card } from "@/components/ui/Card";

type Props = { params: Promise<{ locale: string }> };

export async function generateMetadata({ params }: Props) {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "Meta" });
  return {
    title: t("nawasulTitle"),
    description: t("nawasulDescription"),
    openGraph: {
      title: t("nawasulTitle"),
      description: t("nawasulDescription"),
    },
  };
}

export default async function NawasulProductPage({ params }: Props) {
  const { locale } = await params;
  setRequestLocale(locale);
  const t = await getTranslations("Nawasul");

  const steps = [
    { title: t("step1Title"), body: t("step1Body") },
    { title: t("step2Title"), body: t("step2Body") },
    { title: t("step3Title"), body: t("step3Body") },
  ];

  return (
    <div>
      <section className="border-b border-outline-variant bg-dark text-on-primary">
        <div className="mx-auto max-w-6xl px-4 py-16 sm:px-6 sm:py-20">
          <p className="text-sm font-semibold uppercase tracking-widest text-primary">
            {t("eyebrow")}
          </p>
          <h1 className="font-heading mt-3 text-4xl font-bold sm:text-5xl">
            {t("title")}
          </h1>
          <p className="mt-2 text-lg text-primary">{t("tagline")}</p>
          <p className="mt-6 max-w-2xl text-surface-container-high leading-relaxed">
            {t("intro")}
          </p>
          <div className="mt-8 flex flex-wrap gap-3">
            <Link href="/products/nawasul/features">
              <Button>{t("linkFeatures")}</Button>
            </Link>
            <Link href="/products/nawasul/pricing">
              <Button variant="secondary">{t("linkPricing")}</Button>
            </Link>
            <Link href="/products/nawasul/faq">
              <Button variant="outline" className="border-on-primary text-on-primary hover:bg-white/10">
                {t("linkFaq")}
              </Button>
            </Link>
          </div>
        </div>
      </section>

      <section className="mx-auto max-w-6xl px-4 py-16 sm:px-6">
        <h2 className="font-heading text-3xl font-bold text-text-primary">
          {t("howTitle")}
        </h2>
        <ol className="mt-8 grid gap-6 md:grid-cols-3">
          {steps.map((step, i) => (
            <Card key={step.title}>
              <span className="text-sm font-bold text-primary">0{i + 1}</span>
              <h3 className="font-heading mt-2 text-xl font-semibold">
                {step.title}
              </h3>
              <p className="mt-3 text-text-secondary leading-relaxed">
                {step.body}
              </p>
            </Card>
          ))}
        </ol>
      </section>

      <section className="bg-surface-container/50 py-16">
        <div className="mx-auto max-w-6xl px-4 sm:px-6">
          <h2 className="font-heading text-3xl font-bold">{t("screenshotsTitle")}</h2>
          <p className="mt-2 text-text-secondary">{t("screenshotsBody")}</p>
          <div className="mt-8 grid gap-4 sm:grid-cols-3">
            {[1, 2, 3].map((n) => (
              <div
                key={n}
                className="flex aspect-[9/16] max-h-80 items-center justify-center rounded-lg bg-dark text-sm text-surface-container-high"
              >
                Mockup {n}
              </div>
            ))}
          </div>
        </div>
      </section>

      <section className="mx-auto max-w-6xl px-4 py-16 sm:px-6">
        <h2 className="font-heading text-3xl font-bold">{t("downloadTitle")}</h2>
        <p className="mt-2 text-text-secondary">{t("downloadBody")}</p>
        <div className="mt-6 flex flex-wrap gap-3">
          <Button variant="secondary" disabled>
            {t("appStore")}
          </Button>
          <Button variant="secondary" disabled>
            {t("playStore")}
          </Button>
        </div>
      </section>
    </div>
  );
}
