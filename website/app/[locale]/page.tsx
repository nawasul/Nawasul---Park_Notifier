import { getTranslations, setRequestLocale } from "next-intl/server";
import { Link } from "@/i18n/navigation";
import { Button } from "@/components/ui/Button";
import { Card } from "@/components/ui/Card";
import { ProductGrid } from "@/components/sections/ProductGrid";
import { products } from "@/lib/products";

type Props = { params: Promise<{ locale: string }> };

export async function generateMetadata({ params }: Props) {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "Meta" });
  return {
    title: t("homeTitle"),
    description: t("homeDescription"),
    openGraph: {
      title: t("homeTitle"),
      description: t("homeDescription"),
    },
  };
}

export default async function HomePage({ params }: Props) {
  const { locale } = await params;
  setRequestLocale(locale);
  const t = await getTranslations("Home");

  return (
    <>
      <section className="relative overflow-hidden border-b border-outline-variant">
        <div
          className="pointer-events-none absolute inset-0 opacity-90"
          style={{
            background:
              "radial-gradient(ellipse 80% 60% at 10% 20%, color-mix(in srgb, var(--nw-primary) 28%, transparent), transparent), radial-gradient(ellipse 70% 50% at 90% 80%, color-mix(in srgb, var(--nw-dark) 12%, transparent), transparent), linear-gradient(180deg, var(--nw-background), color-mix(in srgb, var(--nw-primary-container) 55%, var(--nw-background)))",
          }}
          aria-hidden
        />
        <div className="relative mx-auto flex max-w-6xl flex-col gap-8 px-4 py-20 sm:px-6 sm:py-28">
          <p className="font-heading text-sm font-semibold uppercase tracking-[0.2em] text-primary">
            Nawasul Group
          </p>
          <h1 className="font-heading max-w-3xl text-4xl font-bold tracking-tight text-text-primary sm:text-5xl md:text-6xl">
            {t("heroTitle")}
          </h1>
          <p className="max-w-2xl text-lg text-text-secondary leading-relaxed">
            {t("heroSubtitle")}
          </p>
          <div className="flex flex-wrap gap-3">
            <Link href="/products">
              <Button>{t("ctaProducts")}</Button>
            </Link>
            <Link href="/contact">
              <Button variant="outline">{t("ctaContact")}</Button>
            </Link>
          </div>
        </div>
      </section>

      <section className="mx-auto max-w-6xl px-4 py-16 sm:px-6">
        <h2 className="font-heading text-3xl font-bold text-text-primary">
          {t("whatWeDoTitle")}
        </h2>
        <p className="mt-4 max-w-2xl text-text-secondary leading-relaxed">
          {t("whatWeDoBody")}
        </p>
      </section>

      <section className="bg-surface-container/60 py-16">
        <div className="mx-auto max-w-6xl px-4 sm:px-6">
          <h2 className="font-heading text-3xl font-bold text-text-primary">
            {t("howTitle")}
          </h2>
          <div className="mt-8 grid gap-6 md:grid-cols-3">
            {[
              { title: t("how1Title"), body: t("how1Body") },
              { title: t("how2Title"), body: t("how2Body") },
              { title: t("how3Title"), body: t("how3Body") },
            ].map((step) => (
              <Card key={step.title}>
                <h3 className="font-heading text-xl font-semibold text-primary">
                  {step.title}
                </h3>
                <p className="mt-3 text-text-secondary leading-relaxed">
                  {step.body}
                </p>
              </Card>
            ))}
          </div>
        </div>
      </section>

      <section className="mx-auto max-w-6xl px-4 py-16 sm:px-6">
        <div className="mb-8 flex flex-wrap items-end justify-between gap-4">
          <div>
            <h2 className="font-heading text-3xl font-bold text-text-primary">
              {t("productsPreviewTitle")}
            </h2>
            <p className="mt-2 text-text-secondary">{t("productsPreviewBody")}</p>
          </div>
          <Link
            href="/products"
            className="text-sm font-semibold text-primary hover:underline"
          >
            {t("viewAllProducts")}
          </Link>
        </div>
        <ProductGrid products={products} />
      </section>
    </>
  );
}
