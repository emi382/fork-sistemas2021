require 'sinatra/base'
require_relative './services/QuestionService'

class QuestionController < Sinatra::Base
  configure :development, :production do
    set :views, "#{settings.root}/../views"
  end

  # creates a new question given a description
  # NOTE: automatically creates and associates a choice to the new question
  post '/questions' do
    QuestionService.create_question(params[:description])
    redirect back
  end

  # shows all questions
  get '/questions' do
    erb :'questions/question_index', locals: { questions: Question.all }
  end

  # shows an individual question description, along with redirecting to the outcome modifying page if needed
  get '/questions/:id' do
    erb :'questions/question_description', locals: { question: Question.where(question_id: params['id']).last }
  end

  # deletes a question, once a question is deleted it also deletes the choice associated with it, and any outcomes
  # that said choice had associated
  post '/questions/:id/delete' do
    Question.deleteq(params[:id])
    redirect '/questions'
  end

  # shows the outcomes associated to the question (through choice), allows outcome modifying
  get '/questions/:id/outcomes' do
    result = QuestionService.question_and_choice(params['id'])
    erb :'questions/outcomes/outcomes_index', locals: { question: result.first, choice: result[1],
                                                        outcomes: Outcome.where(choice_id: result[1].choice_id),
                                                        careers: Career.all }
  end
end
