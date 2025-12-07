<script lang="ts">
  import type { Movie } from "../interfaces/Movie";
  import { MovieService } from "../services/MovieService";
  import type { MovieSearchResponse } from "../interfaces/MovieSearchResponse";

  let startDate: string = "";
  let endDate: string = "";
  let errors: Record<string, string> = {};

  let currentPage = $state(1);
  let rowsPerPage = $state(20);

  let totalPages = $state(0);
  let startIdx = $derived((currentPage - 1) * rowsPerPage);
  let endIdx = $derived(startIdx + rowsPerPage);
  let paginatedData: Movie[] = $derived([]);

  function validateForm() {
    errors = {};
    if (!startDate) errors.startDate = "Start date is required";
    if (!endDate) errors.endDate = "End date is required";

    if (startDate && endDate && new Date(startDate) > new Date(endDate)) {
      errors.endDate = "End date must be after start date";
    }
    return Object.keys(errors).length === 0;
  }

  async function handleSubmit() {
    if (validateForm()) {
      await getMoviesData();
    }
  }

  async function goToPage(page: number) {
    if (page >= 1 && page <= totalPages) {
      currentPage = page;
      await getMoviesData();
    }
  }

  async function getMoviesData() {
    const service = new MovieService(
      "http://localhost:3000/api/v1/movie/search",
    );
    const moviesData = await service.getByRange(
      new Date(startDate),
      new Date(endDate),
      currentPage,
    );

    totalPages = moviesData.total_pages;
    paginatedData = moviesData.data;
  }
</script>

<main class="p-8 max-w-6xl mx-auto">
  <h2 class="text-3xl font-bold mb-8">Filter Movies by Range</h2>

  <form
    on:submit|preventDefault={handleSubmit}
    class="mb-8 p-6 bg-white shadow-md rounded-lg"
  >
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <div>
        <label
          for="startDate"
          class="block text-sm font-medium text-gray-700 mb-2"
        >
          Start Date *
        </label>
        <input
          id="startDate"
          type="date"
          bind:value={startDate}
          required
          class="date-input w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 text-black
          {errors.startDate ? 'border-red-500' : ''}"
        />
        {#if errors.startDate}
          <p class="mt-1 text-sm text-red-600">{errors.startDate}</p>
        {/if}
      </div>

      <div>
        <label
          for="endDate"
          class="block text-sm font-medium text-gray-700 mb-2"
        >
          End Date *
        </label>
        <input
          id="endDate"
          type="date"
          bind:value={endDate}
          required
          class="date-input w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 text-black decoration-inherit {errors.endDate
            ? 'border-red-500'
            : ''}"
        />
        {#if errors.endDate}
          <p class="mt-1 text-sm text-red-600">{errors.endDate}</p>
        {/if}
      </div>
    </div>

    <button
      type="submit"
      disabled={Object.keys(errors).length > 0}
      class="mt-6 w-full bg-blue-600 text-white py-2 px-4 rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 disabled:opacity-50 disabled:cursor-not-allowed"
    >
      Filter Table
    </button>
  </form>

  <div class="bg-white shadow-md rounded-lg overflow-hidden">
    <div class="overflow-x-auto">
      <table class="min-w-full divide-y divide-gray-200">
        <thead class="bg-gray-50">
          <tr>
            <th
              class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
              >ID</th
            >
            <th
              class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
              >Title</th
            >
            <th
              class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
              >Description</th
            >
            <th
              class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider"
              >Release Date</th
            >
          </tr>
        </thead>
        <tbody class="bg-white divide-y divide-gray-200">
          {#each paginatedData as item (item?.id)}
            <tr class="hover:bg-gray-50">
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900"
                >{item.id}</td
              >
              <td
                class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900"
                >{item.title}</td
              >
              <td class="px-6 py-4 text-sm text-gray-500 text-left text-wrap"
                >{item.description}</td
              >
              <td
                class="px-6 py-4 whitespace-nowrap text-sm text-gray-900 text-right"
                >{item.release_date}</td
              >
            </tr>
          {/each}
        </tbody>
      </table>
    </div>

    <!-- Pagination -->
    <div class="px-6 py-4 bg-gray-50 flex items-center justify-between">
      <div class="flex-1 flex justify-between sm:hidden">
        <button
          on:click={() => goToPage(currentPage - 1)}
          disabled={currentPage === 1}
          class="relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 disabled:opacity-50"
        >
          Previous
        </button>
        <button
          on:click={() => goToPage(currentPage + 1)}
          disabled={currentPage === totalPages}
          class="ml-3 relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 disabled:opacity-50"
        >
          Next
        </button>
      </div>

      <div class="hidden sm:flex-1 sm:flex sm:items-center sm:justify-between">
        <div class="flex items-center text-sm text-gray-700">
          <p>
            Showing <span class="font-medium">{startIdx + 1}</span> to
            <span class="font-medium"
              >{Math.min(endIdx, paginatedData.length)}</span
            >
            of <span class="font-medium">{paginatedData.length}</span> results
          </p>
        </div>

        <div>
          <nav
            class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px"
          >
            <button
              on:click={() => goToPage(1)}
              disabled={currentPage === 1}
              class="relative inline-flex items-center px-2 py-2 rounded-l-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50 disabled:opacity-50"
            >
              <span>First</span>
            </button>

            <button
              on:click={() => goToPage(currentPage - 1)}
              disabled={currentPage === 1}
              class="relative inline-flex items-center px-3 py-2 border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50 disabled:opacity-50"
            >
              <span>Previous</span>
            </button>

            <button
              class="z-10 relative inline-flex items-center px-4 py-2 border border-gray-300 bg-white text-sm font-medium text-gray-700"
            >
              Page <span class="font-semibold">{currentPage}</span> of
              <span class="font-semibold">{totalPages}</span>
            </button>

            <button
              on:click={() => goToPage(currentPage + 1)}
              disabled={currentPage === totalPages}
              class="relative inline-flex items-center px-3 py-2 border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50 disabled:opacity-50"
            >
              <span>Next</span>
            </button>

            <button
              on:click={() => goToPage(totalPages)}
              disabled={currentPage === totalPages}
              class="relative inline-flex items-center px-2 py-2 rounded-r-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50 disabled:opacity-50"
            >
              <span>Last</span>
            </button>
          </nav>
        </div>
      </div>
    </div>
  </div>
</main>

<style>
  .date-input::-webkit-calendar-picker-indicator {
    filter: invert(0.5) sepia(1) saturate(2) hue-rotate(175deg); /* Blue arrow */
    cursor: pointer;
  }

  .date-input::-webkit-calendar-picker-indicator:hover {
    filter: invert(0.4) sepia(1) saturate(3) hue-rotate(175deg);
  }
</style>
