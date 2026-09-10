"use client";

import Box from "@mui/material/Box";
import Button from "@mui/material/Button";
import Card from "@mui/material/Card";
import CardContent from "@mui/material/CardContent";
import Grid from "@mui/material/Grid";
import Link from "@mui/material/Link";
import Stack from "@mui/material/Stack";
import TextField from "@mui/material/TextField";
import Typography from "@mui/material/Typography";
import NextLink from "next/link";
import { useParams, useRouter } from "next/navigation";
import { useMemo, useState } from "react";
import type { GridColDef } from "@mui/x-data-grid";
import { PageHeader } from "@/components/layout/PageHeader";
import { ConfirmActionDialog } from "@/components/ui/ConfirmActionDialog";
import { DataTable } from "@/components/ui/DataTable";
import { EmptyState } from "@/components/ui/EmptyState";
import { StatusChip } from "@/components/ui/StatusChip";
import { useAuth } from "@/components/providers/AuthProvider";
import { getCallLogsByUserId } from "@/lib/mock/mock-call-logs";
import { getSubscriptionByUserId, getSubscriptionHistoryByUserId } from "@/lib/mock/mock-subscriptions";
import { getUserById, updateUserAccountStatus, updateUserNotes } from "@/lib/mock/mock-users";
import { getVehiclesByOwnerId } from "@/lib/mock/mock-vehicles";

type ConfirmKind = "suspend" | "reactivate" | "delete" | null;

