class PagesController < ApplicationController
  def front
    redirect_to exchanges_path if current_user
  end
end
