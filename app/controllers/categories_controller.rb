class CategoriesController < ApplicationController

  def index
    @category = Category.new
    @categories = Category.order('categories.name ASC').all

    respond_to do |format|
      format.html
      format.json {render json: @categories}
    end
  end

  def show
    category_id = params[:id]

    # find if user_category_id already exist
    # user_category = current_category user is at
    user_category = UserCategory.find_by(user_id: current_user[:id], category_id: category_id)
    if user_category == nil
      # create if user_category doesn't exist
      user_category = UserCategory.create(user_id: current_user[:id], category_id: category_id)
    end

    @category = Category.find_by(id: category_id)
    @highscores = UserCategory.order('user_categories.category_exp DESC').where(category_id: category_id)
    # number of questions user completed
    completed_qns = CompletedQuestion.where(user_category_id: user_category.id)
    if completed_qns.empty?
      @completed_qns = []
    else
      @completed_qns = completed_qns
    end
    @user_details = user_category
    @questions = @category.questions.length

    respond_to do |format|
      format.html
      format.json {render json: {
        category: @category,
        highscores: @highscores,
        questions: @questions,
        user_details: @user_details,
        completed_qns: @completed_qns
      }}
    end
  end
end
