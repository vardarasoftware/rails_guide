class Admin::BaseController < ApplicationController
    http_basic_authenticate_with name: "Arthur", password: "42424242"
end
