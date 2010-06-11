
module Todo

  TODO_FILE = File.expand_path "~/.todo.txt"
  
  # Reads the TODO file
  def self.read_tasks
    File.new(TODO_FILE, "r").read
  end
  
  # Allows you to add a new task to the file
  #
  # @param [String] task to add
  # @param [String] group to add the task to
  def self.add_task( task, group='ungrouped' )
    t = to_hash( self.read_tasks )
    t[group] ||= [] # need to create new group if it doesn't exist
    t[group] << task.strip
    
    f = File.new(TODO_FILE, "w")
    f.puts to_s(t)
  end
  
  def self.mark_done( id )
    
  end
  
  def self.delete_task( id )
  
  end
  
  def self.clear_done
  
  end
  
  
  # Converts the string read from the file to a hash so it can easily be used
  #
  # @param [String] read file string
  # @return [Hash] the string as a hash
  def self.to_hash( s )
    r = {'ungrouped' => []}
    last_group ||= ''
    s.each do |l|
      if l[0] == '@'
        last_group = l[1..-1].strip
        r[last_group] = []
      elsif l[1] == '-'
        r[last_group] << l[2..-1].strip
      elsif l[0] == '-'
        r['ungrouped']  << l[1..-1].strip
      end
    end
    r
  end
  
  # Converts the given hash to a string which can then be written to a file
  #
  # @param [Hash] hash of todo tasks
  # @return [String] string representation of hash
  def self.to_s( hash )
    r = ""
    hash.each do |group, tasks|
      if group == 'ungrouped'
        tasks.each do |task|
          r += "- #{task}\n"
        end
      else
        r += "\n@#{group}\n"
        tasks.each do |task|
          r += " - #{task}\n"
        end
      end
    end
    r
  end

end

puts Todo.read_tasks
#Todo.add_task("a new task")