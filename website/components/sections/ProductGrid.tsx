import { useTranslations } from "next-intl";
import { Link } from "@/i18n/navigation";
import { Badge } from "@/components/ui/Badge";
import { Card } from "@/components/ui/Card";
import type { Product } from "@/lib/products";

export function ProductCard({ product }: { product: Product }) {
  const t = useTranslations("Products");

  return (
    <Card className="flex h-full flex-col gap-4 transition hover:-translate-y-0.5 hover:shadow-floating">
      <div className="flex items-start justify-between gap-3">
        <div className="flex h-12 w-12 items-center justify-center rounded-md bg-primary-container text-xl font-bold text-primary">
          {product.id.slice(0, 1).toUpperCase()}
        </div>
        <Badge tone={product.status === "live" ? "live" : "coming_soon"}>
          {product.status === "live" ? t("statusLive") : t("statusComingSoon")}
        </Badge>
      </div>
      <div>
        <h3 className="font-heading text-xl font-semibold text-text-primary">
          {t(product.nameKey as "nawasulName")}
        </h3>
        <p className="mt-2 text-sm text-text-secondary leading-relaxed">
          {t(product.taglineKey as "nawasulTagline")}
        </p>
      </div>
      <Link
        href={product.href}
        className="mt-auto text-sm font-semibold text-primary hover:underline"
      >
        {t("learnMore")} →
      </Link>
    </Card>
  );
}

export function ProductGrid({ products }: { products: Product[] }) {
  return (
    <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
      {products.map((product) => (
        <ProductCard key={product.id} product={product} />
      ))}
    </div>
  );
}
