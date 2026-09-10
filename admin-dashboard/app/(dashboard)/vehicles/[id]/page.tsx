"use client";

import Box from "@mui/material/Box";
import Button from "@mui/material/Button";
import Card from "@mui/material/Card";
import CardContent from "@mui/material/CardContent";
import Link from "@mui/material/Link";
import Stack from "@mui/material/Stack";
import Typography from "@mui/material/Typography";
import NextLink from "next/link";
import { useParams } from "next/navigation";
import { useMemo, useState } from "react";
import type { GridColDef } from "@mui/x-data-grid";
import { PageHeader } from "@/components/layout/PageHeader";
import { ConfirmActionDialog } from "@/components/ui/ConfirmActionDialog";
import { DataTable } from "@/components/ui/DataTable";
import { EmptyState } from "@/components/ui/EmptyState";
import { StatusChip } from "@/components/ui/StatusChip";
import { useAuth } from "@/components/providers/AuthProvider";
import { getCallLogsByVehicleId } from "@/lib/mock/mock-call-logs";
import { getQrOrdersByVehicleId } from "@/lib/mock/mock-qr-orders";
import { getUserById } from "@/lib/mock/mock-users";
import {
  deactivateVehicleQr,
  flagVehicleForReview,
  getVehicleById,
} from "@/lib/mock/mock-vehicles";

type ConfirmKind = "deactivate" | "flag" | null;

export default function VehicleDetailPage() {
  const params = useParams<{ id: string }>();
  const { session } = useAuth();
  const canMutate = session?.role !== "fulfillment_staff";

  const initial = getVehicleById(params.id);
  const [vehicle, setVehicle] = useState(initial);
  const [confirm, setConfirm] = useState<ConfirmKind>(null);

  const owner = vehicle ? getUserById(vehicle.ownerId) : undefined;
  const orders = useMemo(
    () => (vehicle ? getQrOrdersByVehicleId(vehicle.id) : []),
    [vehicle]
  );
  const alerts = useMemo(
    () => (vehicle ? getCallLogsByVehicleId(vehicle.id) : []),
    [vehicle]
  );

  if (!vehicle) {
    return <EmptyState title="Vehicle not found" />;
  }

  const orderCols: GridColDef[] = [
    { field: "id", headerName: "Order", width: 110 },
    {
      field: "status",
      headerName: "Status",
      width: 130,
      renderCell: (p) => <StatusChip status={p.value as string} />,
    },
    { field: "orderDate", headerName: "Ordered", width: 140, valueFormatter: (v: string) => new Date(v).toLocaleDateString() },
    { field: "trackingNumber", headerName: "Tracking", flex: 1 },
  ];

  const alertCols: GridColDef[] = [
    { field: "timestamp", headerName: "Time", width: 170, valueFormatter: (v: string) => new Date(v).toLocaleString() },
    { field: "reason", headerName: "Reason", flex: 1 },
    {
      field: "deliveryMethod",
      headerName: "Method",
      width: 110,
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
        title={`${vehicle.make} ${vehicle.model}`}
        breadcrumbs={[
          { label: "Vehicles", href: "/vehicles" },
          { label: vehicle.plateNumber },
        ]}
        action={
          canMutate ? (
            <Stack direction="row" spacing={1}>
              <Button
                variant="outlined"
                color="warning"
                onClick={() => setConfirm("flag")}
                disabled={vehicle.flaggedForReview}
              >
                Flag for Review
              </Button>
              <Button
                variant="contained"
                color="error"
                onClick={() => setConfirm("deactivate")}
                disabled={vehicle.qrStatus === "inactive"}
              >
                Deactivate QR Code
              </Button>
            </Stack>
          ) : null
        }
      />

      <Card sx={{ mb: 3 }}>
        <CardContent>
          <Stack spacing={1}>
            <Typography variant="body1">
              Plate: <strong>{vehicle.plateNumber}</strong> · {vehicle.year}
            </Typography>
            <Typography variant="body1">
              Owner:{" "}
              {owner ? (
                <Link component={NextLink} href={`/users/${owner.id}`}>
                  {owner.name}
                </Link>
              ) : (
                vehicle.ownerId
              )}
            </Typography>
            <Stack direction="row" spacing={1} sx={{ alignItems: "center" }}>
              <Typography variant="body1">QR status:</Typography>
              <StatusChip status={vehicle.qrStatus} />
              {vehicle.flaggedForReview ? <StatusChip status="flagged" label="Flagged for review" /> : null}
            </Stack>
          </Stack>
        </CardContent>
      </Card>

      <Typography variant="h2" sx={{ mb: 1 }}>
        Sticker order history
      </Typography>
      <DataTable rows={orders} columns={orderCols} getRowId={(r) => r.id} height={260} sx={{ mb: 3 }} />

      <Typography variant="h2" sx={{ mb: 1 }}>
        Alert history
      </Typography>
      <DataTable rows={alerts} columns={alertCols} getRowId={(r) => r.id} height={320} />

      <ConfirmActionDialog
        open={confirm === "deactivate"}
        title="Deactivate QR code?"
        description="Use for sold vehicles, fraud, or user request. Scans will stop notifying the owner."
        confirmLabel="Deactivate"
        destructive
        onClose={() => setConfirm(null)}
        onConfirm={() => {
          const updated = deactivateVehicleQr(vehicle.id);
          if (updated) setVehicle({ ...updated });
        }}
      />
      <ConfirmActionDialog
        open={confirm === "flag"}
        title="Flag vehicle for review?"
        description="Marks this vehicle as suspected of QR abuse for the ops team."
        confirmLabel="Flag"
        onClose={() => setConfirm(null)}
        onConfirm={() => {
          const updated = flagVehicleForReview(vehicle.id, true);
          if (updated) setVehicle({ ...updated });
        }}
      />
    </Box>
  );
}
