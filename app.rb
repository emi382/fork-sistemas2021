require './models/init'

# This is the main class which determines the behavior of every path in our website
class App < Sinatra::Base
  configure do
    set :public_folder, File.expand_path('../public', 'style.css')
    set :views, File.expand_path('../views', 'style.css')
    set :root, File.dirname('../css/style.css')
  end

  it1 = 0
  it2 = 1

  # homepage
  get '/' do
    erb :landing
  end

  # starts the test by setting the iterators to their default values and passing the first two questions
  # WARNING: at least 2 questions needed for the test to work, and at least one outcome per question
  get '/start' do
    if Question.first_two
      it1 = 0
      it2 = 1
      erb :start_test, locals: { questions: Question.all, it1: it1, it2: it2 }
    else
      redirect '/'
    end
  end

  # processes the current question.
  # if it2 is smaller than questions.length, keeps on passing both the current question and the next question
  # if it2 is equal to questions.length, passes only the current question to the page that deals with the last element
  # if it2 is bigger than questions.length, redirects to the finish page with the test results
  get '/start/:id' do
    questions = Question.all
    qlen = questions.length
    if it2 > qlen
      redirect '/finish'
    elsif it2 == qlen
      erb :start_test_last, locals: { questions: questions, it1: it1 }
    elsif it2 < qlen
      erb :start_test, locals: { questions: questions, it1: it1, it2: it2 }
    end
  end

  # finds and updates the value of a particular choice
  # it also increases the iterators, because this is done as part of the test-taking process
  # redirects to the next question in the test
  post '/choices/update' do
    Choice.find(choice_id: params[:choice_id]).update(value: params[:value])
    it1 += 1
    it2 += 1
    redirect "/start/#{params[:next_id]}"
  end

  # finds and updates the value of the final choice, redirects to the finish page
  post '/choices/update/last' do
    Choice.find(choice_id: params[:choice_id]).update(value: params[:value])
    redirect '/finish'
  end

  # calculates how much every career fits a certain user
  get '/finish' do
    career_array = Career.map_to_career_struct
    Outcome.calc_weighted_values(career_array)
    erb :finish, locals: { career: Career.best_career_calc(career_array), careers: career_array.sort_by do |career|
                                                                                     -career.acum
                                                                                   end }
  end

  # creates a new survey with the given name and career_id parameter
  post '/surveys' do
    survey = Survey.new(name: params[:name], career_id: params[:career_id])
    # if saved, go back to homepage
    if survey.save
      [201, { 'Location' => "surveys/#{survey.survey_id}" }, 'Created']
      redirect '/'
    else
      [500, {}, 'Internal Server Error']
    end
  end

  # shows /surveys path
  get '/surveys' do
    @surveys = Survey.all
    erb :'surveys/survey_index'
  end

  # Se selecciona el rango y la carrera
  get '/surveys/setdate' do
    surveys = Survey.first
    if surveys.nil?
      redirect '/'
    else
      first_date = Survey.first
      last_date = Survey.last
      erb :'surveys/setdate',
          locals: { first_date: (first_date.created_at).to_formatted_s(:db),
                    last_date: (last_date.created_at + 10_000).to_formatted_s(:db), careers: Career.all }
    end
  end

  # given a range of dates, returns the career count of the surveys in that range....
  get '/surveys/careercount' do
    surveys = Survey.filter_by_date(params[:startDate], params[:finishDate])
    careers = Survey.career_count(surveys)
    erb :'surveys/careercount',
        locals: { careers: careers, career: Career.find(career_id: params[:career]).name }
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

  # creates a new question given a description
  # NOTE: automatically creates and associates a choice to the new question
  post '/questions' do
    description = params[:description]
    unless description.blank?
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

  # creates a new outcome given a choice id, career_id, and weight
  post '/outcomes/new' do
    id = params[:career]
    career_id = Career.find(career_id: id)
    unless career_id.nil?
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

  # shows a particular outcome's information, along with delete and update weight functionalities
  get '/outcomes/:id' do
    erb :'questions/outcomes/outcome_description', locals: {
      outcome: outcome = Outcome.find(outcome_id: params[:id]),
      question: question = Question.find(choice_id: outcome.choice_id)
    }
  end

  # deletes an outcome
  post '/outcomes/:id/delete' do
    qid = Outcome.questionid(params[:id])
    Outcome.where(outcome_id: params[:id]).delete
    redirect "/questions/#{qid}/outcomes"
  end

  # updates an outcome's weight
  post '/outcomes/:id' do
    Outcome.find(outcome_id: params['id']).update(weight: params[:weight])
    redirect back
  end

  # shows the outcomes associated to the question (through choice), allows outcome modifying
  get '/questions/:id/outcomes' do
    question = Question.where(question_id: params['id']).last
    choice = Choice.where(choice_id: question.choice_id).last
    erb :'questions/outcomes/outcomes_index', locals: { question: question, choice: choice,
                                                        outcomes: Outcome.where(choice_id: choice.choice_id),
                                                        careers: Career.all }
  end

  # creates a new career
  post '/careers' do
    unless params['name'].blank?
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
