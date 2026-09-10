"use client";

import Box from "@mui/material/Box";
import TextField from "@mui/material/TextField";
import { useRouter } from "next/navigation";
import { useMemo, useState } from "react";
import type { GridColDef, GridRowParams } from "@mui/x-data-grid";
import { PageHeader } from "@/components/layout/PageHeader";
import { DataTable } from "@/components/ui/DataTable";
import { StatusChip } from "@/components/ui/StatusChip";
import { getUsers } from "@/lib/mock/mock-users";

export default function UsersPage() {
  const router = useRouter();
  const users = useMemo(() => getUsers(), []);
  const [search, setSearch] = useState("");

  const rows = useMemo(() => {
    const q = search.trim().toLowerCase();
    return users
      .filter((u) => {
        if (!q) return true;
        return (
          u.name.toLowerCase().includes(q) ||
          u.phone.includes(q) ||
          u.city.toLowerCase().includes(q) ||
          u.email.toLowerCase().includes(q)
        );
      })
      .map((u) => ({ ...u }));
  }, [users, search]);

  const columns: GridColDef[] = [
    { field: "name", headerName: "Name", flex: 1, minWidth: 160 },
    { field: "phone", headerName: "Phone", width: 150 },
    { field: "city", headerName: "City", width: 120 },
    {
      field: "signupDate",
      headerName: "Signup Date",
      width: 140,
      valueFormatter: (value: string) => new Date(value).toLocaleDateString(),
    },
    {
      field: "subscriptionStatus",
      headerName: "Subscription",
      width: 140,
      renderCell: (params) => (
        <StatusChip status={params.row.subscriptionPlan} label={`${params.row.subscriptionPlan} · ${params.row.subscriptionStatus}`} />
      ),
    },
    {
      field: "accountStatus",
      headerName: "Account",
      width: 130,
      renderCell: (params) => <StatusChip status={params.value as string} />,
    },
  ];

  return (
    <Box>
      <PageHeader title="Users" description="Search and manage customer accounts" />
      <TextField
        placeholder="Search name, phone, city, email…"
        value={search}
        onChange={(e) => setSearch(e.target.value)}
        sx={{ mb: 2, maxWidth: 420 }}
        fullWidth
      />
      <DataTable
        rows={rows}
        columns={columns}
        getRowId={(row) => row.id}
        onRowClick={(params: GridRowParams) => router.push(`/users/${params.id}`)}
        filterMode="client"
        disableColumnFilter={false}
      />
    </Box>
  );
}
