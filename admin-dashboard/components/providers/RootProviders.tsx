"use client";

import type { ReactNode } from "react";
import { AppProviders } from "./AppProviders";
import { AuthProvider } from "./AuthProvider";

export function RootProviders({ children }: { children: ReactNode }) {
  return (
    <AppProviders>
      <AuthProvider>{children}</AuthProvider>
    </AppProviders>
  );
}
