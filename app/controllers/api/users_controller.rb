class Api::UsersController < ApplicationController
  before_action :set_user, only: [:show]
  
  def index
    pagy, users = pagy(user_service.list_users, page: params[:page])
    render json: {
      users: users,
      pagination: {
        page: pagy.page,
        items: pagy.items,
        count: pagy.count,
        pages: pagy.pages
      }
    }, status: :ok
  end

  def show
    render json: @user, status: :ok
  end

  def create
    @user = user_service.create_user(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = user_service.find_user(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :full_name, :role, :password, :password_confirmation)
  end

  def user_service
    @user_service ||= UserService.new
  end
end