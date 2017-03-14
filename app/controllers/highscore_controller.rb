class HighscoreController < ApplicationController

  def update
    highscore = params[:id].to_i
    category_id = params[:category_id]

    user_category = UserCategory.where(user_id: current_user.id, category_id: category_id)
    # debugger

    if user_category[0].highscore <= highscore
      user_category[0].update(highscore: highscore)
    end
  end

end
