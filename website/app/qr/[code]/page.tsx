type QrPageProps = {
  params: Promise<{ code: string }>;
};

export default async function QrLandingPage({ params }: QrPageProps) {
  const { code } = await params;

  return (
    <main>
      <h1>Vehicle QR</h1>
      <p>Code: {code}</p>
    </main>
  );
}
