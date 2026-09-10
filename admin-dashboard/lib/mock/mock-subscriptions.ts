import type { Subscription, SubscriptionHistoryEntry } from "./types";

export const mockSubscriptions: Subscription[] = [
  {
    id: "sub_001",
    userId: "usr_001",
    plan: "premium",
    billingCycle: "yearly",
    platform: "ios",
    status: "active",
    nextRenewalDate: "2026-06-12T00:00:00Z",
    platformRefId: "apple_txn_9f2a1c",
    startedAt: "2025-06-12T10:05:00Z",
  },
  {
    id: "sub_002",
    userId: "usr_002",
    plan: "pro",
    billingCycle: "monthly",
    platform: "android",
    status: "active",
    nextRenewalDate: "2025-10-01T00:00:00Z",
    platformRefId: "gp_txn_88b3d2",
    startedAt: "2025-07-01T14:25:00Z",
  },
  {
    id: "sub_003",
    userId: "usr_003",
    plan: "free",
    billingCycle: "monthly",
    platform: "android",
    status: "active",
    nextRenewalDate: null,
    platformRefId: "free_usr_003",
    startedAt: "2025-07-18T09:15:00Z",
  },
  {
    id: "sub_004",
    userId: "usr_004",
    plan: "pro",
    billingCycle: "monthly",
    platform: "ios",
    status: "active",
    nextRenewalDate: "2025-10-02T00:00:00Z",
    platformRefId: "apple_txn_4c11ee",
    startedAt: "2025-08-02T16:50:00Z",
  },
  {
    id: "sub_005",
    userId: "usr_005",
    plan: "free",
    billingCycle: "monthly",
    platform: "ios",
    status: "active",
    nextRenewalDate: null,
    platformRefId: "free_usr_005",
    startedAt: "2025-08-10T11:00:00Z",
  },
  {
    id: "sub_006",
    userId: "usr_006",
    plan: "premium",
    billingCycle: "yearly",
    platform: "android",
    status: "cancelled",
    nextRenewalDate: null,
    platformRefId: "gp_txn_cc91a0",
    startedAt: "2025-08-15T08:35:00Z",
  },
  {
    id: "sub_007",
    userId: "usr_007",
    plan: "pro",
    billingCycle: "monthly",
    platform: "ios",
    status: "expired",
    nextRenewalDate: null,
    platformRefId: "apple_txn_77d0bb",
    startedAt: "2025-08-20T13:05:00Z",
  },
  {
    id: "sub_008",
    userId: "usr_008",
    plan: "free",
    billingCycle: "monthly",
    platform: "android",
    status: "active",
    nextRenewalDate: null,
    platformRefId: "free_usr_008",
    startedAt: "2025-08-25T17:20:00Z",
  },
  {
    id: "sub_009",
    userId: "usr_009",
    plan: "premium",
    billingCycle: "monthly",
    platform: "ios",
    status: "active",
    nextRenewalDate: "2025-10-01T00:00:00Z",
    platformRefId: "apple_txn_aa55ff",
    startedAt: "2025-09-01T10:15:00Z",
  },
  {
    id: "sub_010",
    userId: "usr_010",
    plan: "free",
    billingCycle: "monthly",
    platform: "android",
    status: "cancelled",
    nextRenewalDate: null,
    platformRefId: "free_usr_010",
    startedAt: "2025-09-05T12:00:00Z",
  },
  {
    id: "sub_011",
    userId: "usr_011",
    plan: "pro",
    billingCycle: "yearly",
    platform: "android",
    status: "active",
    nextRenewalDate: "2026-09-10T00:00:00Z",
    platformRefId: "gp_txn_11ee44",
    startedAt: "2025-09-10T09:45:00Z",
  },
  {
    id: "sub_012",
    userId: "usr_012",
    plan: "free",
    billingCycle: "monthly",
    platform: "ios",
    status: "active",
    nextRenewalDate: null,
    platformRefId: "free_usr_012",
    startedAt: "2025-09-15T15:00:00Z",
  },
];

export const mockSubscriptionHistory: SubscriptionHistoryEntry[] = [
  {
    id: "sh_001",
    subscriptionId: "sub_001",
    plan: "pro",
    event: "Upgraded to Pro",
    date: "2025-06-12T10:05:00Z",
    amountSar: 29,
  },
  {
    id: "sh_002",
    subscriptionId: "sub_001",
    plan: "premium",
    event: "Upgraded to Premium (yearly)",
    date: "2025-07-01T09:00:00Z",
    amountSar: 299,
  },
  {
    id: "sh_003",
    subscriptionId: "sub_002",
    plan: "pro",
    event: "Renewed Pro monthly",
    date: "2025-09-01T00:00:00Z",
    amountSar: 29,
  },
  {
    id: "sh_004",
    subscriptionId: "sub_006",
    plan: "premium",
    event: "Cancelled Premium",
    date: "2025-09-01T12:00:00Z",
    amountSar: 0,
  },
  {
    id: "sh_005",
    subscriptionId: "sub_007",
    plan: "pro",
    event: "Expired — payment failed",
    date: "2025-09-20T00:00:00Z",
    amountSar: 0,
  },
  {
    id: "sh_006",
    subscriptionId: "sub_009",
    plan: "premium",
    event: "Started Premium monthly",
    date: "2025-09-01T10:15:00Z",
    amountSar: 49,
  },
];

export function getSubscriptions(): Subscription[] {
  return mockSubscriptions;
}

export function getSubscriptionById(id: string): Subscription | undefined {
  return mockSubscriptions.find((s) => s.id === id);
}

export function getSubscriptionByUserId(userId: string): Subscription | undefined {
  return mockSubscriptions.find((s) => s.userId === userId);
}

export function getSubscriptionHistory(subscriptionId: string): SubscriptionHistoryEntry[] {
  return mockSubscriptionHistory.filter((h) => h.subscriptionId === subscriptionId);
}

export function getSubscriptionHistoryByUserId(userId: string): SubscriptionHistoryEntry[] {
  const sub = getSubscriptionByUserId(userId);
  if (!sub) return [];
  return getSubscriptionHistory(sub.id);
}
