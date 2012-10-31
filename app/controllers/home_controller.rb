class HomeController < ApplicationController
  def index
  end

  def about
    @header = t("navbar.about")
  end

  def contact
    @header = t("navbar.contact")
  end
end
