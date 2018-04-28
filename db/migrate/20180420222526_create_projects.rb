class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.string :course
      t.string :name
      t.datetime :created_at
      t.integer :components, array: true, default: []
    end

    create_table :students do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
    end

    create_table :evaluations do |t|
      t.text :evaluation
    end

    create_table :components do |t|
      t.string :name
      t.string :subtext
    end

    create_table :project_students do |t|
      t.integer :project_id
      t.integer :student_id
      t.string :token
      t.json :grades
      t.text :evaluation
      t.datetime :evaluated_at
      t.boolean :sent, default: false
      t.datetime :sent_at

      t.index :token
      t.index :student_id
    end
  end
end
