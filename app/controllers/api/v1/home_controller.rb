module Api
  module V1
    class HomeController < ApplicationController
      before_action :authenticate_user!

      def index
        render json: { ok: 'ok' }
      end
    end
  end
end
