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
module Rauth
  ################################################################################
  class AccountCreator
    ################################################################################
    def initialize (backend)
      @backend = backend
    end

    ################################################################################
    def create (user_model, options={}, &block)
      user_model = check_user_model(user_model)
      config = check_options(options)

      account = @backend.new({
        :user_name  => config[:user_name]
      })
      account.openid_url = config[:openid_url]

      set_password(account, config)
      user_model.instance_variable_set(:@rauth_account, account)

      begin
        ActiveRecord::Base.transaction do
          account.require_activation! if config[:activation]
          account.save!
          user_model.account_id = account.id
          user_model.save!
          yield(account) if block_given?
        end
      rescue
        user_model.valid? # force the transfer of error messages
        return false
      end

      return config[:activation] ? account.activation_code : true
    end

    ################################################################################
    private

    ################################################################################
    def check_options (options)
      config = {
        :user_name    => nil,
        :openid_url   => nil,
        :password     => nil,
        :confirmation => nil,
        :activation   => false,
      }.update(options)

      if config[:user_name].nil? and config[:openid_url].nil?
        raise("you must use one of :user_name or :openid_url")
      end

      if config[:user_name] and config[:openid_url]
        raise("you can't use :user_name and :openid_url at the same time")
      end

      config
    end

    ################################################################################
    def check_user_model (user)
      if !user.respond_to?(:rauth_loaded?)
        user.class.acts_as_user
      end
      
      user
    end

    ################################################################################
    def set_password (account, config)
      if !config[:password].nil? and !config[:confirmation].nil?
        account.password_with_confirmation(config[:password], config[:confirmation])
      elsif !config[:password].nil?
        account.password = config[:password]
      end
    end

  end
end
################################################################################
