class Survey < Sequel::Model
	one_to_many:responses
	many_to_one:careers
end
