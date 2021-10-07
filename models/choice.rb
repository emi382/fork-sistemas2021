class Choice < Sequel::Model
	one_to_one:questions #in sequel, to setup a one to one relation, its needed to list it as many_to_one in the table that has the foreign key
	one_to_many:outcomes
end

