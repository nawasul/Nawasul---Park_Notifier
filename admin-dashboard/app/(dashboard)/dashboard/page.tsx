"use client";

import PeopleOutlinedIcon from "@mui/icons-material/PeopleOutlined";
import CardMembershipOutlinedIcon from "@mui/icons-material/CardMembershipOutlined";
import DirectionsCarOutlinedIcon from "@mui/icons-material/DirectionsCarOutlined";
import QrCode2OutlinedIcon from "@mui/icons-material/QrCode2Outlined";
import PhoneInTalkOutlinedIcon from "@mui/icons-material/PhoneInTalkOutlined";
import Box from "@mui/material/Box";
import Button from "@mui/material/Button";
import Card from "@mui/material/Card";
import CardContent from "@mui/material/CardContent";
import Grid from "@mui/material/Grid";
import Stack from "@mui/material/Stack";
import ToggleButton from "@mui/material/ToggleButton";
import ToggleButtonGroup from "@mui/material/ToggleButtonGroup";
import Typography from "@mui/material/Typography";
import NextLink from "next/link";
import { useMemo, useState } from "react";
import { SimpleDonutChart } from "@/components/charts/SimpleDonutChart";
import { SimpleLineChart } from "@/components/charts/SimpleLineChart";
import { PageHeader } from "@/components/layout/PageHeader";
import { MetricCard } from "@/components/ui/MetricCard";
import {
  getDashboardMetrics,
  getDashboardTimeSeries,
  getRecentActivity,
} from "@/lib/mock/mock-dashboard";

