"use client";

import { useTheme } from "@mui/material/styles";
import {
  CartesianGrid,
  Line,
  LineChart,
  ResponsiveContainer,
  Tooltip,
  XAxis,
  YAxis,
} from "recharts";

type Point = Record<string, string | number>;

type SimpleLineChartProps = {
  data: Point[];
  xKey: string;
  yKey: string;
  yKey2?: string;
  height?: number;
};

export function SimpleLineChart({
  data,
  xKey,
  yKey,
  yKey2,
  height = 260,
}: SimpleLineChartProps) {
  const theme = useTheme();

  return (
    <ResponsiveContainer width="100%" height={height}>
      <LineChart data={data} margin={{ top: 8, right: 8, left: 0, bottom: 0 }}>
        <CartesianGrid stroke={theme.palette.divider} strokeDasharray="3 3" />
        <XAxis dataKey={xKey} tick={{ fontSize: 11, fill: theme.palette.text.secondary }} />
        <YAxis tick={{ fontSize: 11, fill: theme.palette.text.secondary }} allowDecimals={false} />
        <Tooltip />
        <Line
          type="monotone"
          dataKey={yKey}
          stroke={theme.palette.primary.main}
          strokeWidth={2}
          dot={false}
        />
        {yKey2 ? (
          <Line
            type="monotone"
            dataKey={yKey2}
            stroke={theme.palette.grey[900]}
            strokeWidth={2}
            dot={false}
          />
        ) : null}
      </LineChart>
    </ResponsiveContainer>
  );
}
