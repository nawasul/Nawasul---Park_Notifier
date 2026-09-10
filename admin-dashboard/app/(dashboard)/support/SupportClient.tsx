"use client";

import Box from "@mui/material/Box";
import MenuItem from "@mui/material/MenuItem";
import TextField from "@mui/material/TextField";
import { useRouter, useSearchParams } from "next/navigation";
import { useMemo, useState } from "react";
import type { GridColDef, GridRowParams } from "@mui/x-data-grid";
import { PageHeader } from "@/components/layout/PageHeader";
import { DataTable } from "@/components/ui/DataTable";
import { StatusChip } from "@/components/ui/StatusChip";
import { getSupportTickets } from "@/lib/mock/mock-support-tickets";
import type { TicketStatus } from "@/lib/mock/types";

export default function SupportClient() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const initialStatus = (searchParams.get("status") as TicketStatus | "all" | null) ?? "all";
  const [status, setStatus] = useState<TicketStatus | "all">(
    initialStatus === "open" || initialStatus === "in_progress" || initialStatus === "resolved"
      ? initialStatus
      : "all"
  );

  const rows = useMemo(() => {
    return getSupportTickets()
      .filter((t) => (status === "all" ? true : t.status === status))
      .map((t) => ({ ...t }));
  }, [status]);

  const columns: GridColDef[] = [
    { field: "subject", headerName: "Subject", flex: 1.4, minWidth: 180 },
    { field: "submitterName", headerName: "Submitter", flex: 1, minWidth: 140 },
    {
      field: "createdAt",
      headerName: "Date",
      width: 140,
      valueFormatter: (v: string) => new Date(v).toLocaleDateString(),
    },
    {
      field: "status",
      headerName: "Status",
      width: 130,
      renderCell: (p) => <StatusChip status={p.value as string} />,
    },
    {
      field: "source",
      headerName: "Source",
      width: 130,
      valueFormatter: (v: string) => (v === "mobile_app" ? "Mobile App" : "Website"),
    },
  ];

  return (
    <Box>
      <PageHeader title="Support Tickets" description="Inbox for Contact Support submissions" />
      <TextField
        select
        label="Status"
        value={status}
        onChange={(e) => setStatus(e.target.value as TicketStatus | "all")}
        sx={{ mb: 2, minWidth: 180 }}
      >
        <MenuItem value="all">All</MenuItem>
        <MenuItem value="open">Open</MenuItem>
        <MenuItem value="in_progress">In Progress</MenuItem>
        <MenuItem value="resolved">Resolved</MenuItem>
      </TextField>
      <DataTable
        rows={rows}
        columns={columns}
        getRowId={(r) => r.id}
        onRowClick={(p: GridRowParams) => router.push(`/support/${p.id}`)}
      />
    </Box>
  );
}
