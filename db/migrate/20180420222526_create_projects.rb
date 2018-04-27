class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.string :course
      t.string :name
      t.text :students
      t.string :components, array: true
    end

    create_table :project_evaluations do |t|
      t.text :evaluation
    end

    create_table :project_students do |t|
      t.integer :project_id
      t.string :token
      t.string :name
      t.string :email
      t.integer :grades, array: true
      t.text :evaluation
      t.datetime :evaluated_at
      t.boolean :sent, default: false
      t.datetime :sent_at

      t.index :token
    end
  end
end
