import { defineConfig } from 'vite';
import { vitePlugin as remix } from "@remix-run/dev";
import UnoCSS from 'unocss/vite'

export default defineConfig({
  plugins: [
    UnoCSS(),
    remix({
      ignoredRouteFiles: ["**/*.css", "**/*.test.{js,jsx,ts,tsx}"],
      future: {
        unstable_optimizeDeps: true,
      },
    }),
  ],
  
  build: {
    // Critical memory optimizations
    sourcemap: false, // Eliminates major memory consumer
    cssCodeSplit: true,
    assetsInlineLimit: 0, // Prevent asset inlining
    target: 'esnext', // Reduce transpilation overhead
    
    rollupOptions: {
      cache: false, // Disable Rollup cache to save memory
      treeshake: 'smallest',
      
      // Externalize Node.js built-ins that cause issues
      external: [
        'fs', 'path', 'crypto', 'stream', 'child_process', 'react-router-dom'
      ],
      
      output: {
        manualChunks: {
          // Split major dependencies into separate chunks
          'react-vendor': ['react', 'react-dom'],
          'remix-vendor': ['@remix-run/react'],
          'webcontainer-vendor': ['@webcontainer/api'],
        },
      },
    },
  },
  
  optimizeDeps: {
    include: ['react', 'react-dom', '@remix-run/react', 'react-router-dom'],
    entries: ["./app/entry-client.tsx", "./app/root.tsx"],
  },
  
  // Enable nodejs compatibility flag for Cloudflare
  define: {
    global: 'globalThis',
  },
  resolve: {
    alias: {
      "~": "/workspaces/bolt.diy-cloudflare/app",
    },
  },
});
