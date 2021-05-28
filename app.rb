require './models/init.rb'

class App < Sinatra::Base

  get '/' do

  @surveys=Survey.all
  
  erb :'landing'

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

  get "/start" do 
    @questions=Question.all
    erb :'start_test'

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

  post "/surveys/start" do 
    survey = Survey.new(name: params[:name])

    if survey.save
      [201, { 'Location' => "surveys/#{survey.survey_id}" }, 'Created']
      redirect '/start'
    else
      [500, {}, 'Internal Server Error']
    end

  end

  get '/surveys' do
    @surveys=Survey.all

    erb :'surveys/survey_index'
  end

  get '/surveys/:id' do 
    survey = Survey.where(survey_id: params['id']).last

    erb :'surveys/survey_description', :locals => {:survey => survey}

  end

  post "/questions" do 
    question = Question.new(name: params[:name], description: params[:description], number: params[:number])

    if question.save
      [201, { 'Location' => "questions/#{question.question_id}" }, 'Created']
      redirect back
    else
      [500, {}, 'Internal Server Error']
    end

  end

  get '/questions' do
    @questions=Question.all

    erb :'questions/question_index'
  end

  get '/questions/:id' do 
    question=Question.where(question_id: params['id']).last

    erb :'questions/question_description', :locals => {:question => question}
  end

  post "/questions/:id/delete" do
    Question.where(:question_id => params[:id]).delete
    redirect '/questions'
  end

  post "/careers/:id/delete" do
    Career.where(:id => params[:id]).delete
    redirect '/careers'
  end


  get '/careers' do
    @careers=Career.all

    erb :'careers/career_index'
  end

  get '/careers/:id' do 
    career = Career.where(id: params['id']).last

    erb :'careers/career_description', :locals => {:career => career}

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

