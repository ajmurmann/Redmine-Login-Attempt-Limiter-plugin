class LoginAttemptCount < ActiveRecord::Base

	belongs_to :user
	
	def self.reset_counter user_id
	  login_counter = LoginAttemptCount.find_by_user_id user_id
	  login_counter.failed_attempts = 0
	  login_counter.save
	end
	
end
