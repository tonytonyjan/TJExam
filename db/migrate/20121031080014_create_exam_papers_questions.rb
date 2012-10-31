class CreateExamPapersQuestions < ActiveRecord::Migration
  def change
    create_table :exam_papers_questions, :id => false do |t|
      t.references :question
      t.references :exam_paper
    end
  end
end
