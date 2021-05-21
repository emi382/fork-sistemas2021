class Outcome < Sequel::Model
	many_to_one:choices
	many_to_one:careers
end
