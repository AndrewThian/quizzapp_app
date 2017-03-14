task :seed_from_opentdb => :environment do
  require 'rubygems'
  require 'httparty'
  require 'json'

  @OPENTDB_API_TOKEN = ''
  @OPENTB_API_CALL = 'https://opentdb.com/api.php?amount=50&type=multiple&token=' + @OPENTDB_API_TOKEN
  @OPENTB_API_TOKEN_RESET = 'https://opentdb.com/api_token.php?command=reset&token=' + @OPENTDB_API_TOKEN

  def create_category_in_cat_table(results)
    categories = Category.pluck(:name)

    if categories
      puts ("All categories are: #{categories}")
    else
      puts ("Category table empty!!")
    end
    # temp arr to hold current 50 API results
    temp_category_arr = []
    # loop through api_results
    results.each do |result_hash|
      # each category in result
      result_category = result_hash['category']
      puts "Current category is #{result_category}"
      # push result category into temp array
      temp_category_arr << result_category
      puts "Pushed #{result_category} in temp array!"
    end
    # looping through 50 records unique array
    temp_category_arr.uniq.each do |response_category|
      # checking if they are in the table (.include?)
      # categories.include? 'string' would return false if not in array
      unless categories.include? response_category
        case response_category
        when "Animals"
          Category.create(name: response_category, icon_source: 'animals.png')
          puts "#{response_category} created.."
        when "Art"
          Category.create(name: response_category, icon_source: 'art.png')
          puts "#{response_category} created.."
        when "Celebrities"
          Category.create(name: response_category, icon_source: 'celebrities.png')
          puts "#{response_category} created.."
        when "Entertainment: Film"
          Category.create(name: response_category, icon_source: 'film.png')
          puts "#{response_category} created.."
        when "Entertainment: Video Games"
          Category.create(name: response_category, icon_source: 'video_games.png')
          puts "#{response_category} created.."
        when "Entertainment: Books"
          Category.create(name: response_category, icon_source: 'books.png')
          puts "#{response_category} created.."
        when "Entertainment: Board Games"
          Category.create(name: response_category, icon_source: 'board_games.png')
          puts "#{response_category} created.."
        when "Entertainment: Cartoon & Animations"
          Category.create(name: response_category, icon_source: 'cartoon.png')
          puts "#{response_category} created.."
        when "Entertainment: Comics"
          Category.create(name: response_category, icon_source: 'comics.png')
          puts "#{response_category} created.."
        when "Entertainment: Musicals & Theatres"
          Category.create(name: response_category, icon_source: 'musicals.png')
          puts "#{response_category} created.."
        when "Entertainment: Television"
          Category.create(name: response_category, icon_source: 'television.png')
          puts "#{response_category} created.."
        when "Entertainment: Japanese Anime & Manga"
          Category.create(name: response_category, icon_source: 'anime.png')
          puts "#{response_category} created.."
        when "Entertainment: Music"
          Category.create(name: response_category, icon_source: 'music.png')
          puts "#{response_category} created.."
        when "General Knowledge"
          Category.create(name: response_category, icon_source: 'general_knowledge.png')
          puts "#{response_category} created.."
        when "Geography"
          Category.create(name: response_category, icon_source: 'geography.png')
          puts "#{response_category} created.."
        when "History"
          Category.create(name: response_category, icon_source: 'history.png')
          puts "#{response_category} created.."
        when "Mythology"
          Category.create(name: response_category, icon_source: 'mythology.png')
          puts "#{response_category} created.."
        when "Politics"
          Category.create(name: response_category, icon_source: 'politics.png')
          puts "#{response_category} created.."
        when "Science & Nature"
          Category.create(name: response_category, icon_source: 'nature.png')
          puts "#{response_category} created.."
        when "Science: Computers"
          Category.create(name: response_category, icon_source: 'computers.png')
          puts "#{response_category} created.."
        when "Science: Gadgets"
          Category.create(name: response_category, icon_source: 'gadgets.png')
          puts "#{response_category} created.."
        when "Science: Mathematics"
          Category.create(name: response_category, icon_source: 'mathematics.png')
          puts "#{response_category} created.."
        when "Sports"
          Category.create(name: response_category, icon_source: 'sports.png')
          puts "#{response_category} created.."
        when "Vehicles"
          Category.create(name: response_category, icon_source: 'vehicles.png')
          puts "#{response_category} created.."
        end
      end
    end
  end

  def add_questions_to_database(results)
    results.each do |result_hash|
      result_category = result_hash['category']

      database_category = Category.find_by(name: result_category)

      question = Question.new do |q|
        q.category_name = result_hash['category']
        q.question_type = result_hash['type']
        q.difficulty = result_hash['difficulty']
        q.question = result_hash['question']
        q.correct_answer = result_hash['correct_answer']
        q.incorrect_answers = result_hash['incorrect_answers']
        q.category_id = database_category.id
        case result_hash['difficulty']
        # if difficulty = easy || medium || hard
        # insert exp based on switch case
        when "easy"
          q.exp = 10
        when "medium"
          q.exp = 20
        when "hard"
          q.exp = 30
        end
      end
      question.save
    end
  end

  def api_database_call
    puts @OPENTB_API_CALL

    # get api key
    API_KEY_REQUEST = HTTParty.get('https://opentdb.com/api_token.php?command=request')
    @OPENTDB_API_TOKEN = API_KEY_REQUEST.token

    # reset API token
    HTTParty.get(@OPENTB_API_TOKEN_RESET)
    puts "Resetting api token.."

    @total_questions = 2215
    @current_count = 0

    while @current_count < @total_questions do
      puts ("Requesting API with #{@OPENTB_API_CALL}")

      puts "Running API call.."
      response = HTTParty.get(@OPENTB_API_CALL)
      puts ("returned response_code of call is #{response['response_code']}")

      if response['response_code'] != 0
        puts 'ERROR!! Returned response code is not 0!! Breaking out of method..'
        return
      end

      puts "Adding current 50 questions to Question table!!"
      create_category_in_cat_table(response['results'])

      add_questions_to_database(response['results'])

      returned_res_length = response['results'].length
      puts ("response result length = #{returned_res_length}")

      @current_count += returned_res_length
      puts ("Added number of questions to current_count..")
      puts ("Amount of questions recieved = #{@current_count}")

      puts "Waiting 1 second before making next call.."
      sleep(1)
    end
  end

  api_database_call()
end
