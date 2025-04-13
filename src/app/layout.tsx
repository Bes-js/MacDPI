import type { Metadata } from "next";
import "./globals.css";


export const metadata: Metadata = { 
  title: "MacDPI",
  description: "MacDPI is a DPI changer for macOS",
  applicationName: "MacDPI",
  authors: [
    { name: 'Bes-js', url: 'https://github.com/Bes-js' },
  ],
  creator: 'Berkant (Bes-js) Özdemir',
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
