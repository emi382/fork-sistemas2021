require 'sinatra/base'
require_relative './services/SurveyService'

class SurveyController < Sinatra::Base
  configure :development, :production do
    set :views, "#{settings.root}/../views"
  end

  # Shows /surveys path
  get '/surveys' do
    @surveys = Survey.all
    erb :'surveys/survey_index'
  end

  # Creates a new survey with the given name and career_id parameter
  post '/surveys' do
    Survey.create(name: params[:name], career_id: params[:career_id])
    redirect '/'
  end

  # Usa la primera y ultima survey para calcular mi rango de surveys totales
  # Dates[1] es la primera survey, dates[2] es la ultima survey
  get '/surveys/setdate' do
    dates = SurveyService.first_and_last
    if dates.first == false
      redirect '/'
    else
      erb :'surveys/setdate',
          locals: { first_date: (dates[1].created_at).to_formatted_s(:db),
                    last_date: (dates[2].created_at + 10_000).to_formatted_s(:db), careers: Career.all }
    end
  end

  # Given a range of dates, returns the career count of the surveys in that range
  # result has a structure that has the career name and the survey count
  get '/surveys/careercount' do
    result = SurveyService.career_count_view(params[:startDate], params[:finishDate], params[:career])
    erb :'surveys/careercount',
        locals: { career: result }
  end

  # Shows the information of a particular survey
  get '/surveys/:id' do
    survey = Survey.where(survey_id: params[:id]).last
    erb :'surveys/survey_description',
        locals: { survey: survey, career: Career.find(career_id: survey.career_id),
                  date: survey.created_at.to_formatted_s(:db) }
  end

  # Deletes a survey given its id
  post '/surveys/:id/delete' do
    Survey.where(survey_id: params[:id]).delete
    redirect '/surveys'
  end
end
