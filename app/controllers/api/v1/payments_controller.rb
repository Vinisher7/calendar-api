module Api
  module V1
    class PaymentsController < ApplicationController
      before_action :authorize_user!
    end
  end
end
