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
module Icons
  ################################################################################
  ICON_ATTRS = {
    :minus  => {:src => 'minus.gif',  :size => '14x14', :class => 'icon_link'},
    :plus   => {:src => 'plus.gif',   :size => '14x14', :class => 'icon_link'},
    :pencil => {:src => 'pencil.gif', :size => '18x18', :class => 'icon_link'},
  }

  ################################################################################
  module ExtensionMethods
    ################################################################################
    def icon_tag (icon)
      attributes = Icons::ICON_ATTRS[icon]
      image_tag(attributes[:src], :size => attributes[:size], :class => attributes[:class])
    end

    ################################################################################
    def icon_src (icon)
      Icons::ICON_ATTRS[icon][:src]
    end

    ################################################################################
    def icon_class (icon)
      Icons::ICON_ATTRS[icon][:class]
    end

    ################################################################################
    def icon_link (icon, options={}, html_options = {})
      attributes = Icons::ICON_ATTRS[icon]
      use_xhr = options.delete(:xhr) if options.is_a?(Hash)
      html_options[:class] ||= attributes[:class]      
      if use_xhr
        link_to_remote(icon_tag(icon), {:url => options}, html_options)
      else
        link_to(icon_tag(icon), options, html_options)
      end
    end

  end

  ################################################################################
  ActionController::Base.send(:include, Icons::ExtensionMethods)
  ActionView::Base.send(:include, Icons::ExtensionMethods)
end
################################################################################
