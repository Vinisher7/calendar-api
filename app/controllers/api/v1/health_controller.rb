module Api
  module V1
    class HealthController < ApplicationController
      def index
        render json: { data: 'up' }
      end
    end
  end
end
