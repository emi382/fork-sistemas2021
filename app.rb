require './models/init'
require './controllers/SurveyController'
require './controllers/CareerController'
require './controllers/QuestionController'
require './controllers/OutcomeController'

# This is the main class which determines the behavior of every path in our website
class App < Sinatra::Base
  configure do
    set :public_folder, File.expand_path('../public', 'style.css')
    set :views, File.expand_path('../views', 'style.css')
    set :root, File.dirname('../css/style.css')
  end

  use SurveyController
  use CareerController
  use QuestionController
  use OutcomeController

  it1 = 0
  it2 = 1

  # homepage
  get '/' do
    erb :landing
  end

  # starts the test by setting the iterators to their default values and passing the first two questions
  # WARNING: at least 2 questions needed for the test to work, and at least one outcome per question
  get '/start' do
    if Question.first_two
      it1 = 0
      it2 = 1
      erb :start_test, locals: { questions: Question.all, it1: it1, it2: it2 }
    else
      redirect '/'
    end
  end

  # processes the current question.
  # if it2 is smaller than questions.length, keeps on passing both the current question and the next question
  # if it2 is equal to questions.length, passes only the current question to the page that deals with the last element
  # if it2 is bigger than questions.length, redirects to the finish page with the test results
  get '/start/:id' do
    questions = Question.all
    qlen = questions.length
    if it2 > qlen
      redirect '/finish'
    elsif it2 == qlen
      erb :start_test_last, locals: { questions: questions, it1: it1 }
    elsif it2 < qlen
      erb :start_test, locals: { questions: questions, it1: it1, it2: it2 }
    end
  end

  # finds and updates the value of a particular choice
  # it also increases the iterators, because this is done as part of the test-taking process
  # redirects to the next question in the test
  post '/choices/update' do
    Choice.find(choice_id: params[:choice_id]).update(value: params[:value])
    it1 += 1
    it2 += 1
    redirect "/start/#{params[:next_id]}"
  end

  # finds and updates the value of the final choice, redirects to the finish page
  post '/choices/update/last' do
    Choice.find(choice_id: params[:choice_id]).update(value: params[:value])
    redirect '/finish'
  end

  # calculates how much every career fits a certain user
  get '/finish' do
    career_array = Career.map_to_career_struct
    Outcome.calc_weighted_values(career_array)
    erb :finish, locals: { career: Career.best_career_calc(career_array), careers: career_array.sort_by do |career|
                                                                                     -career.acum
                                                                                   end }
  end
end
