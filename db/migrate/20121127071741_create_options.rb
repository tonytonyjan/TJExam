class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.references :question
      t.boolean :is_answer
      t.string :content

      t.timestamps
    end
    add_index :options, :question_id
  end
end
