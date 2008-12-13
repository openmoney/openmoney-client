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
  # The Rauth::Bridge module is a placeholder that will be used in future
  # versions of this plugin to allow authentication to use other sources.
  module Bridge
    ################################################################################
    # Returns an object that can be used to make backend requests.
    def self.backend
      Rauth::Source::Native
    end

    ################################################################################
    # Provides a way to create a backend accout and tie it to the given user
    # account model.
    def self.create_account (user_model, options={}, &block)
      creator = Rauth::AccountCreator.new(backend)
      creator.create(user_model, options, &block)
    end

    ################################################################################
    # Provides a way to destroy the user model and back_end account simultaneously
    def self.destroy_account (user_model, &block)
      begin
        ActiveRecord::Base.transaction do
          account = Rauth::Bridge.backend.find_by_user_name(user_model.user_name)
          account.destroy
          user_model.destroy
          yield(account) if block_given?
        end
      rescue Exception => e
        raise e
      end
    end

  end
end
################################################################################
