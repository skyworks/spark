class PageController < ApplicationController

  before_filter :login_verify
  skip_before_filter :verify_authenticity_token

  def index
  end

  def settings

    if is_logined and params[:nickname] != nil
      @current_user.nickname = params[:nickname]
      @current_user.save       
    end

    if is_logined and params[:old_password] != nil and params[:new_password] != nil and params[:new_password] == params[:confirm_password]
      if @current_user.check_password(Digest::MD5.hexdigest(params[:old_password]))
        new_password = Digest::MD5.hexdigest(params[:new_password])
        @current_user.password = Digest::SHA1.hexdigest("#{@current_user.salt}--#{new_password}")
        @current_user.save     
      end
    end

    @title = I18n.t('Setting')
  end

  def about
  end

  def ideas
    @ideas = Idea.all
  end
  
  def idea
    @idea = Idea.find(params[:idea_id])

    if is_logined and params[:comment] != nil
      comment = Comment.new
      comment.user_id = @current_user.id
      comment.idea_id = @idea.id
      comment.content = params[:comment]
      comment.save
    end

    @comments = Comment.joins([:user]).select("users.nickname, comments.content, comments.updated_at").find(:all, :conditions => { :idea_id => @idea.id })
  end

  def create_idea
    if is_logined and params[:title] != nil and params[:description] != nil
      idea = Idea.new
      idea.user_id = @current_user.id
      idea.title = params[:title]
      idea.description = params[:description]
      idea.save

      redirect_to ideas_path
    end
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
