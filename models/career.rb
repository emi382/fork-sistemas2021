class Career < Sequel::Model
	one_to_many:surveys
	one_to_many:outcomes
end
