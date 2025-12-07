# frozen_string_literal: true
# typed: true

# Rescue module
module RescueConcern
  extend ActiveSupport::Concern

  included do
    rescue_from Errors::DomainErrors::InvalidDataError do |e|
      Rails.logger.error(e)

      render json: { reason: e.message }, status: :unprocessable_entity
    end

    rescue_from Errors::DomainErrors::InternalError do |e|
      Rails.logger.error(e)

      render json: { reason: e.message }, status: :internal_server_error
    end

    rescue_from Errors::HttpClientErrors::BaseHttpClientError do |e|
      Rails.logger.error(e)

      render json: { reason: e.message }, status: e.status_code
    end
  end
end
