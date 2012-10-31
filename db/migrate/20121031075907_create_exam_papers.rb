class CreateExamPapers < ActiveRecord::Migration
  def change
    create_table :exam_papers do |t|
      t.string :name

      t.timestamps
    end
  end
end
