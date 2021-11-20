require './models/init'
require './controllers/SurveyController'
require './controllers/CareerController'
require './controllers/QuestionController'
require './controllers/OutcomeController'
require './controllers/TestLogicController'

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
  use TestLogicController

  # homepage
  get '/' do
    erb :landing
  end
end
