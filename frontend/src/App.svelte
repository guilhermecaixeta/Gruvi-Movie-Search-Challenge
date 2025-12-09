<script>
  import "./app.css";
  import MovieSearch from "./lib/MovieSearch.svelte";

  // Client-side only (prefixed with VITE_)
  const apiUrl = import.meta.env.VITE_API_URL;
  const appName = import.meta.env.VITE_APP_NAME;
  const isDebug = import.meta.env.VITE_DEBUG === "true";
</script>

<main>
  <div class="grid-cols-12 grid-rows-12 min-h-screen p-8">
    <div class="col-span-full mb-4">
      <!-- svelte-ignore a11y_invalid_attribute -->
      <a href="#" target="_blank" rel="noreferrer">
        <img
          src="https://gruvi.tv/wp-content/uploads/logo-1.svg"
          class="logo svelte"
          alt="Svelte Logo"
        />
      </a>
    </div>
    <h1>{appName}</h1>
    {#if import.meta.env.DEV}
      <h2 class="text-red-600">Development Mode</h2>
      <h2>API URL: {apiUrl}</h2>
      <h2>Debug Mode: {isDebug ? "Enabled" : "Disabled"}</h2>
    {/if}

    <div class="card">
      <MovieSearch />
    </div>
  </div>
</main>

<style>
  .logo {
    height: 6em;
    padding: 1.5em;
    will-change: filter;
    transition: filter 300ms;
  }
  .logo:hover {
    filter: drop-shadow(0 0 2em #646cffaa);
  }
  .logo.svelte:hover {
    filter: drop-shadow(0 0 2em #ff3e00aa);
  }
</style>
