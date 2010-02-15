require_dependency 'principal'
require_dependency 'user'
require 'login_attempt_count'

module UserLoginAttemptLimiterPatch

  def self.included(base) # :nodoc:
    base.extend ClassMethods
    base.class_eval do
      class << self
        alias_method_chain :try_to_login, :attempt_limit
      end
    end
  end
  
  module ClassMethods
    # Locks the user account if too many login attempts failed
    def try_to_login_with_attempt_limit(login, password)
      user = try_to_login_without_attempt_limit login, password      
      logger.info "USER from without: #{user.to_json}"
      RAILS_DEFAULT_LOGGER.info "USER from without: #{user.to_json}"
      if user.nil?
      	authentication_failed login
      else
        LoginAttemptCount.reset_counter user.id
      end
    end
    
    
    def authentication_failed(login)
      # Counts failed logins and locks account if #login_attemps > allowed logins
      
      user = User.find_by_login login
      login_attempt_counter = LoginAttemptCount.find_by_user_id user.id
      
      #create a login_attempt counter if the user doesn't have one
      if login_attempt_counter.nil?   
      	puts "in nil"  
        login_attempt_counter = LoginAttemptCount.new :user_id => user.id        
        puts "lac in nil: #{login_attempt_counter.to_json}"
      end
      puts "lac after nil: #{login_attempt_counter.to_json}"
      
      #Increment counter and check if account should be locked
      login_attempt_counter.failed_attempts = login_attempt_counter.failed_attempts + 1            
      login_attempt_counter.save
      if login_attempt_counter.failed_attempts >= Setting.plugin_login_attempt_limiter['allowed_login_attempts'].to_i && Setting.plugin_login_attempt_limiter['allowed_login_attempts'].to_i != 0
      	User.lock_account
      end
  	end
  	
  	def lock_account(id)  	  
  	end  	
  	  	
  end
end

User.send(:include, UserLoginAttemptLimiterPatch)
#User.try_to_login 'admin', 'test'

  