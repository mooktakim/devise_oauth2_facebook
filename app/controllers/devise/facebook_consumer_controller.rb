class Devise::FacebookConsumerController < ApplicationController
  include Devise::Controllers::InternalHelpers
  include DeviseOauth2Facebook::FacebookConsumerHelper
  include DeviseOauth2Facebook::ControllerMethods
end
