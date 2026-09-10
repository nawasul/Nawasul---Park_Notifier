import type { SupportTicket, TicketStatus } from "./types";

export const mockSupportTickets: SupportTicket[] = [
  {
    id: "tkt_001",
    subject: "QR sticker never arrived",
    message:
      "I ordered a sticker for my Camry two weeks ago and tracking still shows nothing. Can you help?",
    submitterName: "Ahmed Al-Rashid",
    submitterEmail: "ahmed.rashid@email.com",
    submitterPhone: "+966501112233",
    userId: "usr_001",
    status: "in_progress",
    source: "mobile_app",
    createdAt: "2025-09-18T10:00:00Z",
    internalNotes: "Order ord_001 already delivered — ask user to check mailbox.",
  },
  {
    id: "tkt_002",
    subject: "I paid but app shows Free",
    message:
      "I upgraded to Pro on Google Play yesterday but the app still says Free plan.",
    submitterName: "Fatima Al-Otaibi",
    submitterEmail: "fatima.otaibi@email.com",
    submitterPhone: "+966502223344",
    userId: "usr_002",
    status: "open",
    source: "mobile_app",
    createdAt: "2025-09-20T14:30:00Z",
    internalNotes: "",
  },
  {
    id: "tkt_003",
    subject: "Someone keeps calling my number",
    message:
      "I've been getting spam calls from my QR code. Please disable it.",
    submitterName: "Khalid Mansour",
    submitterEmail: "khalid.m@email.com",
    submitterPhone: "+966503334455",
    userId: "usr_003",
    status: "resolved",
    source: "website",
    createdAt: "2025-09-17T23:00:00Z",
    internalNotes: "QR deactivated on veh_004; account suspended.",
  },
  {
    id: "tkt_004",
    subject: "How do I add a second vehicle?",
    message: "I have a Yukon and an X5. Can both use Premium?",
    submitterName: "Noura Al-Saud",
    submitterEmail: "noura.saud@email.com",
    submitterPhone: "+966504445566",
    userId: "usr_004",
    status: "resolved",
    source: "website",
    createdAt: "2025-09-08T11:00:00Z",
    internalNotes: "Answered via email — multi-vehicle supported on Pro+.",
  },
  {
    id: "tkt_005",
    subject: "Fleet / bulk stickers",
    message: "We manage 40 cars. Do you offer bulk QR stickers and billing?",
    submitterName: "Yousef Ibrahim",
    submitterEmail: "yousef.i@email.com",
    submitterPhone: "+966505556677",
    userId: "usr_005",
    status: "open",
    source: "website",
    createdAt: "2025-09-19T09:00:00Z",
    internalNotes: "Forward to sales / product.",
  },
  {
    id: "tkt_006",
    subject: "Cancel Premium refund",
    message: "I cancelled Premium. When do I get a refund?",
    submitterName: "Hana Al-Qahtani",
    submitterEmail: "hana.q@email.com",
    submitterPhone: "+966506667788",
    userId: "usr_006",
    status: "in_progress",
    source: "mobile_app",
    createdAt: "2025-09-16T16:00:00Z",
    internalNotes: "Store-managed refunds — guide user to Play Store.",
  },
  {
    id: "tkt_007",
    subject: "App crash on scan",
    message: "Android crashes when I open the scan result screen.",
    submitterName: "Reem Al-Mutairi",
    submitterEmail: "reem.m@email.com",
    submitterPhone: "+966508889900",
    userId: "usr_008",
    status: "open",
    source: "mobile_app",
    createdAt: "2025-09-21T07:45:00Z",
    internalNotes: "",
  },
  {
    id: "tkt_008",
    subject: "Wrong plate on sticker",
    message: "My sticker arrived with the wrong plate number printed.",
    submitterName: "Tariq Al-Ghamdi",
    submitterEmail: "tariq.g@email.com",
    submitterPhone: "+966511112233",
    userId: "usr_011",
    status: "open",
    source: "website",
    createdAt: "2025-09-21T08:20:00Z",
    internalNotes: "Reprint candidate — link to ord_011.",
  },
];

export function getSupportTickets(): SupportTicket[] {
  return mockSupportTickets;
}

export function getSupportTicketById(id: string): SupportTicket | undefined {
  return mockSupportTickets.find((t) => t.id === id);
}

export function updateTicketStatus(id: string, status: TicketStatus): SupportTicket | undefined {
  const ticket = mockSupportTickets.find((t) => t.id === id);
  if (!ticket) return undefined;
  ticket.status = status;
  return ticket;
}

export function updateTicketNotes(id: string, notes: string): SupportTicket | undefined {
  const ticket = mockSupportTickets.find((t) => t.id === id);
  if (!ticket) return undefined;
  ticket.internalNotes = notes;
  return ticket;
}
