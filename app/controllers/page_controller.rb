class PageController < ApplicationController

  before_filter :login_verify
  skip_before_filter :verify_authenticity_token

  def index
  end

  def settings
  end
  
  def about
  end

  def ideas
  end

  def login                    
    @login_fail = false        
    if params[:email] != nil and params[:password] != nil
      password = Digest::MD5.hexdigest(params[:password])
      user = User.login(params[:email], password)
      if user != nil           
        session[:user_id] = user.id     
        session[:last_seen] = Time.now  

        redirect_to root_path  
      else                     
        @login_fail = true     
      end
    end

    @title = I18n.t('Login')
  end

  def logout
    reset_session
    redirect_to root_path
  end

  def register
    @register_fail = false
    if params[:email] != nil and params[:password] != nil
      password = Digest::MD5.hexdigest(params[:password])
      if User.register(params[:email], password)
        user = User.where("email = ?", params[:email].downcase).first
        if params[:nickname] != nil and params[:nickname].length > 0
          user.nickname = params[:nickname]
        else
          user.nickname = user.email
        end
        user.save

        redirect_to login_path
      else
        @register_fail = true
      end
    end

    @title = I18n.t('Register')
  end
end
