import { defineConfig } from "tsup";

export default defineConfig({
  entry: {
    main: "./electron/src/main.ts",
    preload: "./electron/src/preload.ts"
  },
  splitting: false,
  sourcemap: false,
  clean: true,
  cjsInterop: true,
  skipNodeModulesBundle: true,
  treeshake: true,
  outDir: "build", 
  external: ["electron"], 
  format: ["cjs"], 
  bundle: true,
});