class QuestionsController < ApplicationController
  # before_action :js_only, except: [:index]

  def index
    # find if user_category_id already exist
    # user_category = current_category user is at
    category_id = params[:category_id]
    user_category = UserCategory.find_by(user_id: current_user[:id], category_id: category_id)

    @category = Category.find_by(id: category_id)
    # @questions = @category.questions.order("RANDOM()").limit(10)

    # find questions completed by user and retrieve their id in an array
    completed_questions_ids = CompletedQuestion.where(user_category_id: user_category.id).pluck(:question_id)
    # filter out user_category specific questions from query
    questions_filter_completed = Category.find_by(id: category_id).questions.where.not(id: completed_questions_ids)
    # randomize and limit to 10 questions from database
    @questions = questions_filter_completed.order("RANDOM()")

    respond_to do |format|
      format.html
      format.json {render json: {
        category: @category,
        questions: @questions
      }}
    end
  end

  def show
  end

  # update adds the completed question to the database
  def update
    question_id = params[:id]
    category_id = params[:category_id]

    @completed_qn = Question.find_by(id: question_id)
    @user_category = UserCategory.find_by(user_id: current_user.id, category_id: category_id)

    # create completed question
    CompletedQuestion.create(user_category_id: @user_category.id, question_id: @completed_qn.id)
    # add exp to user_category table
    if @user_category.increment!(:category_exp, by = @completed_qn.exp)
      respond_to do |format|
        # format.html {redirect_to category_questions_path(category_id), notice: 'Right answer!'}
        format.json {render json: {
          user_category: @user_category,
          completed_qn: @completed_qn
        }}
      end
    else
      respond_to do |format|
        # format.html {redirect_to category_questions_path(category_id), notice: 'Error in submitting answer'}
        format.json {render json: {
          errors: @user_category.errors.full_messages
        }}
      end
    end
  end

  private

  def question_params
    params.require(:question).permit(
      :question_id
    )
  end

  def js_only
    if request.format == 'html'
      puts request.format
      redirect_to stuffs_url, notice: 'JSON only'
    end
  end
end
