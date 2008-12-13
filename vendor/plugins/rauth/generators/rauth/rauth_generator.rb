################################################################################
#
# Copyright (C) 2007 pmade inc. (Peter Jones pjones@pmade.com)
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
class RauthGenerator < Rails::Generator::Base
  ################################################################################
  def initialize (runtime_args, runtime_options={})
    super

    @with_authorization = true
  end

  ################################################################################
  def manifest
    @migrations = []

    Dir.foreach(File.dirname(__FILE__) + '/templates') do |file|
      next unless file.match(/^\d+_/)
      next if !@with_authorization and file.match(/authorization/)
      @migrations << file
    end

    record do |m|
      m.directory('app/views/sessions')
      m.file('sessions_new.rhtml', 'app/views/sessions/new.rhtml')

      @migrations.sort.each do |f|
        m.migration_template(f, 'db/migrate', {
          :assigns => {:migration_name => f.sub(/^\d+_/, '').camelize}, 
          :migration_file_name => f.sub(/^\d+_/, '').sub(/\.rb$/, ''),
        })
      end
    end
  end

end
################################################################################
