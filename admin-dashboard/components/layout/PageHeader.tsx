"use client";

import Box from "@mui/material/Box";
import Breadcrumbs from "@mui/material/Breadcrumbs";
import Link from "@mui/material/Link";
import Stack from "@mui/material/Stack";
import Typography from "@mui/material/Typography";
import NextLink from "next/link";
import type { ReactNode } from "react";

export type Crumb = { label: string; href?: string };

type PageHeaderProps = {
  title: string;
  breadcrumbs?: Crumb[];
  action?: ReactNode;
  description?: string;
};

export function PageHeader({ title, breadcrumbs, action, description }: PageHeaderProps) {
  return (
    <Stack
      direction={{ xs: "column", sm: "row" }}
      spacing={2}
      sx={{
        mb: 3,
        justifyContent: "space-between",
        alignItems: { xs: "flex-start", sm: "center" },
      }}
    >
      <Box>
        {breadcrumbs && breadcrumbs.length > 0 ? (
          <Breadcrumbs sx={{ mb: 0.5 }}>
            {breadcrumbs.map((c) =>
              c.href ? (
                <Link
                  key={c.label}
                  component={NextLink}
                  href={c.href}
                  underline="hover"
                  color="text.secondary"
                  variant="caption"
                >
                  {c.label}
                </Link>
              ) : (
                <Typography key={c.label} variant="caption" color="text.primary">
                  {c.label}
                </Typography>
              )
            )}
          </Breadcrumbs>
        ) : null}
        <Typography variant="h1">{title}</Typography>
        {description ? (
          <Typography variant="body1" color="text.secondary" sx={{ mt: 0.5 }}>
            {description}
          </Typography>
        ) : null}
      </Box>
      {action ? <Box sx={{ flexShrink: 0 }}>{action}</Box> : null}
    </Stack>
  );
}
