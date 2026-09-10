export function QRErrorState({
  title,
  body,
}: {
  title: string;
  body: string;
}) {
  return (
    <div className="rounded-lg bg-error-container p-6 text-center text-error">
      <h2 className="font-heading text-xl font-semibold">{title}</h2>
      <p className="mt-2 text-sm leading-relaxed opacity-90">{body}</p>
    </div>
  );
}
