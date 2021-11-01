#Choice is a class that will be used to record what the user answer to the question is
class Choice < Sequel::Model
	one_to_one:questions #in sequel, to setup a one to one relation, its needed to list it as many_to_one in the table that has the foreign key
	one_to_many:outcomes
end

