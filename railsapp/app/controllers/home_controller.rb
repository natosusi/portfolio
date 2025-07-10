class HomeController < ApplicationController
  skip_before_action :authenticate_user!
  layout 'top'
  def top
  end
end
