class Response < Sequel::Model
	many_to_one:choices
	many_to_one:questions
	many_to_one:surveys
end
