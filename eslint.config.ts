import js from "@eslint/js";
import globals from "globals";
import tseslint from "typescript-eslint";
import { defineConfig } from "eslint/config";

export default defineConfig([
  {
    ignores: [
      "dist/**",
      "node_modules/**",
      "**/*.d.ts",
      "**/*.d.ts.map",
      "eslint.config.ts",
    ],
  },
  {
    files: ["src/**/*.{js,mjs,cjs,ts,mts,cts}"],
    languageOptions: { globals: globals.node },
    // ... rest of config
  },
  tseslint.configs.recommended,
]);
