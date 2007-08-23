
class HomeController < ApplicationController
  require_authentication(:except => [:index])
  def index
  end
end
