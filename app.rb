require './models/init.rb'

class App < Sinatra::Base

  it1=0
  it2=1

  #homepage
  get '/' do
  erb :'landing'
  end

  #starts the test by setting the iterators to their default values and passing the first two questions
  #WARNING: at least 2 questions needed for the test to work
  get "/start" do
    it1=0 #podria ponerse en homepage capaz?
    it2=1
    questions=Question.all
    question1=questions[it1]
    question2=questions[it2]
    #Verifica que haya 2 question creadas, y ademas, que esten asociada a una career con su respectivo peso
    if (question1 != nil && question2 != nil && Outcome.find(choice_id: question1.choice_id) && Outcome.find(choice_id: question2.choice_id))
      erb :'start_test', :locals => {:questions => questions, :it1 => it1, :it2 =>it2}
    else
      redirect "/"
    end
  end

  #processes the current question.
  #if it2 is smaller than questions.length, keeps on passing both the current question and the next question
  #if it2 is equal to questions.length, passes only the current question to the page that deals with the last element
  #if it2 is bigger than questions.length, redirects to the finish page with the test results
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

  #finds and updates the value of a particular choice
  #it also increases the iterators, because this is done as part of the test-taking process
  #redirects to the next question in the test
  post "/choices/update" do
    Choice.find(choice_id: params[:choice_id]).update(value: params[:value])
    it1=it1+1
    it2=it2+1
    redirect "/start/#{params[:next_id]}"
  end

  #finds and updates the value of the final choice
  #it also increases the iterators, and redirects to the finish page
  post "/choices/update/last" do
    Choice.find(choice_id: params[:choice_id]).update(value: params[:value])
    it1=it1+1
    it2=it2+1
    redirect "/finish"
  end

  #calculates how much every career fits a certain user
  get "/finish" do
    outcomes=Outcome.all
    careers=Career.all
    careerStruct=Struct.new(:career_id,:name,:acum) #structure that includes both career parameters and an accumulator
    careerArray=Array.new
    i=0
    #for every career, insert it to the careerArray and start the accumulator with the value 0
    careers.map do |career|
      careerArray[i]=careerStruct.new(career.career_id,career.name,0)
      i=i+1;
    end

    #multiply the choice value (user-set value) and the outcome weight (weight towards a specific career)
    #then add it to the accumulator specific to the career which is associated with the current outcome
    outcomes.map do |outcome|
      choice=Choice.find(choice_id: outcome.choice_id)
      curr=outcome.weight * choice.value
      careerArray.each do |k|
        if k.career_id == outcome.career_id
          k.acum+=curr
        end
      end
    end

    #find the career which has the maximum accumulator value, then pass it to erb for final processing
    max=0
    careerid=0
    careerArray.each do |k|
      if k.acum>=max
        max=k.acum
        careerid=k.career_id
      end
    end
    finalcareer = Career.find(career_id: careerid)
    erb :'finish', :locals => {:career => finalcareer, :careers => careerArray.sort_by {|career| -career.acum}, :max => max}
  end

  #creates a new survey with the given name and career_id parameter
  post "/surveys" do
    survey = Survey.new(name: params[:name],career_id: params[:career_id])
    #if saved, go back to surveys
    if survey.save
      [201, { 'Location' => "surveys/#{survey.survey_id}" }, 'Created']
      redirect back
    else
      [500, {}, 'Internal Server Error']
    end
  end

  #shows /surveys path
  get '/surveys' do
    @surveys=Survey.all
    erb :'surveys/survey_index'
  end

  #shows the information of a particular survey
  get '/surveys/:id' do
    survey = Survey.where(survey_id: params['id']).last
    if survey.career_id != nil
      career = Career.find(career_id: survey.career_id)
      erb :'surveys/survey_description', :locals => {:survey => survey, :career => career}
    else
      erb :'surveys/survey_description_no_career', :locals =>{:survey => survey}
    end
  end

  #deletes a survey given its id
  post '/surveys/:id/delete' do
    Survey.where(:survey_id => params[:id]).delete
    redirect '/surveys'
  end

  #creates a new question given a description
  #NOTE: automatically creates and associates a choice to the new question
  post "/questions" do
    description = params[:description]
    if !description.blank?
      choice = Choice.new(value: -1)
      choice.save
      question = Question.new(description: description, choice_id: choice.choice_id)
      if question.save
        [201, { 'Location' => "questions/#{question.question_id}" }, 'Created']
        redirect back
      else
        [500, {}, 'Internal Server Error']
      end
    end
    redirect back
  end

  #shows all questions
  get '/questions' do
    @questions=Question.all
    erb :'questions/question_index'
  end

  #shows an individual question description, along with redirecting to the outcome modifying page if needed
  get '/questions/:id' do
    question=Question.where(question_id: params['id']).last
    erb :'questions/question_description', :locals => {:question => question}
  end

  #deletes a question, once a question is deleted it also deletes the choice associated with it, and any outcomes
  #that said choice had associated
  post "/questions/:id/delete" do
    Question.where(:question_id => params[:id]).delete
    Choice.where(:choice_id => params[:choice_id]).delete
    redirect '/questions'
  end

  #creates a new outcome given a choice id, career_id, and weight
  post "/outcomes/new" do
    id = params[:career]
    career_id = Career.find(career_id: id)
    if(career_id != nil)
      outcome = Outcome.new(choice_id: params[:choice_id], career_id: id, weight: params[:weight])
      if outcome.save
        [201, { 'Location' => "outcomes/#{outcome.outcome_id}" }, 'Created']
        redirect back
      else
        [500, {}, 'Internal Server Error']
      end
    end
    redirect back
  end

  #shows a particular outcome's information, along with delete and update weight functionalities
  get "/outcomes/:id" do
    outcome=Outcome.where(outcome_id: params['id']).last
    erb :'questions/outcomes/outcome_description', :locals => {:outcome => outcome}
  end

  #deletes an outcome
  post "/outcomes/:id/delete" do
    outcome=Outcome.find(:outcome_id => params[:id])
    question=Question.find(:choice_id => outcome.choice_id)
    Outcome.where(:outcome_id => params[:id]).delete
    redirect "/questions/#{question.question_id}/outcomes"
  end

  #updates an outcome's weight
  post "/outcomes/:id" do
    Outcome.find(:outcome_id => params['id']).update(weight: params[:weight])
    redirect back
  end

  #shows the outcomes associated to the choice that is associated to a question. Also has create outcome functionalities
  get "/questions/:id/outcomes" do
    question=Question.where(question_id: params['id']).last
    choice=Choice.where(choice_id: question.choice_id).last
    outcomes=Outcome.where(choice_id: choice.choice_id)
    careers = Career.all #Para mostrar la lista desplegable de carreras
    erb :'questions/outcomes/outcomes_index', :locals =>{:outcomes => outcomes, :choice => choice, :careers => careers, :question => question}
  end

  #creates a new career
  post "/careers" do
    careers=Career.all
    if !params['name'].blank?
      career = Career.new(name: params['name'])
      if career.save
        [201, { 'Location' => "careers/#{career.id}" }, 'Created']
        redirect back
      else
        [500, {}, 'Internal Server Error']
      end
    end
    redirect back
  end

  #deletes a career
  post "/careers/:id/delete" do
    Career.where(:career_id => params[:id]).delete
    redirect '/careers'
  end

  #shows all careers
  get '/careers' do
    careers=Career.all
    erb :'careers/career_index', :locals =>{:careers => careers}
  end

  #shows a particular career and includes a delete button
  get '/careers/:id' do
    career = Career.where(career_id: params['id']).last
    erb :'careers/career_description', :locals => {:career => career}
  end
end
