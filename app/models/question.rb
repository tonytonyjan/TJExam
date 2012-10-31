class Question < ActiveRecord::Base
  attr_accessible :content
  has_and_belongs_to_many :exam_papers

  def question_string
    content[/\\question\s*(.*)/, 1]
  end
end
