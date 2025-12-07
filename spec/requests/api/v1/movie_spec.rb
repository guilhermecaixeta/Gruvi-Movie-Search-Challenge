require 'swagger_helper'

RSpec.describe 'Movie API', type: :request do
  path '/api/v1/movie/search' do
    get 'Search for movies in range' do
      produces 'application/json'
      parameter name: :start_date, in: :query, type: :string, required: true
      parameter name: :end_date, in: :query, type: :string, required: true
      parameter name: :page, in: :query, type: :integer, required: false

      response '200', 'movies found' do
        schema type: :object,
                  properties: {
                    data: {
                      type: :array,
                      items: {
                        type: :object,
                        properties: {
                          id: { type: :integer },
                          title: { type: :string },
                          release_date: { type: :string },
                          description: { type: :string }
                        },
                        required: [ 'id', 'title', 'release_date', 'description' ]
                      }
                    },
                    page: { type: :integer },
                    items_per_page: { type: :integer },
                    total_pages: { type: :integer }
                  },
                  required: [ 'results', 'page', 'items_per_page', 'total_pages' ]
        let!(:start_date) { '2023-01-01' }
        let!(:end_date) { '2023-01-31' }
        run_test!
      end
    end
  end
end
