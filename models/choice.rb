class Choice < Sequel::Model
	many_to_one:questions
	one_to_many:responses
	one_to_many:outcomes
end
