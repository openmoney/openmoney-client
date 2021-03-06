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
  # Code for dealing with the Rauth authorization system
  module Authorization

    ################################################################################
    # Class methods added to ActiveRecord:Base
    module ActiveRecordClassMethods
      ################################################################################
      def belongs_to_role (options={})
        require('rauth/role')
        require('rauth/permission')
        require('rauth/allowance')
        self.belongs_to(:role, options)
        self.has_many(:allowances,  :through => :role)
        self.has_many(:permissions, :through => :allowances)
        include(Rauth::Authorization::ActiveRecordInstanceMethods)
      end
    end

    ################################################################################
    # Instance methods added to your ActiveRecord::Base class.
    module ActiveRecordInstanceMethods
      ################################################################################
      # Lookup the given permission by name, and if it belongs to this user
      # through a role, return the matching allowance.  Otherwise, returns
      # nil.
      def authorize (permission_name)
        self.role ? self.role.authorize(permission_name) : false
      end

      ################################################################################
      # Returns true if the user has all the given permissions.
      def can? (*perms)
        self.role ? self.role.can?(*perms) : false
      end
    end

    ################################################################################
    # Class methods added ActionController::Base
    module ActionControllerClassMethods
      ################################################################################
      # Enable controller based authorizations
      def enable_authorization
        class_eval <<-EOT
          def self.require_authorization (*permissions)
            options = permissions.last.is_a?(Hash) ? permissions.pop : {}
            before_filter(options) {|c| c.instance_eval {authorize(*permissions)}}
          end
        EOT

        include(Rauth::Authorization::ActionControllerInstanceMethods)
      end
    end

    ################################################################################
    # Instance methods added to your controller when you use the
    # enable_authorization class method
    module ActionControllerInstanceMethods
      ################################################################################
      # Ensure that the current user has the given permissions.  Permissions
      # is a list of permission names that the current user must have.  The
      # last argument can be a hash with the following keys:
      #
      # * +:or_user_matches+: If set to a User object, return true if that user is the current user.
      # * +:condition+: Returns true if this key is the true value
      #
      # So, why call this method and use one of the options above?  Because
      # this method forces authentication and may be useful when called from
      # a controller action.
      #
      # There are two special instance methods that your controller can
      # implement as callbacks:
      #
      # * +unauthorized+: Called when authorization failed.  You can do
      #                   whatever you like here, redirect, render something,
      #                   set a flash message, it's up to you. If you don't
      #                   supply this method, an automatic redirection will
      #                   happen.
      #
      # * +check_allowance+: If you supply this method, the user and
      #                      allowance will be passed to it.  You should
      #                      explicitly return false if the user isn't
      #                      authroized to continue.
      ################################################################################
      def authorize (*permissions)
        return false unless user = authenticate

        configuration = {
          :or_user_matches => nil,
          :condition       => :pill,
        }

        configuration.update(permissions.last.is_a?(Hash) ? permissions.pop : {})
        return true if !configuration[:or_user_matches].nil? and user == configuration[:or_user_matches]
        return configuration[:condition] unless configuration[:condition] == :pill

        permissions.each do |name|
          if allowance = user.authorize(name) and respond_to?(:check_allowance)
            allowance = nil if check_allowance(user, allowance) == false
          end

          return rauth_failed_authorization if allowance.nil?
        end

        true
      end

      ################################################################################
      # Helper method called when authorization fails
      def rauth_failed_authorization
        unauthorized if respond_to?(:unauthorized)

        if !performed?
          redirect_to(request.env["HTTP_REFERER"] ? :back : home_url)
          return false
        end
      end
    end

  end
end
################################################################################
