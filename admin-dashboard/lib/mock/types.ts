/** Shared entity types for mock data (mirrors future API shapes). */

export type AdminRole = "super_admin" | "support_agent" | "fulfillment_staff";

export type AccountStatus = "active" | "suspended" | "deleted";
export type SubscriptionPlan = "free" | "pro" | "premium";
export type SubscriptionStatus = "active" | "cancelled" | "expired";
export type BillingCycle = "monthly" | "yearly";
export type Platform = "ios" | "android";

export type QrOrderStatus = "ordered" | "printed" | "shipped" | "delivered";
export type QrStatus = "active" | "inactive" | "pending";

export type DeliveryMethod = "call" | "push" | "sms";
export type DeliveryStatus = "success" | "failed";

export type TicketStatus = "open" | "in_progress" | "resolved";
export type TicketSource = "mobile_app" | "website";

export type AdminUser = {
  id: string;
  name: string;
  email: string;
  role: AdminRole;
  password: string;
  createdAt: string;
};

export type User = {
  id: string;
  name: string;
  email: string;
  phone: string;
  city: string;
  signupDate: string;
  subscriptionPlan: SubscriptionPlan;
  subscriptionStatus: SubscriptionStatus;
  accountStatus: AccountStatus;
  internalNotes: string;
};

export type Vehicle = {
  id: string;
  make: string;
  model: string;
  year: number;
  plateNumber: string;
  ownerId: string;
  qrStatus: QrStatus;
  flaggedForReview: boolean;
  createdAt: string;
};

export type QrOrder = {
  id: string;
  vehicleId: string;
  userId: string;
  status: QrOrderStatus;
  quantity: number;
  shippingAddress: string;
  city: string;
  orderDate: string;
  trackingNumber: string | null;
};

export type Subscription = {
  id: string;
  userId: string;
  plan: SubscriptionPlan;
  billingCycle: BillingCycle;
  platform: Platform;
  status: SubscriptionStatus;
  nextRenewalDate: string | null;
  platformRefId: string;
  startedAt: string;
};

export type SubscriptionHistoryEntry = {
  id: string;
  subscriptionId: string;
  plan: SubscriptionPlan;
  event: string;
  date: string;
  amountSar: number;
};

export type CallLog = {
  id: string;
  vehicleId: string;
  ownerId: string;
  scannerUserId: string | null;
  timestamp: string;
  reason: string;
  deliveryMethod: DeliveryMethod;
  deliveryStatus: DeliveryStatus;
  flaggedAbusive: boolean;
  metadata?: string;
};

export type SupportTicket = {
  id: string;
  subject: string;
  message: string;
  submitterName: string;
  submitterEmail: string;
  submitterPhone: string;
  userId: string | null;
  status: TicketStatus;
  source: TicketSource;
  createdAt: string;
  internalNotes: string;
};

export type AuditLogEntry = {
  id: string;
  adminId: string;
  adminName: string;
  action: string;
  target: string;
  timestamp: string;
};
