class HomeController < ApplicationController
  def index
    @form = KcalForm.new
  end
end
