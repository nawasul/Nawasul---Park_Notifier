"use client";

import CallIcon from "@mui/icons-material/Call";
import NotificationsActiveIcon from "@mui/icons-material/NotificationsActive";
import SmsIcon from "@mui/icons-material/Sms";
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
import type { GridColDef } from "@mui/x-data-grid";
import { PageHeader } from "@/components/layout/PageHeader";
import { ConfirmActionDialog } from "@/components/ui/ConfirmActionDialog";
import { DataTable } from "@/components/ui/DataTable";
import { StatusChip } from "@/components/ui/StatusChip";
import { flagCallLogAbusive, getCallLogs } from "@/lib/mock/mock-call-logs";
import { getVehicleById, getVehicles } from "@/lib/mock/mock-vehicles";

function MethodIcon({ method }: { method: string }) {
  if (method === "call") return <CallIcon fontSize="small" />;
  if (method === "sms") return <SmsIcon fontSize="small" />;
  return <NotificationsActiveIcon fontSize="small" />;
}

export default function CallLogsClient() {
  const searchParams = useSearchParams();
  const initialFlagged = searchParams.get("flagged") === "1";

  const [logs, setLogs] = useState(() => getCallLogs().map((l) => ({ ...l })));
  const [tab, setTab] = useState<"all" | "flagged">(initialFlagged ? "flagged" : "all");
  const [vehicleId, setVehicleId] = useState("all");
  const [fromDate, setFromDate] = useState("");
  const [toDate, setToDate] = useState("");
  const [selectedId, setSelectedId] = useState<string | null>(null);
  const [confirmFlag, setConfirmFlag] = useState(false);

  const vehicles = useMemo(() => getVehicles(), []);

  const rows = useMemo(() => {
    return logs
      .filter((l) => (tab === "flagged" ? l.flaggedAbusive : true))
      .filter((l) => (vehicleId === "all" ? true : l.vehicleId === vehicleId))
      .filter((l) => {
        const t = new Date(l.timestamp).getTime();
        if (fromDate && t < new Date(fromDate).getTime()) return false;
        if (toDate && t > new Date(`${toDate}T23:59:59`).getTime()) return false;
        return true;
      })
      .map((l) => ({
        ...l,
        plate: getVehicleById(l.vehicleId)?.plateNumber ?? l.vehicleId,
      }));
  }, [logs, tab, vehicleId, fromDate, toDate]);

  const detail = selectedId ? logs.find((l) => l.id === selectedId) : undefined;

  const columns: GridColDef[] = [
    { field: "plate", headerName: "Vehicle", width: 120 },
    {
      field: "timestamp",
      headerName: "Timestamp",
      width: 170,
      valueFormatter: (v: string) => new Date(v).toLocaleString(),
    },
    { field: "reason", headerName: "Reason", flex: 1, minWidth: 140 },
    {
      field: "deliveryMethod",
      headerName: "Method",
      width: 100,
      renderCell: (p) => <MethodIcon method={p.value as string} />,
    },
    {
      field: "deliveryStatus",
      headerName: "Delivery",
      width: 120,
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
        title="Call Logs"
        description="Notification audit trail — investigate abuse patterns by vehicle and date"
      />

      <Tabs value={tab} onChange={(_, v) => setTab(v)} sx={{ mb: 2 }}>
        <Tab value="all" label="All" />
        <Tab value="flagged" label="Flagged" />
      </Tabs>

      <Stack direction={{ xs: "column", md: "row" }} spacing={2} sx={{ mb: 2 }}>
        <TextField
          select
          label="Vehicle"
          value={vehicleId}
          onChange={(e) => setVehicleId(e.target.value)}
          sx={{ minWidth: 200 }}
        >
          <MenuItem value="all">All vehicles</MenuItem>
          {vehicles.map((v) => (
            <MenuItem key={v.id} value={v.id}>
              {v.plateNumber}
            </MenuItem>
          ))}
        </TextField>
        <TextField
          label="From"
          type="date"
          value={fromDate}
          onChange={(e) => setFromDate(e.target.value)}
          slotProps={{ inputLabel: { shrink: true } }}
        />
        <TextField
          label="To"
          type="date"
          value={toDate}
          onChange={(e) => setToDate(e.target.value)}
          slotProps={{ inputLabel: { shrink: true } }}
        />
      </Stack>

      <DataTable
        rows={rows}
        columns={columns}
        getRowId={(r) => r.id}
        onRowClick={(p) => setSelectedId(String(p.id))}
        getRowClassName={(p) => (p.row.flaggedAbusive ? "flagged-row" : "")}
        sx={{
          "& .flagged-row": {
            bgcolor: "error.light",
          },
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
            <Typography variant="h2">Alert detail</Typography>
            <Typography variant="body1">
              Vehicle: {getVehicleById(detail.vehicleId)?.plateNumber}
            </Typography>
            <Typography variant="body1">{new Date(detail.timestamp).toLocaleString()}</Typography>
            <Typography variant="body1">Reason: {detail.reason}</Typography>
            <Stack direction="row" spacing={1} sx={{ alignItems: "center" }}>
              <MethodIcon method={detail.deliveryMethod} />
              <StatusChip status={detail.deliveryStatus} />
              {detail.flaggedAbusive ? <StatusChip status="flagged" label="Flagged" /> : null}
            </Stack>
            {detail.metadata ? (
              <Typography variant="body2" color="text.secondary">
                {detail.metadata}
              </Typography>
            ) : null}
            {!detail.flaggedAbusive ? (
              <Button color="error" variant="contained" onClick={() => setConfirmFlag(true)}>
                Flag as Abusive/Spam
              </Button>
            ) : null}
          </Stack>
        ) : null}
      </Drawer>

      <ConfirmActionDialog
        open={confirmFlag}
        title="Flag as abusive/spam?"
        description="This alert will appear in the Flagged filter for further investigation."
        confirmLabel="Flag"
        destructive
        onClose={() => setConfirmFlag(false)}
        onConfirm={() => {
          if (!selectedId) return;
          flagCallLogAbusive(selectedId, true);
          setLogs(getCallLogs().map((l) => ({ ...l })));
        }}
      />
    </Box>
  );
}
