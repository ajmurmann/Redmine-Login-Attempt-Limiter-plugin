require 'redmine'
require 'user_login_attempt_limiter_patch'

Redmine::Plugin.register :login_attempt_limiter do
  name 'Login Attempt Limiter plugin'
  author 'Alexander J. Murmann'
  description 'Allows the administrator to limit the number of allowed login attempts. Is this number exceeded the account gets locked.'
  version '0.0.1'
  
  
  settings :default => { 'allowed_login_attempts' => 0,
		   'too_many_logins_email' => ''}, :partial => 'settings/login_attempt_settings'  
  
end