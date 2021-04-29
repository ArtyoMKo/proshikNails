class SessionsController < ApplicationController
  include ActionController::Cookies
  include ActionController::RequestForgeryProtection

  def new
  end

  def create
    @model_name, @model = choose_model(params[:session][:model_name])
    @user = @model.find_by(phone_number: params[:session][:phone_number])
    user = @user
    model_name = @model_name
    if user && user.authenticate(params[:session][:password])
      log_in user, model_name
      params[:session][:remember_me] == '1' ? remember(user, model_name) : forget(user)
      render status: :ok
    else
      render status: :unprocessable_entity
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def user_in
    if logged_in?
      user_array = current_user
      @user_in = user_array[0]
      @model_name = user_array[1]
    else
      false
    end
  end

  def log_out
    user,_ = current_user
    forget(user)
    session.delete(:user_id)
    @current_user = nil
  end

  def destroy
    log_out if logged_in?
    render json: nil, status: :ok
  end

end
