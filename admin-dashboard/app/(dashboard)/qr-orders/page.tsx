"use client";

import Box from "@mui/material/Box";
import CircularProgress from "@mui/material/CircularProgress";
import { Suspense } from "react";
import QrOrdersPage from "./QrOrdersClient";

function Fallback() {
  return (
    <Box sx={{ display: "grid", placeItems: "center", minHeight: 240 }}>
      <CircularProgress />
    </Box>
  );
}

export default function Page() {
  return (
    <Suspense fallback={<Fallback />}>
      <QrOrdersPage />
    </Suspense>
  );
}
