"use client";

import { useTranslations } from "next-intl";
import { FormEvent, useState } from "react";
import { Button } from "@/components/ui/Button";
import { Card } from "@/components/ui/Card";
import { Input } from "@/components/ui/Input";
import { Textarea } from "@/components/ui/Textarea";

export function ContactForm() {
  const t = useTranslations("Contact");
  const [sent, setSent] = useState(false);

  function onSubmit(e: FormEvent<HTMLFormElement>) {
    e.preventDefault();
    setSent(true);
  }

  if (sent) {
    return (
      <Card className="bg-success-container text-success">
        <p className="font-medium">{t("success")}</p>
      </Card>
    );
  }

  return (
    <form onSubmit={onSubmit} className="flex flex-col gap-4">
      <Input name="name" label={t("name")} required autoComplete="name" />
      <Input
        name="email"
        type="email"
        label={t("email")}
        required
        autoComplete="email"
      />
      <Textarea name="message" label={t("message")} required rows={5} />
      <Button type="submit" className="self-start">
        {t("submit")}
      </Button>
    </form>
  );
}
