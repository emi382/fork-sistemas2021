require './models/init.rb'

class App < Sinatra::Base

  it1=0
  it2=1

  get '/' do
  

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

  post "/choices/update" do
    Choice.find(choice_id: params[:choice_id]).update(value: params[:value])
    it1=it1+1
    it2=it2+1
    redirect "/start/#{params[:next_id]}"
  end

  post "/choices/update/last" do
    Choice.find(choice_id: params[:choice_id]).update(value: params[:value])
    it1=it1+1
    it2=it2+1
    redirect "/finish"
  end

  get "/start" do
    it1=0 #podria ponerse en homepage capaz?
    it2=1
    questions=Question.all
    question1=questions[it1]
    question2=questions[it2]
    #questions.map do |question| 
    #erb :'start_test', :locals => {:question => question}
    #end

    erb :'start_test', :locals => {:questions => questions, :it1 => it1, :it2 =>it2}
  end

  get "/start/:id" do 
    questions=Question.all
    question1=questions[it1]

    if it2 > questions.length
      redirect "/finish"
    elsif it2==questions.length
      erb :'start_test_last', :locals => {:questions => questions, :it1 => it1}
    elsif it2<questions.length
      question2=questions[it2]
      erb :'start_test', :locals => {:questions => questions, :it1 => it1, :it2 =>it2}
    end
  end

  get "/finish" do 

    outcomes=Outcome.all
    i=0
    careers=Career.all
    careerStruct=Struct.new(:career_id,:acum)
    careerArray=Array.new

    careers.map do |career|
      careerArray[i]=careerStruct.new(career.career_id,0)
      i=i+1;
    end

    outcomes.map do |outcome|
      choice=Choice.find(choice_id: outcome.choice_id)
      curr=outcome.weight * choice.value

      careerArray.each do |k| 
        if k.career_id == outcome.career_id
          k.acum+=curr
        end
      end

    end

    max=0
    careerid=0

    careerArray.each do |k|
      if k.acum>max
        max=k.acum
        careerid=k.career_id
      end
    end

    finalcareer=Career.find(career_id: careerid)

    erb :'finish', :locals => {:career => finalcareer}

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
      choices = Choice.all 
      choices.map do |choice|
        Choice.find(choice_id: choice.choice_id).update(survey_id: survey.survey_id)
      end
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
    choice = Choice.new(value: -1)
    choice.save
    question = Question.new(name: params[:name], description: params[:description], number: params[:number], choice_id: choice.choice_id)

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
    Outcome.where(:choice_id => params[:choice_id]).delete
    Choice.where(:choice_id => params[:choice_id]).delete #habria que poner :cascade en el foreign key de outcome
    redirect '/questions'
  end

  post "/outcomes/new" do
    outcome=Outcome.new(choice_id: params[:choice_id], career_id: params[:career], weight: params[:weight] )

    if outcome.save
      [201, { 'Location' => "outcomes/#{outcome.outcome_id}" }, 'Created']
      redirect back
    else
      [500, {}, 'Internal Server Error']
    end
  end

  get "/questions/:id/outcomes" do
    question=Question.where(question_id: params['id']).last
    choice=Choice.where(choice_id: question.choice_id).last
    outcomes=Outcome.where(choice_id: choice.choice_id)

    erb :'questions/outcomes/outcomes_index', :locals =>{:outcomes => outcomes, :choice => choice}

  end

  post "/careers/:id/delete" do
    Career.where(:career_id => params[:id]).delete
    redirect '/careers'
  end


  get '/careers' do
    @careers=Career.all

    erb :'careers/career_index'
  end

  get '/careers/:id' do 
    career = Career.where(career_id: params['id']).last

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

