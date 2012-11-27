class Question < ActiveRecord::Base
  attr_accessible :content, :tag_list
  has_and_belongs_to_many :exam_papers
  acts_as_taggable

  def question_string
    content[/\\question\s*(.*)/, 1]
  end
end
