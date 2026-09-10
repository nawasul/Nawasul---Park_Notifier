export function QRSuccessState({
  title,
  body,
}: {
  title: string;
  body: string;
}) {
  return (
    <div className="rounded-lg bg-success-container p-6 text-center text-success">
      <div className="mx-auto mb-3 flex h-12 w-12 items-center justify-center rounded-full bg-success text-xl font-bold text-on-primary">
        ✓
      </div>
      <h2 className="font-heading text-xl font-semibold">{title}</h2>
      <p className="mt-2 text-sm leading-relaxed opacity-90">{body}</p>
    </div>
  );
}
