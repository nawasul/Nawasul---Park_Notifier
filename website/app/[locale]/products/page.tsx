import { getTranslations, setRequestLocale } from "next-intl/server";
import { ProductGrid } from "@/components/sections/ProductGrid";
import { products } from "@/lib/products";

type Props = { params: Promise<{ locale: string }> };

export async function generateMetadata({ params }: Props) {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "Meta" });
  return {
    title: t("productsTitle"),
    description: t("productsDescription"),
    openGraph: {
      title: t("productsTitle"),
      description: t("productsDescription"),
    },
  };
}

export default async function ProductsPage({ params }: Props) {
  const { locale } = await params;
  setRequestLocale(locale);
  const t = await getTranslations("Products");

  return (
    <div className="mx-auto max-w-6xl px-4 py-16 sm:px-6">
      <h1 className="font-heading text-4xl font-bold text-text-primary">
        {t("title")}
      </h1>
      <p className="mt-4 max-w-2xl text-lg text-text-secondary">{t("subtitle")}</p>
      <div className="mt-12">
        <ProductGrid products={products} />
      </div>
    </div>
  );
}
