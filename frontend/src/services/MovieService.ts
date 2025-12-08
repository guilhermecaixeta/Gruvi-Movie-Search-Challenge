import type { MovieSearchResponse } from "../interfaces/MovieSearchResponse";

export class MovieService {
    private urlBase: string;

    constructor() {
        this.urlBase = `${import.meta.env.VITE_API_URL}/v1/movie/search`;
    }

    public async getByRange(startDate: Date, endDate: Date, page: number): Promise<MovieSearchResponse> {
        const params = new URLSearchParams();
        params.append("start_date", startDate.toDateString());
        params.append("end_date", endDate.toDateString());
        params.append("page", page.toString());

        const response = await fetch(`${this.urlBase}?${params.toString()}`);

        return await response.json() as MovieSearchResponse;
    }

}