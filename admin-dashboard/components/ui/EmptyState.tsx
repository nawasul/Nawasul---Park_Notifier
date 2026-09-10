"use client";

import Box from "@mui/material/Box";
import Typography from "@mui/material/Typography";
import type { ReactNode } from "react";

type EmptyStateProps = {
  title: string;
  description?: string;
  action?: ReactNode;
};

export function EmptyState({ title, description, action }: EmptyStateProps) {
  return (
    <Box
      sx={{
        py: 8,
        px: 3,
        textAlign: "center",
        bgcolor: "background.paper",
        borderRadius: 2.5,
        border: (t) => `1px dashed ${t.palette.divider}`,
      }}
    >
      <Typography variant="h2">{title}</Typography>
      {description ? (
        <Typography variant="body1" color="text.secondary" sx={{ mt: 1, maxWidth: 420, mx: "auto" }}>
          {description}
        </Typography>
      ) : null}
      {action ? <Box sx={{ mt: 2 }}>{action}</Box> : null}
    </Box>
  );
}
