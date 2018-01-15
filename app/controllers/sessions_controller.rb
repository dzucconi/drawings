class SessionsController < ApplicationController
  before_action :require_admin!, except: [:new, :create]

  def new
    @admin = Admin.new
  end

  def create
    @admin = Admin.new
    @admin.username = admin_params[:username]
    @admin.password = admin_params[:password]

    if @admin.login_valid?
      session[:current_user] = true
      redirect_to :root
    else
      @admin.password = nil
      flash[:notice] = 'Incorrect password'
      render 'new'
    end
  end

  def destroy
    reset_session
    redirect_to root_path
  end

  private

  def admin_params
    params.require(:admin)
  end
end
