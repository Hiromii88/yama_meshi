class ApplicationController < ActionController::Base
  before_action :set_active_user

  private

  def set_active_user
    if current_user.present?
      @active_user = current_user
    elsif params[:line_user_id].present?
      @active_user = User.find_by(line_user_id: params[:line_user_id])
    end
  end
end
