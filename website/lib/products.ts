export type ProductStatus = "live" | "coming_soon";

export type Product = {
  id: string;
  /** Message key under Products namespace */
  nameKey: string;
  /** Message key under Products namespace */
  taglineKey: string;
  status: ProductStatus;
  /** Locale-aware path without locale prefix */
  href: "/products/nawasul" | (string & {});
  icon?: string;
};

/**
 * Data-driven product catalog.
 * Add product #2 by appending an entry (and optional detail routes).
 */
export const products: Product[] = [
  {
    id: "nawasul",
    nameKey: "nawasulName",
    taglineKey: "nawasulTagline",
    status: "live",
    href: "/products/nawasul",
    icon: "/products/nawasul-mark.svg",
  },
];

export function getProductById(id: string): Product | undefined {
  return products.find((p) => p.id === id);
}
