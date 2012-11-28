class Question < ActiveRecord::Base
  attr_accessible :content, :tag_list, :subject_list, :question_type_list,
                  :knowledge_point_list, :chapter_location_list, :location_list,
                  :source_list, :concept_list, :solution, :options_attributes
  has_and_belongs_to_many :exam_papers
  has_many :options, dependent: :destroy # d. 答案選項 for 選擇題
  has_many :images, :as => :imageable
  accepts_nested_attributes_for :options, allow_destroy: true, reject_if: :all_blank
  acts_as_taggable
  acts_as_taggable_on :subjects # a. 科目 (英文, 數學, 自然...)
  acts_as_taggable_on :question_types # b. 題型 (選擇題, 填充題, 問答題)
  acts_as_taggable_on :knowledge_points # f. *知識點
  acts_as_taggable_on :chapter_locations # i.章節來源 (大陸 or 台灣)
  acts_as_taggable_on :locations # j.來源(地區：大陸、臺灣、香港)
  acts_as_taggable_on :sources # K.來源(出處：基測、考古題、出版社、自行出題)
  acts_as_taggable_on :concepts # L.*學習概念 (出題時可選擇同一種概念不重覆出題)
  # g.知識點錄影
  # h.詳解

  validates :content, presence: true

  def question_string
    content[/\\question\s*(.*)/, 1]
  end
end