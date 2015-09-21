class AddSubmissionNumberToCompetitors < ActiveRecord::Migration
  def change
    add_column :competitors, :submission, :integer
  end
end
