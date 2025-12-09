import type { MovieSearchResponse } from "../interfaces/MovieSearchResponse";

export class MovieService {
    private urlBase: string;

    constructor() {
        this.urlBase = `${process.env.BASE_BACKEND_API_URL}/v1/movie/search`;
    }

    public async getByRange(startDate: Date, endDate: Date, page: number): Promise<MovieSearchResponse> {
        const params = new URLSearchParams();
        params.append("start_date", startDate.toDateString());
        params.append("end_date", endDate.toDateString());
        params.append("page", page.toString());

        console.info(`Fetching movies from ${this.urlBase} with params: ${params.toString()}`);
        try {
            const response = await fetch(`${this.urlBase}?${params.toString()}`, {
                method: 'GET',
                headers: {
                    'Content-Type': 'application/json'
                }
            });

            console.info(`Received response with status: ${response.status}`);
            return await response.json() as MovieSearchResponse;
        } catch (error) {
            console.error('Error fetching movies:', error);
            throw error;
        }
    }

}