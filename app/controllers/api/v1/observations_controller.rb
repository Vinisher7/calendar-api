module Api
  module V1
    class ObservationsController < ApplicationController
      def create
        @observation = Observation.new(observation_params)

        return if @observation.save

        render json: { error: @observation.errors.full_messages },
               status: :unprocessable_entity
      end

      def index
        @observations = Observation.all
      end

      private

      def observation_params
        params.require(:observation).permit(:description, :date_time)
      end
    end
  end
end
