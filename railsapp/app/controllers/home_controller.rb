class HomeController < ApplicationController
  skip_before_action :authenticate_user!
  layout 'top'
  def top
    if user_signed_in?
      redirect_to books_path
    end
  end
end
