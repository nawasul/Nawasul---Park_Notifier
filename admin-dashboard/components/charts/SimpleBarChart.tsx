"use client";

import { useTheme } from "@mui/material/styles";
import {
  Bar,
  BarChart,
  CartesianGrid,
  ResponsiveContainer,
  Tooltip,
  XAxis,
  YAxis,
} from "recharts";

type Point = Record<string, string | number>;

type SimpleBarChartProps = {
  data: Point[];
  xKey: string;
  yKey: string;
  height?: number;
};

export function SimpleBarChart({ data, xKey, yKey, height = 260 }: SimpleBarChartProps) {
  const theme = useTheme();

  return (
    <ResponsiveContainer width="100%" height={height}>
      <BarChart data={data} margin={{ top: 8, right: 8, left: 0, bottom: 0 }}>
        <CartesianGrid stroke={theme.palette.divider} strokeDasharray="3 3" />
        <XAxis dataKey={xKey} tick={{ fontSize: 11, fill: theme.palette.text.secondary }} />
        <YAxis tick={{ fontSize: 11, fill: theme.palette.text.secondary }} allowDecimals={false} />
        <Tooltip />
        <Bar dataKey={yKey} fill={theme.palette.primary.main} radius={[6, 6, 0, 0]} />
      </BarChart>
    </ResponsiveContainer>
  );
}
