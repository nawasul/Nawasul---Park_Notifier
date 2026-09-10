"use client";

import { useTranslations } from "next-intl";
import { Accordion, AccordionItem } from "@/components/ui/Accordion";

export function FAQAccordion() {
  const t = useTranslations("Faq");
  const items = [
    { q: t("q1"), a: t("a1") },
    { q: t("q2"), a: t("a2") },
    { q: t("q3"), a: t("a3") },
    { q: t("q4"), a: t("a4") },
    { q: t("q5"), a: t("a5") },
    { q: t("q6"), a: t("a6") },
    { q: t("q7"), a: t("a7") },
    { q: t("q8"), a: t("a8") },
  ];

  return (
    <Accordion>
      {items.map((item) => (
        <AccordionItem key={item.q} title={item.q}>
          {item.a}
        </AccordionItem>
      ))}
    </Accordion>
  );
}
