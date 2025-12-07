import type { Movie } from "./Movie";

export interface MovieSearchResponse {
    data: Movie[];
    page: number;
    total_pages: number;
    items_per_page: number;
}