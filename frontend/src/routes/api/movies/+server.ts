import { MovieService } from '$lib';
import { json, type RequestHandler } from '@sveltejs/kit';

export const GET: RequestHandler = async ({ request }) => {
    const { startDate, endDate, page } = Object.fromEntries(new URL(request.url).searchParams);
    const service = new MovieService();
    const movies = await service.getByRange(
        new Date(startDate),
        new Date(endDate),
        Number(page) || 1);

    return json(movies);
};