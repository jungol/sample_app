class UsersController < ApplicationController
  before_action :signed_in_user,  only: [:edit, :update, :index, :destroy, 
                                         :following, :followers ]
  before_action :correct_user,    only: [:edit, :update         ]
  before_action :admin_user,      only: [:destroy               ]
  before_action :signed_out_user, only: [:new, :create          ]

  def index
    @users = User.paginate(page: params[:page])
  end
  
  def new
    @user ||= User.new
  end
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      @user.send_account_confirmation
      flash[:success] = "Welcome to the Sample App"
      flash[:notice] = "Check your email"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updates"
      redirect_to @user
    else
      render 'edit'
    end
  end
      
  def destroy
    @user = User.find(params[:id])
    if current_user?(@user)
      flash[:error] = "You can't delete yourself."
    else
      @user.destroy
      flash[:success] = "User deleted."
    end
    redirect_to users_url
  end
  
  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end
  
  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
    
    def signed_out_user
      unless !signed_in?
        redirect_to root_url, notice: "You're already signed in!"
      end
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end