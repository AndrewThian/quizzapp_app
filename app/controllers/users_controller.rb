class UsersController < ApplicationController
  # find and set user for edit, show and update methods
  before_action :set_user, only: [:edit, :show, :update]

  def new
    @user = User.new
  end

  # /users/:id(.:format)
  def show
    # @user_category = user categories belonging to current user
    # @user_category limit 5 = user categories belonging to current user
    # current_user_categories_id = array of @user_category ids
    # @all_completed_qns_by_user = array of all completed questions by user

    if current_user
      @user_category = UserCategory.where(user_id: current_user.id).order(category_exp: :desc)
      @user_category_5 = UserCategory.where(user_id: current_user.id).limit(5)
      # debugger
      @exp_sum = @user_category.sum(:category_exp)
      current_user_categories_id = @user_category.pluck(:id)
      @all_questions= Question.all
      @all_completed_qns_by_user = CompletedQuestion.where(user_category_id: current_user_categories_id)
    end

    respond_to do |format|
      format.html
      format.json {render :json => @user_category_5.to_json(:include => :category)}
    end
  end

  def edit
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash.now[:success] = 'Welcome! Sign up completed'
      redirect_to login_path
    else
      flash.now[:danger] = 'Error on registration, please try again!'
      redirect_to root_path
    end
  end

  #PATCH REQUEST
  def update
    # update user details with user_params
    @user.update(user_params)

    if @user
      flash.now[:success] = 'Successfully updated user profile'
      # redirect to profile page after updated!
      redirect_to user_path(@user.id)
    else
      flash.now[:danger] = 'Woops, something went wrong while updating your profile!'
      # redirect to profile page if error
      redirect_to user_path(@user.id)
    end
  end

  private

  def set_user
    @user = User.find_by_id(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :password,
      :phone,
      :address,
      :profile_picture
    )
  end
end
