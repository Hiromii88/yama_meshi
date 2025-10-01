class UsersController < ApplicationController
  before_action :authenticate_user!

  def line_link
    @user = current_user
    @user.update_columns(line_link_token: SecureRandom.hex(6))
  end
end
