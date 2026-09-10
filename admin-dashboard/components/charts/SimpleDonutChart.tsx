"use client";

import { useTheme } from "@mui/material/styles";
import { Cell, Pie, PieChart, ResponsiveContainer, Tooltip } from "recharts";

type Slice = { name: string; value: number };

type SimpleDonutChartProps = {
  data: Slice[];
  height?: number;
};

export function SimpleDonutChart({ data, height = 220 }: SimpleDonutChartProps) {
  const theme = useTheme();
  const colors = [
    theme.palette.grey[500],
    theme.palette.primary.main,
    theme.palette.success.main,
  ];

  return (
    <ResponsiveContainer width="100%" height={height}>
      <PieChart>
        <Pie
          data={data}
          dataKey="value"
          nameKey="name"
          innerRadius={55}
          outerRadius={80}
          paddingAngle={3}
        >
          {data.map((_, i) => (
            <Cell key={data[i].name} fill={colors[i % colors.length]} />
          ))}
        </Pie>
        <Tooltip />
      </PieChart>
    </ResponsiveContainer>
  );
}
