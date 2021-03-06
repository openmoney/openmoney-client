################################################################################
#
# Copyright (C) 2006-2007 pmade inc. (Peter Jones pjones@pmade.com)
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
################################################################################
class Rauth::Source::Native < ActiveRecord::Base
  ################################################################################
  # Use a table name that makes more sense than the one guessed by AR
  set_table_name('rauth_native_accounts')

  ################################################################################
  # A way to change the default options
  cattr_accessor(:rauth_options)

  ################################################################################
  # Default options:
  @@rauth_options = {
    :clean_username   => true,
    :min_pass_length  => 6,
    :pass_must_match  => /./,
    :pass_error_msg   => 'Please choose a valid password',
    :allow_blank_pass => false,
    :enable_openid    => false,
  }

  ################################################################################
  validates_uniqueness_of(:user_name)

  ################################################################################
  attr_accessible(:user_name)

  ################################################################################
  # Finder that cleans the user name if necessary
  def self.find_by_user_name (user_name)
    user_name = user_name.to_s.strip.downcase if self.rauth_options[:clean_username]
    self.find(:first, :conditions => {:user_name => user_name})
  end

  ################################################################################
  # Locate the account with these credentials
  def self.authenticate (user_name, plain_text_password)
    options = self.rauth_options

    if options[:enable_openid]
      raise("OpenID support isn't implemented yet, FIXME!")
    end

    user_name = user_name.to_s.strip.downcase if options[:clean_username]
    account = self.find(:first, :conditions => {:user_name => user_name})
    return account if account and account.password?(plain_text_password)
    nil # return nil when authentication fails
  end

  ################################################################################
  # Locate the given account and activate it (does not call account.save).
  # You must save the account after it is returned, so that the
  # activation_code will be reset.  Returns nil if no account could be found
  # with the given user_name and code.
  def self.activate (user_name, code)
    options = self.rauth_options
    user_name = user_name.to_s.strip.downcase if options[:clean_username]
    code = code.to_s.strip.upcase # redo what require_activation! does

    if account = self.find_by_user_name_and_activation_code(user_name, code)
      account.enabled = true
      account.activation_code = ''
      return account
    end
  end

  ################################################################################
  # Locate the given account and activate it, saving the account before
  # returning it.
  def self.activate! (user_name, code)
    account = activate(user_name, code)
    account.save! if account
    account
  end

  ################################################################################
  # Locate an account based on the user_name and a reset code.  If that
  # account can be found, reset the password with the given password and
  # confirmation.
  #
  # Returns nil if no matching account can be found.  Returns an account
  # object if the account could be found.  You should check valid? on the
  # returned account because the password setting might have failed if the
  # password and password confirmation don't match.
  def self.reset_password! (user_name, code, password, confirmation)
    options = self.rauth_options
    user_name = user_name.to_s.strip.downcase if options[:clean_username]
    code = code.to_s.strip.upcase

    if account = self.find_by_user_name_and_reset_code(user_name, code)
      if account.password_with_confirmation(password, confirmation)
        account.reset_code = ''
        account.save
      end

      return account
    end
  end

  ################################################################################
  # Check to see if the given plain_text_password matches the encoded
  # password stored in the database.
  def password? (plain_text_password)
    # don't allow logging in with blank passwords
    return false if plain_text_password.blank?
    return false if self.password_hash.blank?

    salt = self.password_salt
    pass = self.password_hash
    Rauth::Encode.mkpasswd(plain_text_password, salt) == pass
  end

  ################################################################################
  # Set the encoded password from the given plain text password.
  def password= (plain_text_password)
    options = self.class.rauth_options
    @password_valid = nil

    if plain_text_password.blank? or 
      plain_text_password.length < options[:min_pass_length] or
      !plain_text_password.match(options[:pass_must_match])
    then
      @password_valid = false
      return
    end

    salt = Rauth::Encode.mksalt
    pass = Rauth::Encode.mkpasswd(plain_text_password, salt)
    self.password_salt = salt
    self.password_hash = pass

    [salt, pass]
  end

  ################################################################################
  # Given a plain text password, and a confirmation of that password, set
  # the encoded password if the two match.
  def password_with_confirmation (password, confirmation)
    return unless @password_match = (!password.blank?)
    return unless @password_match = (password == confirmation)
    self.password = password
  end

  ################################################################################
  # Great for changing a password from a form that asks for three passwords,
  # the current password, the new password, and a password confirmation.
  # Returns true if the change was successful, false otherwise. If the
  # password setting was false, you can get the error messages from the errors
  # object.
  def change_password (current_pass, new_pass, confirm_pass)
    return valid? unless @current_password = password?(current_pass)
    password_with_confirmation(new_pass, confirm_pass)
    valid?
  end

  ################################################################################
  # Require that the given account be activated with a code
  def require_activation!
    self.enabled = false
    self.activation_code = Digest::MD5.hexdigest(self.object_id.to_s + Rauth::Encode.mksalt).upcase
  end
  
  ################################################################################
  # Check to see if this account requires activation
  def require_activation?
    !self.enabled? and !self.activation_code.blank?
  end

  ################################################################################
  # Create a password reset code for this account
  def reset_code!
    self.reset_code = Digest::MD5.hexdigest(self.object_id.to_s + Rauth::Encode.mksalt).upcase
  end

  ################################################################################
  # Make sure the user_name column is clean
  def user_name= (name)
    options = self.class.rauth_options
    name = name.strip.downcase if options[:clean_username]
    self[:user_name] = name
  end

  ################################################################################
  # Check the password
  validate do |record|
    options = record.class.rauth_options

    if record.instance_variable_get(:@password_valid) == false
      record.errors.add_to_base(options[:pass_error_msg])
    elsif record.instance_variable_get(:@current_password) == false
      record.errors.add_to_base("Current password is incorrect")
    elsif record.instance_variable_get(:@password_match) == false
      record.errors.add_to_base("Password and password confirmation don't match")
    elsif !options[:allow_blank_pass] and record.password_hash.blank?
      record.errors.add_to_base("Password can't be blank")
    end
  end

end
################################################################################
