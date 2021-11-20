require 'sinatra/base'
require_relative './services/TestLogicService'

class TestLogicController < Sinatra::Base
  configure :development, :production do
    set :views, "#{settings.root}/../views"
  end

  it1 = 0
  it2 = 1

  # Starts the test by setting the iterators to their default values and passing the first two questions
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

  # Processes the current question and decides which step to take next
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

  # Updates the value of the choice associated to a question
  # Prepares iterators for next step and redirects to next question
  post '/choices/update' do
    Choice.find(choice_id: params[:choice_id]).update(value: params[:value])
    it1 += 1
    it2 += 1
    redirect "/start/#{params[:next_id]}"
  end

  # Updates the value of the final choice, redirects to the finish page
  post '/choices/update/last' do
    Choice.find(choice_id: params[:choice_id]).update(value: params[:value])
    redirect '/finish'
  end

  # Result[0] is the array of all careers with their score
  # Result[1] is the career with the highest score
  get '/finish' do
    result = TestLogicService.calculate_answer
    erb :finish, locals: { career: result[1], careers: result[0].sort_by do |career|
                                                         -career.acum
                                                       end }
  end
end
