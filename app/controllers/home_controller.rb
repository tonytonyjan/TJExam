class HomeController < ApplicationController
  def index
  end

  def about
    @header = "About"
  end

  def contact
    @header = "Contact"
  end
end
