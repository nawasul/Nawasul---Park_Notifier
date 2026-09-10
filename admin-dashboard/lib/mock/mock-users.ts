import type { User } from "./types";

export const mockUsers: User[] = [
  {
    id: "usr_001",
    name: "Ahmed Al-Rashid",
    email: "ahmed.rashid@email.com",
    phone: "+966501112233",
    city: "Riyadh",
    signupDate: "2025-06-12T10:00:00Z",
    subscriptionPlan: "premium",
    subscriptionStatus: "active",
    accountStatus: "active",
    internalNotes: "VIP customer — prefers WhatsApp for support.",
  },
  {
    id: "usr_002",
    name: "Fatima Al-Otaibi",
    email: "fatima.otaibi@email.com",
    phone: "+966502223344",
    city: "Jeddah",
    signupDate: "2025-07-01T14:20:00Z",
    subscriptionPlan: "pro",
    subscriptionStatus: "active",
    accountStatus: "active",
    internalNotes: "",
  },
  {
    id: "usr_003",
    name: "Khalid Mansour",
    email: "khalid.m@email.com",
    phone: "+966503334455",
    city: "Dammam",
    signupDate: "2025-07-18T09:15:00Z",
    subscriptionPlan: "free",
    subscriptionStatus: "active",
    accountStatus: "suspended",
    internalNotes: "Suspended after repeated spam alerts on veh_004.",
  },
  {
    id: "usr_004",
    name: "Noura Al-Saud",
    email: "noura.saud@email.com",
    phone: "+966504445566",
    city: "Riyadh",
    signupDate: "2025-08-02T16:45:00Z",
    subscriptionPlan: "pro",
    subscriptionStatus: "active",
    accountStatus: "active",
    internalNotes: "",
  },
  {
    id: "usr_005",
    name: "Yousef Ibrahim",
    email: "yousef.i@email.com",
    phone: "+966505556677",
    city: "Mecca",
    signupDate: "2025-08-10T11:00:00Z",
    subscriptionPlan: "free",
    subscriptionStatus: "active",
    accountStatus: "active",
    internalNotes: "Asked about bulk QR stickers for fleet.",
  },
  {
    id: "usr_006",
    name: "Hana Al-Qahtani",
    email: "hana.q@email.com",
    phone: "+966506667788",
    city: "Medina",
    signupDate: "2025-08-15T08:30:00Z",
    subscriptionPlan: "premium",
    subscriptionStatus: "cancelled",
    accountStatus: "active",
    internalNotes: "Cancelled Premium — considering return.",
  },
  {
    id: "usr_007",
    name: "Sultan Al-Dosari",
    email: "sultan.d@email.com",
    phone: "+966507778899",
    city: "Khobar",
    signupDate: "2025-08-20T13:00:00Z",
    subscriptionPlan: "pro",
    subscriptionStatus: "expired",
    accountStatus: "active",
    internalNotes: "",
  },
  {
    id: "usr_008",
    name: "Reem Al-Mutairi",
    email: "reem.m@email.com",
    phone: "+966508889900",
    city: "Jeddah",
    signupDate: "2025-08-25T17:20:00Z",
    subscriptionPlan: "free",
    subscriptionStatus: "active",
    accountStatus: "active",
    internalNotes: "",
  },
  {
    id: "usr_009",
    name: "Faisal Al-Harthi",
    email: "faisal.h@email.com",
    phone: "+966509990011",
    city: "Riyadh",
    signupDate: "2025-09-01T10:10:00Z",
    subscriptionPlan: "premium",
    subscriptionStatus: "active",
    accountStatus: "active",
    internalNotes: "Corporate account interest.",
  },
  {
    id: "usr_010",
    name: "Maha Al-Zahrani",
    email: "maha.z@email.com",
    phone: "+966510001122",
    city: "Abha",
    signupDate: "2025-09-05T12:00:00Z",
    subscriptionPlan: "free",
    subscriptionStatus: "active",
    accountStatus: "deleted",
    internalNotes: "User requested account deletion.",
  },
  {
    id: "usr_011",
    name: "Tariq Al-Ghamdi",
    email: "tariq.g@email.com",
    phone: "+966511112233",
    city: "Taif",
    signupDate: "2025-09-10T09:40:00Z",
    subscriptionPlan: "pro",
    subscriptionStatus: "active",
    accountStatus: "active",
    internalNotes: "",
  },
  {
    id: "usr_012",
    name: "Lina Al-Shehri",
    email: "lina.s@email.com",
    phone: "+966512223344",
    city: "Riyadh",
    signupDate: "2025-09-15T15:00:00Z",
    subscriptionPlan: "free",
    subscriptionStatus: "active",
    accountStatus: "active",
    internalNotes: "New signup — pending QR order.",
  },
];

export function getUsers(): User[] {
  return mockUsers;
}

export function getUserById(id: string): User | undefined {
  return mockUsers.find((u) => u.id === id);
}

export function updateUserNotes(id: string, notes: string): User | undefined {
  const user = mockUsers.find((u) => u.id === id);
  if (!user) return undefined;
  user.internalNotes = notes;
  return user;
}

export function updateUserAccountStatus(
  id: string,
  status: User["accountStatus"]
): User | undefined {
  const user = mockUsers.find((u) => u.id === id);
  if (!user) return undefined;
  user.accountStatus = status;
  return user;
}
