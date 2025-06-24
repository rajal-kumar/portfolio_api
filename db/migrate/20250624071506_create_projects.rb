class CreateProjects < ActiveRecord::Migration[8.0]
  def change
    create_table :projects do |t|
      t.string :title
      t.text :description
      t.string :status
      t.string :technology_stack
      t.string :repository_url
      t.string :live_url
      t.text :notes

      t.timestamps
    end
  end
end
