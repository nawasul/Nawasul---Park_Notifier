"use client";

import Box from "@mui/material/Box";
import Button from "@mui/material/Button";
import Drawer from "@mui/material/Drawer";
import MenuItem from "@mui/material/MenuItem";
import Stack from "@mui/material/Stack";
import Tab from "@mui/material/Tab";
import Tabs from "@mui/material/Tabs";
import TextField from "@mui/material/TextField";
import Typography from "@mui/material/Typography";
import { useSearchParams } from "next/navigation";
import { useMemo, useState } from "react";
import type { GridColDef, GridRowSelectionModel } from "@mui/x-data-grid";
import { PageHeader } from "@/components/layout/PageHeader";
import { DataTable } from "@/components/ui/DataTable";
import { StatusChip } from "@/components/ui/StatusChip";
import { downloadCsv, toCsv } from "@/lib/csv";
import {
  getQrOrderById,
  getQrOrders,
  updateQrOrderStatus,
  updateQrOrderTracking,
} from "@/lib/mock/mock-qr-orders";
import { getUserById } from "@/lib/mock/mock-users";
import { getVehicleById } from "@/lib/mock/mock-vehicles";
import type { QrOrder, QrOrderStatus } from "@/lib/mock/types";

const STATUSES: Array<QrOrderStatus | "all"> = [
  "all",
  "ordered",
  "printed",
  "shipped",
  "delivered",
];

export default function QrOrdersClient() {
  const searchParams = useSearchParams();
  const initialStatus = (searchParams.get("status") as QrOrderStatus | null) ?? "all";

  const [orders, setOrders] = useState(() => getQrOrders().map((o) => ({ ...o })));
  const [tab, setTab] = useState<QrOrderStatus | "all">(
    STATUSES.includes(initialStatus) ? initialStatus : "all"
  );
  const [selection, setSelection] = useState<GridRowSelectionModel>({
    type: "include",
    ids: new Set(),
  });
  const [selectedId, setSelectedId] = useState<string | null>(null);
  const [tracking, setTracking] = useState("");
  const [bulkStatus, setBulkStatus] = useState<QrOrderStatus>("printed");

  const selectedIds = useMemo(() => {
    if (selection.type === "exclude") {
      return orders.filter((o) => !selection.ids.has(o.id)).map((o) => o.id);
    }
    return Array.from(selection.ids).map(String);
  }, [selection, orders]);

  const rows = useMemo(() => {
    return orders
      .filter((o) => (tab === "all" ? true : o.status === tab))
      .map((o) => {
        const vehicle = getVehicleById(o.vehicleId);
        const user = getUserById(o.userId);
        return {
          ...o,
          plate: vehicle?.plateNumber ?? o.vehicleId,
          customer: user?.name ?? o.userId,
        };
      });
  }, [orders, tab]);

  const detail: QrOrder | undefined = selectedId
    ? (orders.find((o) => o.id === selectedId) ?? getQrOrderById(selectedId))
    : undefined;

  const columns: GridColDef[] = [
    { field: "id", headerName: "Order", width: 110 },
    { field: "customer", headerName: "Customer", flex: 1, minWidth: 140 },
    { field: "plate", headerName: "Vehicle", width: 120 },
    { field: "quantity", headerName: "Qty", width: 70 },
    { field: "city", headerName: "City", width: 110 },
    {
      field: "orderDate",
      headerName: "Ordered",
      width: 120,
      valueFormatter: (v: string) => new Date(v).toLocaleDateString(),
    },
    {
      field: "status",
      headerName: "Status",
      width: 130,
      renderCell: (p) => <StatusChip status={p.value as string} />,
    },
  ];

  function refreshFromMock() {
    setOrders(getQrOrders().map((o) => ({ ...o })));
  }

  function exportCsv() {
    const csv = toCsv(
      rows.map((r) => ({
        id: r.id,
        customer: r.customer,
        plate: r.plate,
        quantity: r.quantity,
        city: r.city,
        status: r.status,
        shippingAddress: r.shippingAddress,
        trackingNumber: r.trackingNumber,
        orderDate: r.orderDate,
      }))
    );
    downloadCsv(`qr-orders-${tab}.csv`, csv);
  }

  return (
    <Box>
      <PageHeader
        title="QR Orders"
        description="Fulfillment pipeline for physical sticker orders"
        action={
          <Stack direction="row" spacing={1}>
            <Button variant="outlined" onClick={exportCsv}>
              Export CSV
            </Button>
          </Stack>
        }
      />

      <Tabs
        value={tab}
        onChange={(_, v: QrOrderStatus | "all") => setTab(v)}
        sx={{ mb: 2 }}
        variant="scrollable"
      >
        {STATUSES.map((s) => (
          <Tab
            key={s}
            value={s}
            label={s === "all" ? "All" : s.charAt(0).toUpperCase() + s.slice(1)}
          />
        ))}
      </Tabs>

      <Stack
        direction={{ xs: "column", sm: "row" }}
        spacing={1}
        sx={{ mb: 2, alignItems: "center" }}
      >
        <TextField
          select
          label="Bulk status"
          value={bulkStatus}
          onChange={(e) => setBulkStatus(e.target.value as QrOrderStatus)}
          sx={{ minWidth: 160 }}
        >
          {(["ordered", "printed", "shipped", "delivered"] as QrOrderStatus[]).map((s) => (
            <MenuItem key={s} value={s}>
              {s}
            </MenuItem>
          ))}
        </TextField>
        <Button
          variant="contained"
          disabled={selectedIds.length === 0}
          onClick={() => {
            updateQrOrderStatus(selectedIds, bulkStatus);
            refreshFromMock();
            setSelection({ type: "include", ids: new Set() });
          }}
        >
          Update {selectedIds.length || ""} selected
        </Button>
      </Stack>

      <DataTable
        rows={rows}
        columns={columns}
        getRowId={(r) => r.id}
        checkboxSelection
        rowSelectionModel={selection}
        onRowSelectionModelChange={(m) => setSelection(m)}
        onRowClick={(p) => {
          setSelectedId(String(p.id));
          const order = orders.find((o) => o.id === p.id);
          setTracking(order?.trackingNumber ?? "");
        }}
      />

      <Drawer
        anchor="right"
        open={Boolean(detail)}
        onClose={() => setSelectedId(null)}
        slotProps={{ paper: { sx: { width: { xs: "100%", sm: 400 }, p: 3 } } }}
      >
        {detail ? (
          <Stack spacing={2}>
            <Typography variant="h2">Order {detail.id}</Typography>
            <StatusChip status={detail.status} />
            <Typography variant="body1">
              Vehicle: {getVehicleById(detail.vehicleId)?.plateNumber}
            </Typography>
            <Typography variant="body1">Customer: {getUserById(detail.userId)?.name}</Typography>
            <Typography variant="body1">Qty: {detail.quantity}</Typography>
            <Typography variant="body1">
              Address: {detail.shippingAddress}, {detail.city}
            </Typography>
            <Typography variant="body1">
              Ordered: {new Date(detail.orderDate).toLocaleString()}
            </Typography>
            <TextField
              label="Tracking number"
              value={tracking}
              onChange={(e) => setTracking(e.target.value)}
              fullWidth
            />
            <Button
              variant="contained"
              onClick={() => {
                updateQrOrderTracking(detail.id, tracking);
                refreshFromMock();
              }}
            >
              Save tracking
            </Button>
          </Stack>
        ) : null}
      </Drawer>
    </Box>
  );
}
