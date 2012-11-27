class Option < ActiveRecord::Base
  belongs_to :question
  attr_accessible :content, :is_answer
end
