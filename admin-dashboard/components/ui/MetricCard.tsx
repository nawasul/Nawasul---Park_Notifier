"use client";

import Box from "@mui/material/Box";
import Card from "@mui/material/Card";
import CardContent from "@mui/material/CardContent";
import Typography from "@mui/material/Typography";
import type { ReactNode } from "react";

type MetricCardProps = {
  title: string;
  value: string | number;
  subtitle?: string;
  icon?: ReactNode;
};

export function MetricCard({ title, value, subtitle, icon }: MetricCardProps) {
  return (
    <Card sx={{ height: "100%" }}>
      <CardContent>
        <Box sx={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start" }}>
          <Box>
            <Typography variant="caption" color="text.secondary">
              {title}
            </Typography>
            <Typography variant="h1" sx={{ mt: 0.5, fontSize: 28 }}>
              {value}
            </Typography>
            {subtitle ? (
              <Typography variant="body2" color="text.secondary" sx={{ mt: 0.5 }}>
                {subtitle}
              </Typography>
            ) : null}
          </Box>
          {icon ? (
            <Box
              sx={{
                bgcolor: "primary.light",
                color: "primary.main",
                borderRadius: 2,
                p: 1,
                display: "flex",
              }}
            >
              {icon}
            </Box>
          ) : null}
        </Box>
      </CardContent>
    </Card>
  );
}
