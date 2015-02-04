class Admin::UsersController < ApplicationController

  before_filter :restrict_access
  before_filter :restrict_normal_users
  before_filter :authenticate

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to movies_path, notice: "Welcome aboard, #{@user.firstname}!"
    else
      render :new
    end
  end

  def show
    @users = User.page(params[:page])
    render :show
  end 


  def edit
    @user = User.find(params[:id])  
  end


  def update
    @user = User.find(params[:id])
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    if @user.update_attributes(user_params)
      redirect_to admin_user_path(@current_user)
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to movies_path
  end

  protected

  def user_params
    params.require(:user).permit(:email, :firstname, :lastname, 
      :password, :password_confirmation, :admin)
  end



end