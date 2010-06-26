module Tdo

  class InvalidGroup < ArgumentError; end

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
      raise InvalidGroup, "'#{group}' is not a valid group name", caller unless self.group?(group) 
      to_s( to_hash(t)[ group[1..-1] ] )
    end
  end
  
  # Gives a summary of remaining tasks
  #
  # @return [String] summary of tasks
  def self.task_summary
    t = to_hash( self.read_tasks )
    groups = t.size
    tasks = t.inject(0) {|sum, t| sum += t[1].size}
    done = t.inject(0) {|sum, t| sum += t[1].delete_if {|i| !i.include? ' #done' }.size}
    "#{tasks} tasks in #{groups} groups, #{done} done"
  end
  
  # Allows you to add a new task to the file
  #
  # @param [String] task to add
  # @param [String] group to add the task to
  def self.add_task( task, group='@ungrouped' )
    if File.exists? TODO_FILE
      t = to_hash( self.read_tasks ) 
    else
      t = {}
    end
    if group[0] == "@"
      group = group[1..-1] 
    else
      raise InvalidGroup, "'#{group}' is not a valid group name", caller
    end
    t[group] ||= [] # need to create new group if it doesn't exist
    t[group] << task.strip
    
    write_hash t
  end
  
  # Marks the selected item as done
  #
  # @param [String, Integer] task to mark as done
  # @param [String] group that the task belongs to
  def self.mark_done( id, group='@ungrouped' )
    if group[0] == "@"
      group = group[1..-1] 
    else
      raise InvalidGroup, "'#{group}' is not a valid group name", caller
    end
  
    t = to_hash( self.read_tasks )
    if id.is_a? String      
      t[group].each_with_index do |task, i|
        if task.include? id
          t[group][i] += ' #done'
        end
      end
    elsif id.is_a? Integer
      t[group][id] += ' #done'
    end
    write_hash t
  end
  
  
  # Deletes all items which have been marked done
  #
  # @return [Integer] number of tasks cleared
  def self.clear_done
    t = to_hash( self.read_tasks )
    r = 0
    t.each do |group, tasks|
      s = tasks.size
      r += tasks.delete_if {|i| i.include? ' #done' }.size - s
    end
    t.delete_if {|k, v| v == [] }
    write_hash t
    r
  end
  
  # Converts the given hash to a string and writes to the TODO_FILE
  #
  # @param [Hash] tasks hash to write
  def self.write_hash( hash )
    File.open(TODO_FILE, "w") {|f| f.write( to_s(hash) )}
  end
  
  
  # Tests whether the group exists
  #
  # @param [String] group name
  # @return [Boolean] whether the group exists
  def self.group?( name )
    t = to_hash( self.read_tasks )
    t.has_key?(name[1..-1])
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
