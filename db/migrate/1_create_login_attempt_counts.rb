class CreateLoginAttemptCounts < ActiveRecord::Migration
  def self.up
    create_table :login_attempt_counts do |t|
      t.column :user_id, :integer
      t.column :failed_attempts, :integer, :default => 0
    end
  end

  def self.down
    drop_table :login_attempt_counts
  end
end
