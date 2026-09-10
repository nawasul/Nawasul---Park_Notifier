"use client";

import Box from "@mui/material/Box";
import Button from "@mui/material/Button";
import Card from "@mui/material/Card";
import CardContent from "@mui/material/CardContent";
import Chip from "@mui/material/Chip";
import Grid from "@mui/material/Grid";
import MenuItem from "@mui/material/MenuItem";
import Stack from "@mui/material/Stack";
import Tab from "@mui/material/Tab";
import Tabs from "@mui/material/Tabs";
import TextField from "@mui/material/TextField";
import Typography from "@mui/material/Typography";
import { useMemo, useState } from "react";
import type { GridColDef } from "@mui/x-data-grid";
import { PageHeader } from "@/components/layout/PageHeader";
import { DataTable } from "@/components/ui/DataTable";
import { StatusChip } from "@/components/ui/StatusChip";
import { useAuth } from "@/components/providers/AuthProvider";
import { getAdmins } from "@/lib/mock/mock-admins";
import type { AdminRole } from "@/lib/mock/types";

type Integration = {
  name: string;
  status: "healthy" | "down";
};

const INTEGRATIONS: Integration[] = [
  { name: "Taqnyat SMS", status: "healthy" },
  { name: "Taqnyat Voice", status: "healthy" },
  { name: "Firebase", status: "healthy" },
  { name: "Supabase", status: "down" },
];

