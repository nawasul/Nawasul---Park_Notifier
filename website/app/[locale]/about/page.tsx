import { getTranslations, setRequestLocale } from "next-intl/server";
import { Card } from "@/components/ui/Card";

type Props = { params: Promise<{ locale: string }> };

export async function generateMetadata({ params }: Props) {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "Meta" });
  return {
    title: t("aboutTitle"),
    description: t("aboutDescription"),
    openGraph: { title: t("aboutTitle"), description: t("aboutDescription") },
  };
}

export default async function AboutPage({ params }: Props) {
  const { locale } = await params;
  setRequestLocale(locale);
  const t = await getTranslations("About");

  const team = [
    { name: t("name1"), role: t("roleFounder") },
    { name: t("name2"), role: t("roleDesign") },
    { name: t("name3"), role: t("roleEng") },
  ];

  return (
    <div className="mx-auto max-w-6xl px-4 py-16 sm:px-6">
      <h1 className="font-heading text-4xl font-bold text-text-primary">
        {t("title")}
      </h1>
      <p className="mt-6 max-w-3xl text-lg text-text-secondary leading-relaxed">
        {t("intro")}
      </p>

      <div className="mt-12 grid gap-6 md:grid-cols-2">
        <Card>
          <h2 className="font-heading text-xl font-semibold text-primary">
            {t("missionTitle")}
          </h2>
          <p className="mt-3 text-text-secondary leading-relaxed">
            {t("missionBody")}
          </p>
        </Card>
        <Card>
          <h2 className="font-heading text-xl font-semibold text-primary">
            {t("practiceTitle")}
          </h2>
          <p className="mt-3 text-text-secondary leading-relaxed">
            {t("practiceBody")}
          </p>
        </Card>
      </div>

      <section className="mt-16">
        <h2 className="font-heading text-3xl font-bold text-text-primary">
          {t("teamTitle")}
        </h2>
        <p className="mt-2 text-text-secondary">{t("teamBody")}</p>
        <div className="mt-8 grid gap-6 sm:grid-cols-3">
          {team.map((member) => (
            <Card key={member.name} className="text-center">
              <div className="mx-auto flex h-20 w-20 items-center justify-center rounded-full bg-primary-container text-2xl font-bold text-primary">
                {member.name.slice(0, 1)}
              </div>
              <h3 className="mt-4 font-heading text-lg font-semibold">
                {member.name}
              </h3>
              <p className="mt-1 text-sm text-text-secondary">{member.role}</p>
            </Card>
          ))}
        </div>
      </section>
    </div>
  );
}
