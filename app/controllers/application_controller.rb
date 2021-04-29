class ApplicationController < ActionController::API
  include ::ActionController::Cookies
  helper_method :choose_model, :log_in, :remember,
                :forget, :current_user, :current_user?

  def choose_model(model_name)
    case model_name
    when 'SuperUser'
      model = Admin
    else
      return nil
    end

    [model_name, model]
  end


  def current_user
    if session[:user_id]
      if (model_name = session[:model_name])
        _, model = choose_model(model_name)

        return [@current_user ||= model.find_by(id: session[:user_id]),
                model_name]
      end
    elsif (user_id = cookies.signed[:user_id])
      if (model_name = cookies[:model_name])
        _, model = choose_model(model_name)
        user = model.find_by(id: user_id)
        if user && user.authenticated?(cookies[:remember_token])
          log_in(user, model_name)
          return [@current_user = user, model_name]
        end
      end
    end
  end

  def log_in(user, model_name)
    session[:user_id] = user.id
    session[:model_name] = model_name

  end

  def remember(user, model_name)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
    cookies.permanent[:model_name] = model_name
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
    cookies.delete(:model_name)
  end

  def current_user?(user, model_name)
    person = current_user
    if person.nil?
      return false
    else
      user == current_user[0] && model_name == current_user[1]
    end
  end

end
