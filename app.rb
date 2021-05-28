require './models/init.rb'

class App < Sinatra::Base

  get '/' do
    "hola"
  #@surveys=Survey.all
  #erb :'landing'
  end

  get "/hello/:name" do
   @name = params[:name]
   erb :hello_template
  end

  post "/careers" do

  	career = Career.new(name: params[:name])

  	if career.save
  		[201, { 'Location' => "careers/#{career.id}" }, 'Created']
      redirect back
  	else
  		[500, {}, 'Internal Server Error']
  	end

  end

  post "/surveys" do
    survey = Survey.new(name: params[:name])

    if survey.save
      [201, { 'Location' => "surveys/#{survey.survey_id}" }, 'Created']
      redirect back
    else
      [500, {}, 'Internal Server Error']
    end

  end

  get '/careers' do
    @careers = Career.all
    items = @careers.map {|career| "<li> #{career.name} </li>"}
    @string = items.join
    erb :'careers/career_xendi'
  end

  get '/surveys' do
    @surveys=Survey.all

    erb :'surveys/survey_index'
  end

  get '/careers/:id' do
    career = Career.where(id: params['id']).last

    erb :'careers/career_description', :locals => {:career => career}

  end

  get '/surveys/:id' do
    survey = Survey.where(survey_id: params['id']).last

    erb :'surveys/survey_description', :locals => {:survey => survey}

  end

  post "/posts" do
    request.body.rewind  # in case someone already read it
    data = JSON.parse request.body.read
    post = Post.new(description: data['desc'])
    if post.save
      [201, { 'Location' => "posts/#{post.id}" }, 'CREATED']
    else
      [500, {}, 'Internal Server Error']
    end
  end

  get '/posts' do
    p = Post.where(id: 1).last
    p.description
  end
end
