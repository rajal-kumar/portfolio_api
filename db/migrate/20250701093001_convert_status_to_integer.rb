class ConvertStatusToInteger < ActiveRecord::Migration[8.0]
  class MigrationProject < ApplicationRecord
    self.table_name = 'projects'
  end

  def up
    add_column :projects, :status_int, :integer, default: 0, null: false

    MigrationProject.reset_column_information

    MigrationProject.find_each do |project|
      case project.status
      when "pending"
        project.update_column(:status_int, 0)
      when "in_progress"
        project.update_column(:status_int, 1)
      when "completed"
        project.update_column(:status_int, 2)
      end
    end

    remove_column :projects, :status
    rename_column :projects, :status_int, :status
  end

  def down
    add_column :projects, :status_str, :string

    MigrationProject.reset_column_information

    MigrationProject.find_each do |project|
      case project.status
      when 0
        project.update_column(:status_str, "pending")
      when 1
        project.update_column(:status_str, "in_progress")
      when 2
        project.update_column(:status_str, "completed")
      end
    end

    remove_column :projects, :status
    rename_column :projects, :status_str, :status
  end
end
