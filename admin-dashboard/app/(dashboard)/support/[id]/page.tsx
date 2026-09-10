"use client";

import Box from "@mui/material/Box";
import Button from "@mui/material/Button";
import Card from "@mui/material/Card";
import CardContent from "@mui/material/CardContent";
import Chip from "@mui/material/Chip";
import MenuItem from "@mui/material/MenuItem";
import Stack from "@mui/material/Stack";
import TextField from "@mui/material/TextField";
import Typography from "@mui/material/Typography";
import { useParams } from "next/navigation";
import { useState } from "react";
import { PageHeader } from "@/components/layout/PageHeader";
import { EmptyState } from "@/components/ui/EmptyState";
import { StatusChip } from "@/components/ui/StatusChip";
import {
  getSupportTicketById,
  updateTicketNotes,
  updateTicketStatus,
} from "@/lib/mock/mock-support-tickets";
import type { TicketStatus } from "@/lib/mock/types";

export default function SupportTicketDetailPage() {
  const params = useParams<{ id: string }>();
  const initial = getSupportTicketById(params.id);
  const [ticket, setTicket] = useState(initial);
  const [notes, setNotes] = useState(initial?.internalNotes ?? "");
  const [status, setStatus] = useState<TicketStatus>(initial?.status ?? "open");

  if (!ticket) {
    return <EmptyState title="Ticket not found" />;
  }

  return (
    <Box>
      <PageHeader
        title={ticket.subject}
        breadcrumbs={[
          { label: "Support", href: "/support" },
          { label: ticket.id },
        ]}
      />

      <Stack spacing={2} sx={{ maxWidth: 800 }}>
        <Card>
          <CardContent>
            <Stack direction="row" spacing={1} sx={{ mb: 2 }}>
              <StatusChip status={ticket.status} />
              <Chip
                size="small"
                label={ticket.source === "mobile_app" ? "Mobile App" : "Website"}
              />
            </Stack>
            <Typography variant="body1" sx={{ whiteSpace: "pre-wrap", mb: 2 }}>
              {ticket.message}
            </Typography>
            <Typography variant="body2" color="text.secondary">
              {ticket.submitterName} · {ticket.submitterEmail} · {ticket.submitterPhone}
            </Typography>
            <Typography variant="caption" color="text.secondary" sx={{ display: "block" }}>
              {new Date(ticket.createdAt).toLocaleString()}
            </Typography>
          </CardContent>
        </Card>

        <Card>
          <CardContent>
            <Typography variant="h2" sx={{ mb: 2 }}>
              Agent actions
            </Typography>
            <TextField
              select
              label="Status"
              value={status}
              onChange={(e) => setStatus(e.target.value as TicketStatus)}
              sx={{ mb: 2, minWidth: 200 }}
            >
              <MenuItem value="open">Open</MenuItem>
              <MenuItem value="in_progress">In Progress</MenuItem>
              <MenuItem value="resolved">Resolved</MenuItem>
            </TextField>
            <TextField
              label="Internal reply / notes"
              multiline
              minRows={4}
              fullWidth
              value={notes}
              onChange={(e) => setNotes(e.target.value)}
              sx={{ mb: 2 }}
            />
            <Button
              variant="contained"
              onClick={() => {
                updateTicketStatus(ticket.id, status);
                updateTicketNotes(ticket.id, notes);
                const updated = getSupportTicketById(ticket.id);
                if (updated) setTicket({ ...updated });
              }}
            >
              Save
            </Button>
          </CardContent>
        </Card>
      </Stack>
    </Box>
  );
}
