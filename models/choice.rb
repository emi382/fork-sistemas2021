# Choice is a class that will be used to record what the user answer to the question is
class Choice < Sequel::Model
  # to setup a one to one relation in sequel, its needed to list it as many_to_one in the table that has the foreign key
  one_to_one :questions
  one_to_many :outcomes
end
