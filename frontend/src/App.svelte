<script>
  import "./app.css";
  import MovieSearch from "./lib/MovieSearch.svelte";
</script>

<main>
  <div>
    <!-- svelte-ignore a11y_invalid_attribute -->
    <a href="#" target="_blank" rel="noreferrer">
      <img
        src="https://gruvi.tv/wp-content/uploads/logo-1.svg"
        class="logo svelte"
        alt="Svelte Logo"
      />
    </a>
  </div>
  <h1>Gruvi.tv Movie Search</h1>

  <div class="card">
    <MovieSearch />
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
  .read-the-docs {
    color: #888;
  }
</style>
