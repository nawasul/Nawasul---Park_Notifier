import type { SvgIconProps } from "@mui/material/SvgIcon";
import type { ComponentType } from "react";
import DashboardOutlinedIcon from "@mui/icons-material/DashboardOutlined";
import PeopleOutlinedIcon from "@mui/icons-material/PeopleOutlined";
import DirectionsCarOutlinedIcon from "@mui/icons-material/DirectionsCarOutlined";
import QrCode2OutlinedIcon from "@mui/icons-material/QrCode2Outlined";
import CardMembershipOutlinedIcon from "@mui/icons-material/CardMembershipOutlined";
import PhoneInTalkOutlinedIcon from "@mui/icons-material/PhoneInTalkOutlined";
import SupportAgentOutlinedIcon from "@mui/icons-material/SupportAgentOutlined";
import HistoryOutlinedIcon from "@mui/icons-material/HistoryOutlined";
import SettingsOutlinedIcon from "@mui/icons-material/SettingsOutlined";
import type { AdminRole } from "@/lib/mock/types";

export type NavItem = {
  label: string;
  href: string;
  icon: ComponentType<SvgIconProps>;
  roles: AdminRole[];
};

export const NAV_ITEMS: NavItem[] = [
  {
    label: "Dashboard",
    href: "/dashboard",
    icon: DashboardOutlinedIcon,
    roles: ["super_admin", "support_agent", "fulfillment_staff"],
  },
  {
    label: "Users",
    href: "/users",
    icon: PeopleOutlinedIcon,
    roles: ["super_admin", "support_agent"],
  },
  {
    label: "Vehicles",
    href: "/vehicles",
    icon: DirectionsCarOutlinedIcon,
    roles: ["super_admin", "support_agent", "fulfillment_staff"],
  },
  {
    label: "QR Orders",
    href: "/qr-orders",
    icon: QrCode2OutlinedIcon,
    roles: ["super_admin", "support_agent", "fulfillment_staff"],
  },
  {
    label: "Subscriptions",
    href: "/subscriptions",
    icon: CardMembershipOutlinedIcon,
    roles: ["super_admin", "support_agent"],
  },
  {
    label: "Call Logs",
    href: "/call-logs",
    icon: PhoneInTalkOutlinedIcon,
    roles: ["super_admin", "support_agent"],
  },
  {
    label: "Support",
    href: "/support",
    icon: SupportAgentOutlinedIcon,
    roles: ["super_admin", "support_agent"],
  },
  {
    label: "Audit Log",
    href: "/audit-log",
    icon: HistoryOutlinedIcon,
    roles: ["super_admin", "support_agent"],
  },
  {
    label: "Settings",
    href: "/settings",
    icon: SettingsOutlinedIcon,
    roles: ["super_admin", "support_agent", "fulfillment_staff"],
  },
];

export function navItemsForRole(role: AdminRole): NavItem[] {
  return NAV_ITEMS.filter((item) => item.roles.includes(role));
}
