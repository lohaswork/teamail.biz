class UsersController < ApplicationController
  def new
  end

  def create
    @user = User.create_with_organization(params[:email], params[:password], params[:organization_name])
    redirect_to signup_success_path
  end

  def signup_success

  end
end
