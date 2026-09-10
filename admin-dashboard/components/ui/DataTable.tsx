"use client";

import { DataGrid, type DataGridProps, type GridColDef } from "@mui/x-data-grid";
import Box from "@mui/material/Box";
import { useTheme } from "@mui/material/styles";

export type DataTableProps = Omit<DataGridProps, "columns"> & {
  columns: GridColDef[];
  height?: number | string;
};

export function DataTable({ columns, height = 520, sx, ...props }: DataTableProps) {
  const theme = useTheme();

  return (
    <Box
      sx={{
        height,
        width: "100%",
        bgcolor: "background.paper",
        borderRadius: 2.5,
        overflow: "hidden",
        border: `1px solid ${theme.palette.divider}`,
      }}
    >
      <DataGrid
        columns={columns}
        disableRowSelectionOnClick
        pageSizeOptions={[10, 25, 50]}
        initialState={{
          pagination: { paginationModel: { pageSize: 10, page: 0 } },
        }}
        sx={{
          border: "none",
          "& .MuiDataGrid-columnHeaders": {
            bgcolor: "grey.100",
            fontWeight: 600,
          },
          "& .MuiDataGrid-row:hover": {
            cursor: props.onRowClick ? "pointer" : "default",
          },
          ...sx,
        }}
        {...props}
      />
    </Box>
  );
}
