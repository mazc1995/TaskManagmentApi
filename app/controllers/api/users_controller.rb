class Api::UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    render json: @user
  end

  def create
    @user = User.create(user_params)
  end

  private

  def user_params
    params.require(:user).permit(:email, :full_name, :role)
  end
end