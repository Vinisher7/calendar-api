module Api
  module V1
    class ObservationsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_observation!, only: [:create]

      def create
        result = Organizers::Observations::PerformCreatingObservation.call(
          observation: @observation,
          notification_params: {
            user_id: current_user.id,
            notification_type: :observation,
            description: 'Nova observação feita!',
          },
          data: @observation
        )

        unless result.success?
          return render json: { error: result.error, cause: result.cause }, status: :bad_request
        end

        render json: { data: result.response[:message] }, status: :created
      end

      def index
        @observations = Observation.all
      end

      private

      def set_observation!
        @observation = Observation.new(description: observation_params[:description],
                                       date: observation_params[:date], user_id: current_user.id)
      end

      def observation_params
        params.require(:observation).permit(:description, :date)
      end
    end
  end
end
