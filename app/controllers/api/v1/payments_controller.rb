module Api
  module V1
    class PaymentsController < ApplicationController
      before_action :authenticate_user!

      def create

      end
    end
  end
end
