"use client";

import Box from "@mui/material/Box";
import TextField from "@mui/material/TextField";
import { useRouter } from "next/navigation";
import { useMemo, useState } from "react";
import type { GridColDef, GridRowParams } from "@mui/x-data-grid";
import { PageHeader } from "@/components/layout/PageHeader";
import { DataTable } from "@/components/ui/DataTable";
import { StatusChip } from "@/components/ui/StatusChip";
import { getUserById } from "@/lib/mock/mock-users";
import { getVehicles } from "@/lib/mock/mock-vehicles";

export default function VehiclesPage() {
  const router = useRouter();
  const vehicles = useMemo(() => getVehicles(), []);
  const [search, setSearch] = useState("");

  const rows = useMemo(() => {
    const q = search.trim().toLowerCase();
    return vehicles
      .filter((v) => {
        const owner = getUserById(v.ownerId);
        if (!q) return true;
        return (
          v.make.toLowerCase().includes(q) ||
          v.model.toLowerCase().includes(q) ||
          v.plateNumber.toLowerCase().includes(q) ||
          (owner?.name.toLowerCase().includes(q) ?? false)
        );
      })
      .map((v) => ({
        ...v,
        ownerName: getUserById(v.ownerId)?.name ?? v.ownerId,
      }));
  }, [vehicles, search]);

  const columns: GridColDef[] = [
    { field: "make", headerName: "Make", width: 120 },
    { field: "model", headerName: "Model", width: 130 },
    { field: "plateNumber", headerName: "Plate Number", flex: 1, minWidth: 130 },
    { field: "ownerName", headerName: "Owner", flex: 1, minWidth: 150 },
    {
      field: "qrStatus",
      headerName: "QR Status",
      width: 130,
      renderCell: (p) => <StatusChip status={p.value as string} />,
    },
    {
      field: "flaggedForReview",
      headerName: "Review",
      width: 110,
      renderCell: (p) => (p.value ? <StatusChip status="flagged" label="Flagged" /> : "—"),
    },
  ];

  return (
    <Box>
      <PageHeader title="Vehicles" description="Registered vehicles and QR status" />
      <TextField
        placeholder="Search make, model, plate, owner…"
        value={search}
        onChange={(e) => setSearch(e.target.value)}
        sx={{ mb: 2, maxWidth: 420 }}
        fullWidth
      />
      <DataTable
        rows={rows}
        columns={columns}
        getRowId={(r) => r.id}
        onRowClick={(params: GridRowParams) => router.push(`/vehicles/${params.id}`)}
      />
    </Box>
  );
}
