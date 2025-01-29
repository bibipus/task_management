# frozen_string_literal: true

class AddUniqueIndexToProjectsPosition < ActiveRecord::Migration[8.0]
  def change
    add_index :projects, %i[user_id position], unique: true
  end
end
