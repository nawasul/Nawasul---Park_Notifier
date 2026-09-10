import type { Metadata } from "next";
import { Noto_Kufi_Arabic, Poppins } from "next/font/google";
import "./globals.css";

const poppins = Poppins({
  variable: "--font-poppins",
  subsets: ["latin"],
  weight: ["400", "500", "600", "700"],
  display: "swap",
});

const notoKufi = Noto_Kufi_Arabic({
  variable: "--font-noto-kufi",
  subsets: ["arabic"],
  weight: ["400", "500", "600", "700"],
  display: "swap",
});

export const metadata: Metadata = {
  title: {
    default: "Nawasul Group",
    template: "%s | Nawasul Group",
  },
  description:
    "Nawasul Group turns ideas into meaningful digital products. Home of Nawasul — private vehicle owner notifications via QR.",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html
      lang="en"
      suppressHydrationWarning
      className={`${poppins.variable} ${notoKufi.variable} h-full antialiased`}
    >
      <body className="min-h-full flex flex-col font-sans">{children}</body>
    </html>
  );
}
