"use client";

import Box from "@mui/material/Box";
import Alert from "@mui/material/Alert";
import { useMemo } from "react";
import type { GridColDef } from "@mui/x-data-grid";
import { PageHeader } from "@/components/layout/PageHeader";
import { DataTable } from "@/components/ui/DataTable";
import { getAuditLog } from "@/lib/mock/mock-audit-log";

export default function AuditLogPage() {
  const rows = useMemo(() => getAuditLog(), []);

  const columns: GridColDef[] = [
    { field: "adminName", headerName: "Admin User", flex: 1, minWidth: 140 },
    { field: "action", headerName: "Action Taken", flex: 1.2, minWidth: 160 },
    { field: "target", headerName: "Target", flex: 1.4, minWidth: 180 },
    {
      field: "timestamp",
      headerName: "Timestamp",
      width: 180,
      valueFormatter: (v: string) => new Date(v).toLocaleString(),
    },
  ];

  return (
    <Box>
      <PageHeader
        title="Audit Log"
        description="Read-only record of admin actions for accountability"
      />
      <Alert severity="info" sx={{ mb: 2 }}>
        Display-only mock data. Real mutations should write audit entries once the backend exists.
      </Alert>
      <DataTable rows={rows} columns={columns} getRowId={(r) => r.id} />
    </Box>
  );
}
