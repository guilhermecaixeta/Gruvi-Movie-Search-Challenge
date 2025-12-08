import tailwindcss from '@tailwindcss/vite';
import { defineConfig, loadEnv } from 'vite';
import { svelte } from '@sveltejs/vite-plugin-svelte';



// https://vite.dev/config/
export default defineConfig(({ mode }) => {
    const env = loadEnv(mode, process.cwd());
    return {
        plugins: [tailwindcss(), svelte()],
        server: {
            port: Number(env.VITE_PORT) || 80,
            strictPort: true,
            host: env.VITE_HOST || 'localhost'
        },
    }
});
