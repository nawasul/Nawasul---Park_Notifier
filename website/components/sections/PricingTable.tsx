"use client";

import { useTranslations } from "next-intl";
import { useState } from "react";
import { Badge } from "@/components/ui/Badge";
import { Button } from "@/components/ui/Button";
import { Card } from "@/components/ui/Card";

type PlanId = "free" | "pro" | "premium";

export function PricingTable() {
  const t = useTranslations("Pricing");
  const [yearly, setYearly] = useState(false);

  const plans: {
    id: PlanId;
    name: string;
    price: string;
    features: string[];
    popular?: boolean;
  }[] = [
    {
      id: "free",
      name: t("freeName"),
      price: t("freePrice"),
      features: [t("freeF1"), t("freeF2"), t("freeF3")],
    },
    {
      id: "pro",
      name: t("proName"),
      price: yearly ? t("proYearly") : t("proMonthly"),
      features: [t("proF1"), t("proF2"), t("proF3"), t("proF4")],
      popular: true,
    },
    {
      id: "premium",
      name: t("premiumName"),
      price: yearly ? t("premiumYearly") : t("premiumMonthly"),
      features: [
        t("premiumF1"),
        t("premiumF2"),
        t("premiumF3"),
        t("premiumF4"),
        t("premiumF5"),
      ],
    },
  ];

  return (
    <div>
      <div className="mb-8 flex justify-center">
        <div className="inline-flex rounded-pill border border-outline-variant bg-surface p-1">
          <button
            type="button"
            onClick={() => setYearly(false)}
            className={[
              "rounded-pill px-4 py-2 text-sm font-semibold",
              !yearly ? "bg-primary text-on-primary" : "text-text-secondary",
            ].join(" ")}
          >
            {t("monthly")}
          </button>
          <button
            type="button"
            onClick={() => setYearly(true)}
            className={[
              "rounded-pill px-4 py-2 text-sm font-semibold",
              yearly ? "bg-primary text-on-primary" : "text-text-secondary",
            ].join(" ")}
          >
            {t("yearly")}
          </button>
        </div>
      </div>

      <div className="grid gap-6 lg:grid-cols-3">
        {plans.map((plan) => (
          <Card
            key={plan.id}
            className={[
              "relative flex flex-col",
              plan.popular ? "ring-2 ring-primary" : "",
            ].join(" ")}
          >
            {plan.popular ? (
              <Badge tone="live" className="absolute -top-3 self-center">
                {t("popular")}
              </Badge>
            ) : null}
            <h2 className="font-heading text-2xl font-bold">{plan.name}</h2>
            <p className="mt-3 text-3xl font-bold text-primary">{plan.price}</p>
            <ul className="mt-6 flex-1 space-y-3 text-sm text-text-secondary">
              {plan.features.map((f) => (
                <li key={f} className="flex gap-2">
                  <span className="text-primary" aria-hidden>
                    ✓
                  </span>
                  {f}
                </li>
              ))}
            </ul>
            <Button className="mt-8 w-full" variant={plan.popular ? "primary" : "secondary"}>
              {t("cta")}
            </Button>
          </Card>
        ))}
      </div>
    </div>
  );
}
