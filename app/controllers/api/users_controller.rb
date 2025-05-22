class Api::UsersController < ApplicationController
  before_action :set_user, only: [:show]
  
  def index
    @pagy, @users = pagy(User.all)
    render json: {
      users: @users,
      pagination: {
        page: @pagy.page,
        items: @pagy.items,
        count: @pagy.count,
        pages: @pagy.pages
      }
    }, status: :ok
  end

  def show
    render json: @user, status: :ok
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :full_name, :role, :password, :password_confirmation)
  end
end