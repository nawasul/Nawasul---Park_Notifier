import { getCallLogs } from "./mock-call-logs";
import { getQrOrders } from "./mock-qr-orders";
import { getSubscriptions } from "./mock-subscriptions";
import { getSupportTickets } from "./mock-support-tickets";
import { getUsers } from "./mock-users";
import { getVehicles } from "./mock-vehicles";
import type { SubscriptionPlan } from "./types";

export type DashboardMetrics = {
  totalUsers: number;
  activeSubscriptions: number;
  vehiclesRegistered: number;
  pendingQrOrders: number;
  alertsToday: number;
  alertsThisWeek: number;
  mrrEstimateSar: number;
  planDistribution: { plan: SubscriptionPlan; count: number }[];
  churnRatePercent: number;
};

export type ActivityItem = {
  id: string;
  type: "signup" | "qr_order" | "alert" | "ticket";
  title: string;
  subtitle: string;
  timestamp: string;
};

export type TimeSeriesPoint = {
  date: string;
  signups: number;
  alerts: number;
};

const PLAN_MRR: Record<SubscriptionPlan, number> = {
  free: 0,
  pro: 29,
  premium: 49,
};

function startOfDay(d: Date): Date {
  const x = new Date(d);
  x.setHours(0, 0, 0, 0);
  return x;
}

function daysAgo(n: number): Date {
  const d = new Date("2025-09-21T12:00:00Z");
  d.setDate(d.getDate() - n);
  return startOfDay(d);
}

export function getDashboardMetrics(): DashboardMetrics {
  const users = getUsers();
  const subscriptions = getSubscriptions();
  const vehicles = getVehicles();
  const orders = getQrOrders();
  const logs = getCallLogs();

  const activeSubs = subscriptions.filter((s) => s.status === "active" && s.plan !== "free");
  const mrr = activeSubs.reduce((sum, s) => {
    const monthly = PLAN_MRR[s.plan];
    return sum + (s.billingCycle === "yearly" ? Math.round(monthly * 12 * 0.85) / 12 : monthly);
  }, 0);

  const planCounts: Record<SubscriptionPlan, number> = { free: 0, pro: 0, premium: 0 };
  for (const s of subscriptions) {
    planCounts[s.plan] += 1;
  }

  const today = daysAgo(0);
  const weekAgo = daysAgo(7);
  const alertsToday = logs.filter((l) => new Date(l.timestamp) >= today).length;
  const alertsThisWeek = logs.filter((l) => new Date(l.timestamp) >= weekAgo).length;

  const cancelledOrExpired = subscriptions.filter(
    (s) => s.status === "cancelled" || s.status === "expired"
  ).length;
  const churnRatePercent =
    subscriptions.length === 0
      ? 0
      : Math.round((cancelledOrExpired / subscriptions.length) * 1000) / 10;

  return {
    totalUsers: users.filter((u) => u.accountStatus !== "deleted").length,
    activeSubscriptions: activeSubs.length,
    vehiclesRegistered: vehicles.length,
    pendingQrOrders: orders.filter((o) => o.status === "ordered" || o.status === "printed").length,
    alertsToday,
    alertsThisWeek,
    mrrEstimateSar: Math.round(mrr * 10) / 10,
    planDistribution: (["free", "pro", "premium"] as SubscriptionPlan[]).map((plan) => ({
      plan,
      count: planCounts[plan],
    })),
    churnRatePercent,
  };
}

export function getRecentActivity(limit = 12): ActivityItem[] {
  const items: ActivityItem[] = [];

  for (const u of getUsers()) {
    items.push({
      id: `act_user_${u.id}`,
      type: "signup",
      title: `New signup: ${u.name}`,
      subtitle: u.city,
      timestamp: u.signupDate,
    });
  }
  for (const o of getQrOrders()) {
    items.push({
      id: `act_ord_${o.id}`,
      type: "qr_order",
      title: `QR order ${o.id} — ${o.status}`,
      subtitle: o.city,
      timestamp: o.orderDate,
    });
  }
  for (const c of getCallLogs()) {
    items.push({
      id: `act_cl_${c.id}`,
      type: "alert",
      title: `Alert: ${c.reason}`,
      subtitle: c.flaggedAbusive ? "Flagged abusive" : c.deliveryMethod,
      timestamp: c.timestamp,
    });
  }
  for (const t of getSupportTickets()) {
    items.push({
      id: `act_tkt_${t.id}`,
      type: "ticket",
      title: t.subject,
      subtitle: t.source,
      timestamp: t.createdAt,
    });
  }

  return items
    .sort((a, b) => new Date(b.timestamp).getTime() - new Date(a.timestamp).getTime())
    .slice(0, limit);
}

/**
 * Mock 30-day series for spotting abuse spikes in alert volume.
 * Useful for ops to correlate signup growth vs alert surges.
 */
export function getDashboardTimeSeries(): TimeSeriesPoint[] {
  const points: TimeSeriesPoint[] = [];
  const signupByDay = new Map<string, number>();
  const alertByDay = new Map<string, number>();

  for (const u of getUsers()) {
    const key = u.signupDate.slice(0, 10);
    signupByDay.set(key, (signupByDay.get(key) ?? 0) + 1);
  }
  for (const c of getCallLogs()) {
    const key = c.timestamp.slice(0, 10);
    alertByDay.set(key, (alertByDay.get(key) ?? 0) + 1);
  }

  for (let i = 29; i >= 0; i -= 1) {
    const d = daysAgo(i);
    const key = d.toISOString().slice(0, 10);
    // Seed mild synthetic noise so charts look continuous beyond sparse real events
    const syntheticSignups = (i * 7) % 3 === 0 ? 1 : 0;
    const syntheticAlerts = (i * 3) % 4 === 0 ? 2 : (i % 5 === 0 ? 1 : 0);
    points.push({
      date: key,
      signups: (signupByDay.get(key) ?? 0) + syntheticSignups,
      alerts: (alertByDay.get(key) ?? 0) + syntheticAlerts,
    });
  }
  return points;
}
