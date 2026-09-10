"use client";

import {
  createContext,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useState,
  type ReactNode,
} from "react";
import type { AdminRole, AdminUser } from "@/lib/mock/types";
import { authenticateAdmin, getAdminById } from "@/lib/mock/mock-admins";

const SESSION_KEY = "nawasul_admin_session";

export type AdminSession = {
  adminId: string;
  email: string;
  name: string;
  role: AdminRole;
  token: string;
};

type AuthContextValue = {
  session: AdminSession | null;
  admin: AdminUser | null;
  isLoading: boolean;
  isAuthenticated: boolean;
  login: (email: string, password: string) => Promise<{ ok: boolean; error?: string }>;
  logout: () => void;
};

const AuthContext = createContext<AuthContextValue | undefined>(undefined);

function readStoredSession(): AdminSession | null {
  if (typeof window === "undefined") return null;
  try {
    const raw = localStorage.getItem(SESSION_KEY);
    if (!raw) return null;
    return JSON.parse(raw) as AdminSession;
  } catch {
    return null;
  }
}

export function AuthProvider({ children }: { children: ReactNode }) {
  const [session, setSession] = useState<AdminSession | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    setSession(readStoredSession());
    setIsLoading(false);
  }, []);

  const login = useCallback(async (email: string, password: string) => {
    const admin = authenticateAdmin(email, password);
    if (!admin) {
      return { ok: false, error: "Invalid email or password" };
    }
    const next: AdminSession = {
      adminId: admin.id,
      email: admin.email,
      name: admin.name,
      role: admin.role,
      token: `mock-token-${admin.id}`,
    };
    localStorage.setItem(SESSION_KEY, JSON.stringify(next));
    setSession(next);
    return { ok: true };
  }, []);

  const logout = useCallback(() => {
    localStorage.removeItem(SESSION_KEY);
    setSession(null);
  }, []);

  const value = useMemo<AuthContextValue>(() => {
    const admin = session ? getAdminById(session.adminId) ?? null : null;
    return {
      session,
      admin,
      isLoading,
      isAuthenticated: Boolean(session),
      login,
      logout,
    };
  }, [session, isLoading, login, logout]);

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export function useAuth(): AuthContextValue {
  const ctx = useContext(AuthContext);
  if (!ctx) {
    throw new Error("useAuth must be used within AuthProvider");
  }
  return ctx;
}