export default function UserDetailPage() {
  const router = useRouter();
  const params = useParams<{ id: string }>();
  const { session } = useAuth();
  const canMutate = session?.role === "super_admin" || session?.role === "support_agent";

  const initial = getUserById(params.id);
  const [user, setUser] = useState(initial);
  const [notes, setNotes] = useState(initial?.internalNotes ?? "");
  const [confirm, setConfirm] = useState<ConfirmKind>(null);

  const vehicles = useMemo(
    () => (user ? getVehiclesByOwnerId(user.id) : []),
    [user]
  );
  const sub = useMemo(() => (user ? getSubscriptionByUserId(user.id) : undefined), [user]);
  const history = useMemo(
    () => (user ? getSubscriptionHistoryByUserId(user.id) : []),
    [user]
  );
  const calls = useMemo(() => (user ? getCallLogsByUserId(user.id) : []), [user]);

  if (!user) {
    return <EmptyState title="User not found" description="This user id is not in mock data." />;
  }

  const vehicleCols: GridColDef[] = [
    { field: "plateNumber", headerName: "Plate", flex: 1 },
    { field: "make", headerName: "Make", width: 120 },
    { field: "model", headerName: "Model", width: 120 },
    {
      field: "qrStatus",
      headerName: "QR",
      width: 120,
      renderCell: (p) => <StatusChip status={p.value as string} />,
    },
  ];

  const historyCols: GridColDef[] = [
    { field: "date", headerName: "Date", width: 140, valueFormatter: (v: string) => new Date(v).toLocaleDateString() },
    { field: "event", headerName: "Event", flex: 1 },
    { field: "plan", headerName: "Plan", width: 100 },
    { field: "amountSar", headerName: "SAR", width: 90 },
  ];

  const callCols: GridColDef[] = [
    { field: "timestamp", headerName: "Time", width: 170, valueFormatter: (v: string) => new Date(v).toLocaleString() },
    { field: "reason", headerName: "Reason", flex: 1 },
    {
      field: "deliveryStatus",
      headerName: "Status",
      width: 110,
      renderCell: (p) => <StatusChip status={p.value as string} />,
    },
    {
      field: "flaggedAbusive",
      headerName: "Flag",
      width: 110,
      renderCell: (p) => (p.value ? <StatusChip status="flagged" label="Flagged" /> : "—"),
    },
  ];

  return (
    <Box>
      <PageHeader
        title={user.name}
        breadcrumbs={[
          { label: "Users", href: "/users" },
          { label: user.name },
        ]}
        action={
          canMutate ? (
            <Stack direction="row" spacing={1}>
              {user.accountStatus === "active" ? (
                <Button color="warning" variant="outlined" onClick={() => setConfirm("suspend")}>
                  Suspend
                </Button>
              ) : user.accountStatus === "suspended" ? (
                <Button color="success" variant="outlined" onClick={() => setConfirm("reactivate")}>
                  Reactivate
                </Button>
              ) : null}
              {user.accountStatus !== "deleted" ? (
                <Button color="error" variant="contained" onClick={() => setConfirm("delete")}>
                  Trigger Deletion
                </Button>
              ) : null}
            </Stack>
          ) : null
        }
      />

      <Grid container spacing={2} sx={{ mb: 2 }}>
        <Grid size={{ xs: 12, md: 6 }}>
          <Card>
            <CardContent>
              <Typography variant="h2" sx={{ mb: 2 }}>
                Profile
              </Typography>
              <Stack spacing={1}>
                <Typography variant="body1">Email: {user.email}</Typography>
                <Typography variant="body1">Phone: {user.phone}</Typography>
                <Typography variant="body1">City: {user.city}</Typography>
                <Typography variant="body1">
                  Signup: {new Date(user.signupDate).toLocaleDateString()}
                </Typography>
                <Stack direction="row" spacing={1} sx={{ alignItems: "center" }}>
                  <Typography variant="body1">Account:</Typography>
                  <StatusChip status={user.accountStatus} />
                </Stack>
                <Stack direction="row" spacing={1} sx={{ alignItems: "center" }}>
                  <Typography variant="body1">Plan:</Typography>
                  <StatusChip status={user.subscriptionPlan} />
                  <StatusChip status={user.subscriptionStatus} />
                </Stack>
                {sub ? (
                  <Typography variant="body2" color="text.secondary">
                    Platform ref: {sub.platformRefId}
                  </Typography>
                ) : null}
              </Stack>
            </CardContent>
          </Card>
        </Grid>
        <Grid size={{ xs: 12, md: 6 }}>
          <Card sx={{ height: "100%" }}>
            <CardContent>
              <Typography variant="h2" sx={{ mb: 2 }}>
                Internal notes
              </Typography>
              <TextField
                multiline
                minRows={5}
                fullWidth
                value={notes}
                onChange={(e) => setNotes(e.target.value)}
                disabled={!canMutate}
              />
              {canMutate ? (
                <Button
                  sx={{ mt: 2 }}
                  variant="contained"
                  onClick={() => {
                    updateUserNotes(user.id, notes);
                    setUser({ ...user, internalNotes: notes });
                  }}
                >
                  Save notes
                </Button>
              ) : null}
            </CardContent>
          </Card>
        </Grid>
      </Grid>

      <Typography variant="h2" sx={{ mb: 1 }}>
        Linked vehicles
      </Typography>
      <DataTable
        rows={vehicles}
        columns={vehicleCols}
        getRowId={(r) => r.id}
        height={280}
        onRowClick={(p) => {
          router.push(`/vehicles/${p.id}`);
        }}
      />
      <Box sx={{ mt: 1, mb: 3 }}>
        {vehicles.map((v) => (
          <Link key={v.id} component={NextLink} href={`/vehicles/${v.id}`} sx={{ mr: 2 }} variant="caption">
            {v.plateNumber}
          </Link>
        ))}
      </Box>

      <Typography variant="h2" sx={{ mb: 1 }}>
        Subscription history
      </Typography>
      <DataTable rows={history} columns={historyCols} getRowId={(r) => r.id} height={260} sx={{ mb: 3 }} />

      <Typography variant="h2" sx={{ mb: 1 }}>
        Alert / call history
      </Typography>
      <DataTable rows={calls} columns={callCols} getRowId={(r) => r.id} height={320} />

      <ConfirmActionDialog
        open={confirm === "suspend"}
        title="Suspend user?"
        description={`Suspend ${user.name}? They will not receive alerts until reactivated.`}
        confirmLabel="Suspend"
        destructive
        onClose={() => setConfirm(null)}
        onConfirm={() => {
          const updated = updateUserAccountStatus(user.id, "suspended");
          if (updated) setUser({ ...updated });
        }}
      />
      <ConfirmActionDialog
        open={confirm === "reactivate"}
        title="Reactivate user?"
        description={`Reactivate ${user.name}?`}
        confirmLabel="Reactivate"
        onClose={() => setConfirm(null)}
        onConfirm={() => {
          const updated = updateUserAccountStatus(user.id, "active");
          if (updated) setUser({ ...updated });
        }}
      />
      <ConfirmActionDialog
        open={confirm === "delete"}
        title="Trigger account deletion?"
        description={`Mark ${user.name} as deleted. This is a mock soft-delete.`}
        confirmLabel="Delete"
        destructive
        onClose={() => setConfirm(null)}
        onConfirm={() => {
          const updated = updateUserAccountStatus(user.id, "deleted");
          if (updated) setUser({ ...updated });
        }}
      />
    </Box>
  );
}
