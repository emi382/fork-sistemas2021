require 'sinatra/base'
require_relative './services/OutcomeService'

# Control class for outcomes
class OutcomeController < Sinatra::Base
  configure :development, :production do
    set :views, "#{settings.root}/../views"
  end

  # Creates a new outcome given a choice id, career_id, and weight
  post '/outcomes/new' do
    OutcomeService.create_outcome(params[:career], params[:choice_id], params[:weight])
    redirect back
  end

  # Shows a particular outcome's information, along with delete and update weight functionalities
  get '/outcomes/:id' do
    outcome = Outcome.find(outcome_id: params[:id])
    erb :'questions/outcomes/outcome_description', locals: {
      outcome: outcome,
      question: Question.find(choice_id: outcome.choice_id)
    }
  end

  # Deletes an outcome
  post '/outcomes/:id/delete' do
    qid = OutcomeService.delete_outcome(params[:id])
    redirect "/questions/#{qid}/outcomes"
  end

  # Updates an outcome's weight
  post '/outcomes/:id' do
    Outcome.find(outcome_id: params[:id]).update(weight: params[:weight])
    redirect back
  end
end
