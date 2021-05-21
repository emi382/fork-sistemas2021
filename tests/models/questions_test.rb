require File.expand_path '../../test_helper.rb', __FILE__

class QuestionTest < MiniTest::Unit::TestCase
MiniTest::Unit::TestCase
	
  def test_question_has_many_choices
  
    #Arrange
    question=Question.create(name: 'Q1',description:"asd",number:3,type:"asdasg")
		
    #Act
    Choice.create(text:'a',question_id: question.question_id)
    Choice.create(text:'b',question_id: question.question_id)
		
    #Assert
		
    assert_equal question.choices.count, 2

  end
  
  def test_question_has_many_responses

    #Arrange
    question=Question.create(name: 'Q1',description:"asd",number:3,type:"asdasg")
    
    #Act
    Response.create(question_id: question.question_id)
    Response.create(question_id: question.question_id)
    
    #Assert
    
    assert_equal question.responses.count, 2

  end
  
  def test_question_name_is_not_null
    question = Question.new
    

    question.name=nil
    question.description='a'
    question.number=3
    question.type='e'
    
    assert_equal question.valid?, false
  end

  def test_question_name_is_not_empty
    question = Question.new
    
    question.name=''
    question.description='a'
    question.number=3
    question.type='e'
    
    assert_equal question.valid?, false
  end

  def test_question_description_is_not_null
    question = Question.new
    
    question.name='a'
    question.description=nil
    question.number=3
    question.type='e'
    
    assert_equal question.valid?, false
  end

  def test_question_description_is_not_empty
    question = Question.new
    
    question.name='a'
    question.description=''
    question.number=3
    question.type='e'
    
    assert_equal question.valid?, false
  end

  def test_question_number_is_not_null
    question = Question.new
    
    question.name='a'
    question.description='b'
    question.number=nil
    question.type='e'
    
    assert_equal question.valid?, false
  end

  def test_question_type_is_not_null
    question = Question.new
    
    question.name='a'
    question.description='b'
    question.number=3
    question.type=nil
    
    assert_equal question.valid?, false
  end

  def test_question_type_is_not_empty
    question = Question.new
    
    question.name='a'
    question.description='b'
    question.number=3
    question.type=''
    
    assert_equal question.valid?, false
  end
  

end
