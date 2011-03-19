class Devise::FacebookConsumerController < ApplicationController
  include Devise::Controllers::InternalHelpers
  include DeviseOauth2Facebook::FacebookConsumerHelper
  include DeviseOauth2Facebook::ControllerMethods

  def initialize
    # For some reason callback is not recognized as action_method automagically
    action_methods.add "callback"
  end
end
