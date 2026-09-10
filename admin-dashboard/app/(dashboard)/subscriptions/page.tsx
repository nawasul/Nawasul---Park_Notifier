"use client";

import AppleIcon from "@mui/icons-material/Apple";
import AndroidIcon from "@mui/icons-material/Android";
import Box from "@mui/material/Box";
import Card from "@mui/material/Card";
import CardContent from "@mui/material/CardContent";
import Drawer from "@mui/material/Drawer";
import Grid from "@mui/material/Grid";
import MenuItem from "@mui/material/MenuItem";
import Stack from "@mui/material/Stack";
import TextField from "@mui/material/TextField";
import Typography from "@mui/material/Typography";
import { useMemo, useState } from "react";
import type { GridColDef } from "@mui/x-data-grid";
import { PageHeader } from "@/components/layout/PageHeader";
import { DataTable } from "@/components/ui/DataTable";
import { MetricCard } from "@/components/ui/MetricCard";
import { StatusChip } from "@/components/ui/StatusChip";
import { getDashboardMetrics } from "@/lib/mock/mock-dashboard";
import {
  getSubscriptionById,
  getSubscriptionHistory,
  getSubscriptions,
} from "@/lib/mock/mock-subscriptions";
import { getUserById } from "@/lib/mock/mock-users";
import type { SubscriptionPlan, SubscriptionStatus } from "@/lib/mock/types";

export default function SubscriptionsPage() {
  const metrics = useMemo(() => getDashboardMetrics(), []);
  const [planFilter, setPlanFilter] = useState<SubscriptionPlan | "all">("all");
  const [statusFilter, setStatusFilter] = useState<SubscriptionStatus | "all">("all");
  const [selectedId, setSelectedId] = useState<string | null>(null);

  const rows = useMemo(() => {
    return getSubscriptions()
      .filter((s) => (planFilter === "all" ? true : s.plan === planFilter))
      .filter((s) => (statusFilter === "all" ? true : s.status === statusFilter))
      .map((s) => ({
        ...s,
        userName: getUserById(s.userId)?.name ?? s.userId,
      }));
  }, [planFilter, statusFilter]);

  const detail = selectedId ? getSubscriptionById(selectedId) : undefined;
  const history = detail ? getSubscriptionHistory(detail.id) : [];

  const columns: GridColDef[] = [
    { field: "userName", headerName: "User", flex: 1, minWidth: 150 },
    {
      field: "plan",
      headerName: "Plan",
      width: 120,
      renderCell: (p) => <StatusChip status={p.value as string} />,
    },
    { field: "billingCycle", headerName: "Billing", width: 110 },
    {
      field: "platform",
      headerName: "Platform",
      width: 100,
      renderCell: (p) =>
        p.value === "ios" ? <AppleIcon fontSize="small" /> : <AndroidIcon fontSize="small" />,
    },
    {
      field: "status",
      headerName: "Status",
      width: 130,
      renderCell: (p) => <StatusChip status={p.value as string} />,
    },
    {
      field: "nextRenewalDate",
      headerName: "Next renewal",
      width: 140,
      valueFormatter: (v: string | null) => (v ? new Date(v).toLocaleDateString() : "—"),
    },
  ];

  return (
    <Box>
      <PageHeader title="Subscriptions" description="Billing plans and renewal status" />

      <Grid container spacing={2} sx={{ mb: 2 }}>
        <Grid size={{ xs: 12, sm: 4 }}>
          <MetricCard title="MRR estimate" value={`SAR ${metrics.mrrEstimateSar.toFixed(0)}`} />
        </Grid>
        <Grid size={{ xs: 12, sm: 4 }}>
          <MetricCard title="Churn rate" value={`${metrics.churnRatePercent}%`} />
        </Grid>
        <Grid size={{ xs: 12, sm: 4 }}>
          <MetricCard
            title="Plan mix"
            value={metrics.planDistribution.map((p) => `${p.plan}:${p.count}`).join(" · ")}
          />
        </Grid>
      </Grid>

      <Stack direction={{ xs: "column", sm: "row" }} spacing={2} sx={{ mb: 2 }}>
        <TextField
          select
          label="Plan"
          value={planFilter}
          onChange={(e) => setPlanFilter(e.target.value as SubscriptionPlan | "all")}
          sx={{ minWidth: 160 }}
        >
          <MenuItem value="all">All</MenuItem>
          <MenuItem value="free">Free</MenuItem>
          <MenuItem value="pro">Pro</MenuItem>
          <MenuItem value="premium">Premium</MenuItem>
        </TextField>
        <TextField
          select
          label="Status"
          value={statusFilter}
          onChange={(e) => setStatusFilter(e.target.value as SubscriptionStatus | "all")}
          sx={{ minWidth: 160 }}
        >
          <MenuItem value="all">All</MenuItem>
          <MenuItem value="active">Active</MenuItem>
          <MenuItem value="cancelled">Cancelled</MenuItem>
          <MenuItem value="expired">Expired</MenuItem>
        </TextField>
      </Stack>

      <DataTable
        rows={rows}
        columns={columns}
        getRowId={(r) => r.id}
        onRowClick={(p) => setSelectedId(String(p.id))}
      />

      <Drawer
        anchor="right"
        open={Boolean(detail)}
        onClose={() => setSelectedId(null)}
        slotProps={{ paper: { sx: { width: { xs: "100%", sm: 420 }, p: 3 } } }}
      >
        {detail ? (
          <Stack spacing={2}>
            <Typography variant="h2">Subscription detail</Typography>
            <Typography variant="body1">
              User: {getUserById(detail.userId)?.name}
            </Typography>
            <Stack direction="row" spacing={1}>
              <StatusChip status={detail.plan} />
              <StatusChip status={detail.status} />
            </Stack>
            <Typography variant="body1">Platform ref: {detail.platformRefId}</Typography>
            <Typography variant="body1">
              Started: {new Date(detail.startedAt).toLocaleString()}
            </Typography>
            <Typography variant="h3">Renewal history</Typography>
            {history.length === 0 ? (
              <Typography variant="body2" color="text.secondary">
                No history entries
              </Typography>
            ) : (
              history.map((h) => (
                <Card key={h.id} variant="outlined">
                  <CardContent sx={{ py: 1.5, "&:last-child": { pb: 1.5 } }}>
                    <Typography variant="body1">{h.event}</Typography>
                    <Typography variant="caption" color="text.secondary">
                      {new Date(h.date).toLocaleString()} · SAR {h.amountSar}
                    </Typography>
                  </CardContent>
                </Card>
              ))
            )}
          </Stack>
        ) : null}
      </Drawer>
    </Box>
  );
}
