class Admin::BaseController < ApplicationController
  http_basic_authenticate_with(
    name: Rails.application.credentials.dig(:basic_auth, :user),
    password: Rails.application.credentials.dig(:basic_auth, :password)
  )
end