export default function DashboardPage() {
  const metrics = useMemo(() => getDashboardMetrics(), []);
  const series = useMemo(() => getDashboardTimeSeries(), []);
  const activity = useMemo(() => getRecentActivity(10), []);
  const [alertWindow, setAlertWindow] = useState<"today" | "week">("today");

  const donutData = metrics.planDistribution.map((p) => ({
    name: p.plan.charAt(0).toUpperCase() + p.plan.slice(1),
    value: p.count,
  }));

  return (
    <Box>
      <PageHeader
        title="Dashboard"
        description="Operations snapshot for Nawasul staff"
      />

      <Grid container spacing={2} sx={{ mb: 2 }}>
        <Grid size={{ xs: 12, sm: 6, md: 4, lg: 2.4 }}>
          <MetricCard title="Total Users" value={metrics.totalUsers} icon={<PeopleOutlinedIcon />} />
        </Grid>
        <Grid size={{ xs: 12, sm: 6, md: 4, lg: 2.4 }}>
          <MetricCard
            title="Active Subscriptions"
            value={metrics.activeSubscriptions}
            icon={<CardMembershipOutlinedIcon />}
          />
        </Grid>
        <Grid size={{ xs: 12, sm: 6, md: 4, lg: 2.4 }}>
          <MetricCard
            title="Vehicles Registered"
            value={metrics.vehiclesRegistered}
            icon={<DirectionsCarOutlinedIcon />}
          />
        </Grid>
        <Grid size={{ xs: 12, sm: 6, md: 4, lg: 2.4 }}>
          <MetricCard
            title="Pending QR Orders"
            value={metrics.pendingQrOrders}
            icon={<QrCode2OutlinedIcon />}
          />
        </Grid>
        <Grid size={{ xs: 12, sm: 6, md: 4, lg: 2.4 }}>
          <Card sx={{ height: "100%" }}>
            <CardContent>
              <Stack direction="row" sx={{ justifyContent: "space-between", alignItems: "center" }}>
                <Typography variant="caption" color="text.secondary">
                  Alerts Triggered
                </Typography>
                <ToggleButtonGroup
                  size="small"
                  exclusive
                  value={alertWindow}
                  onChange={(_, v) => v && setAlertWindow(v)}
                >
                  <ToggleButton value="today">Today</ToggleButton>
                  <ToggleButton value="week">Week</ToggleButton>
                </ToggleButtonGroup>
              </Stack>
              <Box sx={{ display: "flex", alignItems: "center", gap: 1, mt: 1 }}>
                <PhoneInTalkOutlinedIcon color="primary" />
                <Typography variant="h1" sx={{ fontSize: 28 }}>
                  {alertWindow === "today" ? metrics.alertsToday : metrics.alertsThisWeek}
                </Typography>
              </Box>
            </CardContent>
          </Card>
        </Grid>
      </Grid>

      <Grid container spacing={2} sx={{ mb: 2 }}>
        <Grid size={{ xs: 12, md: 4 }}>
          <Card sx={{ height: "100%" }}>
            <CardContent>
              <Typography variant="h2" sx={{ mb: 1 }}>
                Revenue snapshot
              </Typography>
              <Typography variant="h1" sx={{ fontSize: 32, color: "primary.main" }}>
                SAR {metrics.mrrEstimateSar.toFixed(0)}
              </Typography>
              <Typography variant="caption" color="text.secondary">
                Estimated MRR
              </Typography>
              <Box sx={{ mt: 2 }}>
                <SimpleDonutChart data={donutData} />
              </Box>
              <Stack direction="row" spacing={2} sx={{ justifyContent: "center" }}>
                {donutData.map((d) => (
                  <Typography key={d.name} variant="caption" color="text.secondary">
                    {d.name}: {d.value}
                  </Typography>
                ))}
              </Stack>
            </CardContent>
          </Card>
        </Grid>
        <Grid size={{ xs: 12, md: 8 }}>
          <Card sx={{ height: "100%" }}>
            <CardContent>
              <Typography variant="h2" sx={{ mb: 1 }}>
                Signups & alert volume (30 days)
              </Typography>
              {/* Chart helps spot abuse spikes correlating with signup growth */}
              <SimpleLineChart data={series} xKey="date" yKey="signups" yKey2="alerts" height={280} />
            </CardContent>
          </Card>
        </Grid>
      </Grid>

      <Grid container spacing={2}>
        <Grid size={{ xs: 12, md: 8 }}>
          <Card>
            <CardContent>
              <Typography variant="h2" sx={{ mb: 2 }}>
                Recent activity
              </Typography>
              <Stack spacing={1.5}>
                {activity.map((item) => (
                  <Box
                    key={item.id}
                    sx={{
                      display: "flex",
                      justifyContent: "space-between",
                      gap: 2,
                      py: 1,
                      borderBottom: (t) => `1px solid ${t.palette.divider}`,
                    }}
                  >
                    <Box>
                      <Typography variant="body1" sx={{ fontWeight: 600 }}>
                        {item.title}
                      </Typography>
                      <Typography variant="caption" color="text.secondary">
                        {item.subtitle} · {item.type}
                      </Typography>
                    </Box>
                    <Typography variant="caption" color="text.secondary" sx={{ whiteSpace: "nowrap" }}>
                      {new Date(item.timestamp).toLocaleString()}
                    </Typography>
                  </Box>
                ))}
              </Stack>
            </CardContent>
          </Card>
        </Grid>
        <Grid size={{ xs: 12, md: 4 }}>
          <Card>
            <CardContent>
              <Typography variant="h2" sx={{ mb: 2 }}>
                Quick actions
              </Typography>
              <Stack spacing={1.5}>
                <Button
                  component={NextLink}
                  href="/qr-orders?status=ordered"
                  variant="contained"
                  fullWidth
                >
                  View Pending QR Orders
                </Button>
                <Button
                  component={NextLink}
                  href="/call-logs?flagged=1"
                  variant="outlined"
                  fullWidth
                >
                  View Flagged Alerts
                </Button>
                <Button component={NextLink} href="/support?status=open" variant="outlined" fullWidth>
                  View Support Tickets
                </Button>
              </Stack>
            </CardContent>
          </Card>
        </Grid>
      </Grid>
    </Box>
  );
}
