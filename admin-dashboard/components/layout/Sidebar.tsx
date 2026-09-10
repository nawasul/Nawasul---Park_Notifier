"use client";

import Box from "@mui/material/Box";
import Drawer from "@mui/material/Drawer";
import List from "@mui/material/List";
import ListItemButton from "@mui/material/ListItemButton";
import ListItemIcon from "@mui/material/ListItemIcon";
import ListItemText from "@mui/material/ListItemText";
import Typography from "@mui/material/Typography";
import NextLink from "next/link";
import { usePathname } from "next/navigation";
import { useAuth } from "@/components/providers/AuthProvider";
import { navItemsForRole } from "@/lib/nav";

export const SIDEBAR_WIDTH = 248;

type SidebarProps = {
  mobileOpen: boolean;
  onClose: () => void;
};

export function Sidebar({ mobileOpen, onClose }: SidebarProps) {
  const pathname = usePathname();
  const { session } = useAuth();
  const role = session?.role ?? "support_agent";
  const items = navItemsForRole(role);

  const content = (
    <Box sx={{ height: "100%", display: "flex", flexDirection: "column", bgcolor: "grey.900" }}>
      <Box sx={{ px: 2.5, py: 2.5 }}>
        <Typography variant="h2" sx={{ color: "common.white", fontSize: 20 }}>
          Nawasul
        </Typography>
        <Typography variant="caption" sx={{ color: "grey.400" }}>
          Admin Operations
        </Typography>
      </Box>
      <List sx={{ px: 1, flex: 1 }}>
        {items.map((item) => {
          const selected = pathname === item.href || pathname.startsWith(`${item.href}/`);
          const Icon = item.icon;
          return (
            <ListItemButton
              key={item.href}
              component={NextLink}
              href={item.href}
              selected={selected}
              onClick={onClose}
              sx={{
                borderRadius: 2,
                mb: 0.5,
                color: "grey.300",
                "&.Mui-selected": {
                  bgcolor: "primary.main",
                  color: "common.white",
                  "&:hover": { bgcolor: "primary.dark" },
                  "& .MuiListItemIcon-root": { color: "common.white" },
                },
                "&:hover": { bgcolor: "rgba(255,255,255,0.06)" },
              }}
            >
              <ListItemIcon sx={{ minWidth: 40, color: "grey.400" }}>
                <Icon fontSize="small" />
              </ListItemIcon>
              <ListItemText
                primary={item.label}
                slotProps={{ primary: { sx: { fontSize: 14, fontWeight: 500 } } }}
              />
            </ListItemButton>
          );
        })}
      </List>
      <Box sx={{ px: 2.5, py: 2 }}>
        <Typography variant="caption" sx={{ color: "grey.500" }}>
          Role: {role.replace("_", " ")}
        </Typography>
      </Box>
    </Box>
  );

  return (
    <>
      <Drawer
        variant="temporary"
        open={mobileOpen}
        onClose={onClose}
        ModalProps={{ keepMounted: true }}
        sx={{
          display: { xs: "block", md: "none" },
          "& .MuiDrawer-paper": { width: SIDEBAR_WIDTH, border: "none" },
        }}
      >
        {content}
      </Drawer>
      <Drawer
        variant="permanent"
        open
        sx={{
          display: { xs: "none", md: "block" },
          width: SIDEBAR_WIDTH,
          flexShrink: 0,
          "& .MuiDrawer-paper": {
            width: SIDEBAR_WIDTH,
            border: "none",
            boxSizing: "border-box",
          },
        }}
      >
        {content}
      </Drawer>
    </>
  );
}
