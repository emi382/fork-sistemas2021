require 'sinatra/base'
require_relative './services/SurveyService'

class SurveyController < Sinatra::Base
  configure :development, :production do
    set :views, "#{settings.root}/../views"
  end

  # shows /surveys path
  get '/surveys' do
    @surveys = Survey.all
    erb :'surveys/survey_index'
  end

  # creates a new survey with the given name and career_id parameter
  post '/surveys' do
    Survey.create(name: params[:name], career_id: params[:career_id])
    redirect '/'
  end

  # Se selecciona el rango y la carrera
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

  # given a range of dates, returns the career count of the surveys in that range
  get '/surveys/careercount' do
    result = SurveyService.career_count_view(params[:startDate], params[:finishDate], params[:career])
    erb :'surveys/careercount',
        locals: { careers: result.first, career: result[1] }
  end

  # shows the information of a particular survey
  get '/surveys/:id' do
    survey = Survey.where(survey_id: params[:id]).last
    erb :'surveys/survey_description',
        locals: { survey: survey, career: Career.find(career_id: survey.career_id),
                  date: survey.created_at.to_formatted_s(:db) }
  end

  # deletes a survey given its id
  post '/surveys/:id/delete' do
    Survey.where(survey_id: params[:id]).delete
    redirect '/surveys'
  end
end
