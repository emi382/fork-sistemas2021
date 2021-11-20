require 'sinatra/base'
require_relative './services/CareerService'

class CareerController < Sinatra::Base
  configure :development, :production do
    set :views, "#{settings.root}/../views"
  end

  # creates a new career
  post '/careers' do
    CareerService.create_career(params[:name])
    redirect back
  end

  # deletes a career
  post '/careers/:id/delete' do
    Career.where(career_id: params[:id]).delete
    redirect '/careers'
  end

  # shows all careers
  get '/careers' do
    erb :'careers/career_index', locals: { careers: Career.all }
  end

  # shows a particular career and includes a delete button
  get '/careers/:id' do
    erb :'careers/career_description', locals: { career: Career.where(career_id: params['id']).last }
  end
end
