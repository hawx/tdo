require 'rubygems'
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'tdo'

class Test::Unit::TestCase
  def file_text
    r = <<EOS
- A task

@group
 - Another task
 - A done task #done

@home
 - Another group
EOS
  end
  
  def clear_todo
    f = File.new(Tdo::TODO_FILE, "w")
    f.puts file_text
    f.close
  end
end

module Tdo
  TODO_FILE = File.join( File.dirname(__FILE__), "todo.txt" )
end