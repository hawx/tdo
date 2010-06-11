
module Tdo

  TODO_FILE = File.expand_path "~/.todo.txt"
  
  # Reads the TODO file
  #
  # @param [String] group to read tasks from
  # @return [String] the tasks
  def self.read_tasks( group=nil )
    unless group
      File.new(TODO_FILE, "r").read
    else
      t = File.new(TODO_FILE, "r").read
      to_s( to_hash(t)[ group[1..-1] ] )
    end
  end
  
  # Allows you to add a new task to the file
  #
  # @param [String] task to add
  # @param [String] group to add the task to
  def self.add_task( task, group='ungrouped' )
    if File.exists? TODO_FILE
      t = to_hash( self.read_tasks ) 
    else
      t = {}
    end
    t[group] ||= [] # need to create new group if it doesn't exist
    t[group] << task.strip
    
    f = File.new(TODO_FILE, "w")
    f.puts to_s(t)
  end
  
  # Marks the selected item as done
  #
  # @param [String, Integer] task to mark as done
  # @param [String] group that the task belongs to
  def self.mark_done( id, group='ungrouped' )
    group = group[1..-1]
  
    t = to_hash( self.read_tasks )
    if id.is_a? String
      begin
        t[group].each_with_index do |task, i|
          if task.include? id
            t[group][i] += ' #done'
          end
        end
      rescue
        p "Group, #{group}, does not exist"
      end
    elsif id.is_a? Integer
      t[group][id] += ' #done'
    end
    
    f = File.new(TODO_FILE, "w")
    f.puts to_s(t)
  end
  
  # Deletes all items which have been marked done
  #
  def self.clear_done
    t = to_hash( self.read_tasks )
    t.each do |group, tasks|
      tasks.delete_if {|i| i.include? ' #done' }
    end
    
    f = File.new(TODO_FILE, "w")
    f.puts to_s(t)
  end
  
  
  # Converts the string read from the file to a hash so it can easily be used
  #
  # @param [String] read file string
  # @return [Hash] the string as a hash
  def self.to_hash( s )
    r = {'ungrouped' => []}
    last_group ||= ''
    s.split("\n").each do |l|
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
    if !hash.is_a? Hash
      hash = {'ungrouped' => hash}
    end
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
