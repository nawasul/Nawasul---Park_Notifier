"use client";

import { createTheme } from "@mui/material/styles";

/**
 * Nawasul admin MUI theme — mapped from mobileapp/docs/design.json.
 * Use theme.palette / theme.spacing only; do not hardcode hex in components.
 */
export const nawasulTheme = createTheme({
  palette: {
    mode: "light",
    primary: {
      main: "#F2572B",
      contrastText: "#FFFFFF",
      light: "#FFE8E2",
      dark: "#D14520",
    },
    secondary: {
      main: "#4D4D4D",
      contrastText: "#FFFFFF",
      light: "#ECECEC",
    },
    background: {
      default: "#DEDEDE",
      paper: "#FFFFFF",
    },
    text: {
      primary: "#171717",
      secondary: "#4D4D4D",
      disabled: "#4D4D4D",
    },
    success: {
      main: "#1B7A52",
      light: "#DCF3E9",
      contrastText: "#FFFFFF",
    },
    warning: {
      main: "#C45A00",
      light: "#FFE8CC",
      contrastText: "#FFFFFF",
    },
    error: {
      main: "#C62828",
      light: "#FBE9E7",
      contrastText: "#FFFFFF",
    },
    divider: "#CFCFCF",
    grey: {
      100: "#ECECEC",
      200: "#D4D4D4",
      300: "#CFCFCF",
      400: "#DEDEDE",
      500: "#4D4D4D",
      900: "#171717",
    },
  },
  typography: {
    fontFamily: "var(--font-poppins), 'Poppins', sans-serif",
    h1: { fontSize: 24, fontWeight: 600, letterSpacing: "-0.4px", lineHeight: 1.25 },
    h2: { fontSize: 19, fontWeight: 600, letterSpacing: "-0.2px", lineHeight: 1.3 },
    h3: { fontSize: 16, fontWeight: 600, lineHeight: 1.4 },
    body1: { fontSize: 14, fontWeight: 400, lineHeight: 1.5 },
    body2: { fontSize: 12, fontWeight: 400, lineHeight: 1.4 },
    button: { fontSize: 14, fontWeight: 600, letterSpacing: "0.1px", textTransform: "none" },
    caption: { fontSize: 12, fontWeight: 500, letterSpacing: "0.2px", lineHeight: 1.4 },
  },
  shape: {
    borderRadius: 12,
  },
  spacing: 8,
  components: {
    MuiButton: {
      defaultProps: { disableElevation: true },
      styleOverrides: {
        root: {
          borderRadius: 16,
          paddingInline: 16,
          paddingBlock: 8,
        },
        contained: {
          "&.MuiButton-colorPrimary": {
            boxShadow: "0 6px 16px rgba(242, 87, 43, 0.18)",
          },
        },
      },
    },
    MuiCard: {
      styleOverrides: {
        root: {
          borderRadius: 20,
          boxShadow: "0 8px 24px rgba(23, 23, 23, 0.07)",
        },
      },
    },
    MuiPaper: {
      styleOverrides: {
        root: {
          backgroundImage: "none",
        },
      },
    },
    MuiChip: {
      styleOverrides: {
        root: {
          fontWeight: 500,
        },
      },
    },
    MuiTextField: {
      defaultProps: {
        variant: "outlined",
        size: "small",
      },
    },
    MuiCssBaseline: {
      styleOverrides: {
        body: {
          backgroundColor: "#DEDEDE",
        },
      },
    },
  },
});

export type NawasulTheme = typeof nawasulTheme;
