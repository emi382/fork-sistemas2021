require 'sinatra/base'
require_relative './services/QuestionService'

# Control class for questions
class QuestionController < Sinatra::Base
  configure :development, :production do
    set :views, "#{settings.root}/../views"
  end

  # Creates a new question given a description, along with its associated choice
  post '/questions' do
    QuestionService.create_question(params[:description])
    redirect back
  end

  # Shows all questions
  get '/questions' do
    erb :'questions/question_index', locals: { questions: Question.all }
  end

  # Shows an individual question description, along with redirecting to the outcome modifying page
  get '/questions/:id' do
    erb :'questions/question_description', locals: { question: Question.where(question_id: params['id']).last }
  end

  # Deletes a question, the choice associated with it and all its outcomes
  post '/questions/:id/delete' do
    Question.deleteq(params[:id])
    redirect '/questions'
  end

  # Shows the outcomes associated to the question (through choice), allows outcome modifying
  # Result[0] is the question, Result[1] is the choice associated to it
  get '/questions/:id/outcomes' do
    result = QuestionService.question_and_choice(params['id'])
    erb :'questions/outcomes/outcomes_index', locals: { question: result.first, choice: result[1],
                                                        outcomes: Outcome.where(choice_id: result[1].choice_id),
                                                        careers: Career.all }
  end
end
