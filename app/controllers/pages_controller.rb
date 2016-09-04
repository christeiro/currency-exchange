# PagesController is a class for pages shown before user has logged in.
class PagesController < ApplicationController
  def front
    redirect_to exchanges_path if current_user
  end
end