export default function SettingsPage() {
  const { session } = useAuth();
  const isSuper = session?.role === "super_admin";
  const isFulfillment = session?.role === "fulfillment_staff";

  const availableTabs = useMemo((): string[] => {
    if (isFulfillment) return ["integrations"];
    if (isSuper) return ["team", "config", "integrations", "legal"];
    return ["config", "integrations", "legal"];
  }, [isSuper, isFulfillment]);

  const [tab, setTab] = useState<string>(availableTabs[0]);
  const [inviteEmail, setInviteEmail] = useState("");
  const [inviteRole, setInviteRole] = useState<AdminRole>("support_agent");
  const [inviteMsg, setInviteMsg] = useState("");
  const [rateLimit, setRateLimit] = useState(5);
  const [proPrice, setProPrice] = useState(29);
  const [premiumPrice, setPremiumPrice] = useState(49);
  const [configSaved, setConfigSaved] = useState(false);
  const [privacy, setPrivacy] = useState("# Privacy Policy\n\nDraft content for mobile/website.");
  const [terms, setTerms] = useState("# Terms of Service\n\nDraft content for mobile/website.");
  const [legalSaved, setLegalSaved] = useState(false);

  const admins = useMemo(() => getAdmins().map((a) => ({ ...a, password: "••••••••" })), []);

  const adminCols: GridColDef[] = [
    { field: "name", headerName: "Name", flex: 1 },
    { field: "email", headerName: "Email", flex: 1 },
    {
      field: "role",
      headerName: "Role",
      width: 180,
      renderCell: (p) => <StatusChip status={String(p.value)} />,
    },
  ];

  const safeTab = availableTabs.includes(tab) ? tab : availableTabs[0];

  return (
    <Box>
      <PageHeader title="Settings" description="Admin team, app config, integrations, and legal" />

      <Tabs
        value={safeTab}
        onChange={(_, v) => setTab(v)}
        sx={{ mb: 3 }}
        variant="scrollable"
      >
        {availableTabs.includes("team") ? <Tab value="team" label="Admin Team" /> : null}
        {availableTabs.includes("config") ? <Tab value="config" label="App Configuration" /> : null}
        {availableTabs.includes("integrations") ? (
          <Tab value="integrations" label="Integration Health" />
        ) : null}
        {availableTabs.includes("legal") ? <Tab value="legal" label="Legal Content" /> : null}
      </Tabs>

      {safeTab === "team" && isSuper ? (
        <Stack spacing={2}>
          <DataTable rows={admins} columns={adminCols} getRowId={(r) => r.id} height={320} />
          <Card>
            <CardContent>
              <Typography variant="h2" sx={{ mb: 2 }}>
                Invite admin
              </Typography>
              <Stack direction={{ xs: "column", sm: "row" }} spacing={2}>
                <TextField
                  label="Email"
                  value={inviteEmail}
                  onChange={(e) => setInviteEmail(e.target.value)}
                  fullWidth
                />
                <TextField
                  select
                  label="Role"
                  value={inviteRole}
                  onChange={(e) => setInviteRole(e.target.value as AdminRole)}
                  sx={{ minWidth: 200 }}
                >
                  <MenuItem value="super_admin">Super Admin</MenuItem>
                  <MenuItem value="support_agent">Support Agent</MenuItem>
                  <MenuItem value="fulfillment_staff">Fulfillment Staff</MenuItem>
                </TextField>
                <Button
                  variant="contained"
                  onClick={() => {
                    setInviteMsg(`Mock invite sent to ${inviteEmail} as ${inviteRole}`);
                    setInviteEmail("");
                  }}
                >
                  Invite
                </Button>
              </Stack>
              {inviteMsg ? (
                <Typography variant="body2" color="success.main" sx={{ mt: 2 }}>
                  {inviteMsg}
                </Typography>
              ) : null}
            </CardContent>
          </Card>
        </Stack>
      ) : null}

      {safeTab === "config" ? (
        <Card>
          <CardContent>
            <Typography variant="h2" sx={{ mb: 2 }}>
              Abuse prevention & pricing
            </Typography>
            <Stack spacing={2} sx={{ maxWidth: 420 }}>
              <TextField
                label="Max notifications per QR / hour"
                type="number"
                value={rateLimit}
                onChange={(e) => setRateLimit(Number(e.target.value))}
              />
              <TextField
                label="Pro plan price (SAR / month)"
                type="number"
                value={proPrice}
                onChange={(e) => setProPrice(Number(e.target.value))}
              />
              <TextField
                label="Premium plan price (SAR / month)"
                type="number"
                value={premiumPrice}
                onChange={(e) => setPremiumPrice(Number(e.target.value))}
              />
              <Button
                variant="contained"
                onClick={() => setConfigSaved(true)}
                sx={{ alignSelf: "flex-start" }}
              >
                Save configuration
              </Button>
              {configSaved ? (
                <Typography variant="body2" color="success.main">
                  Mock save successful (not persisted to backend).
                </Typography>
              ) : null}
            </Stack>
          </CardContent>
        </Card>
      ) : null}

      {safeTab === "integrations" ? (
        <Grid container spacing={2}>
          {INTEGRATIONS.map((item) => (
            <Grid key={item.name} size={{ xs: 12, sm: 6, md: 3 }}>
              <Card>
                <CardContent>
                  <Stack direction="row" sx={{ justifyContent: "space-between", alignItems: "center" }}>
                    <Typography variant="h3">{item.name}</Typography>
                    <Chip
                      size="small"
                      label={item.status === "healthy" ? "Healthy" : "Down"}
                      color={item.status === "healthy" ? "success" : "error"}
                    />
                  </Stack>
                </CardContent>
              </Card>
            </Grid>
          ))}
        </Grid>
      ) : null}

      {safeTab === "legal" ? (
        <Stack spacing={2}>
          <Card>
            <CardContent>
              <Typography variant="h2" sx={{ mb: 2 }}>
                Privacy Policy
              </Typography>
              <TextField
                multiline
                minRows={8}
                fullWidth
                value={privacy}
                onChange={(e) => setPrivacy(e.target.value)}
              />
            </CardContent>
          </Card>
          <Card>
            <CardContent>
              <Typography variant="h2" sx={{ mb: 2 }}>
                Terms of Service
              </Typography>
              <TextField
                multiline
                minRows={8}
                fullWidth
                value={terms}
                onChange={(e) => setTerms(e.target.value)}
              />
              <Button
                sx={{ mt: 2 }}
                variant="contained"
                onClick={() => setLegalSaved(true)}
              >
                Save legal content
              </Button>
              {legalSaved ? (
                <Typography variant="body2" color="success.main" sx={{ mt: 1 }}>
                  Mock save — publishing to app/website is a future backend integration.
                </Typography>
              ) : null}
            </CardContent>
          </Card>
        </Stack>
      ) : null}
    </Box>
  );
}
