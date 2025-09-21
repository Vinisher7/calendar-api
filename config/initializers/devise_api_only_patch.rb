# config/initializers/devise_api_only_patch.rb
module Devise::Controllers::SignInOut
  def bypass_sign_in(resource, scope: nil, store: true)
    scope ||= Devise::Mapping.find_scope!(resource)
    store = false if Rails.application.config.api_only # Force store: false in API-only mode
    warden.set_user(resource, scope: scope, store: store)
  end
end
