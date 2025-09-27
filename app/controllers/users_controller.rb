class UsersController < ApplicationController
  before_action :authenticate_user!

  def line_link
    token = SecureRandom.hex(10)
    current_user.update!(line_link_token: token)
    @user = current_user

    render :line_link_show
  end
end
