module Tdo

  class InvalidGroup < ArgumentError; end
  
  # If using ENV, path must be absolute
  TODO_FILE = (ENV['TDO_FILE'] ? File.expand_path(ENV['TDO_FILE']) : File.expand_path("~/.todo.txt"))
  
  
  # Gives a summary of remaining tasks
  #
  # @return [String] summary of tasks
  def self.summary
    t = Tasks.new.items
    groups = t.size-1
    tasks = t.inject(0) {|sum, t| sum += t[1].size}
    done = t.inject(0) {|sum, t| sum += t[1].delete_if {|i| !i.include? ' #done' }.size}
    "#{tasks} tasks in #{groups} groups, #{done} done"
  end
  
  # Takes the groups name from a string
  def self.get_group( str )
    if str[0] == '@'
      return str[1..-1]
    else
      return str
    end
  end
  
  
  class Tasks
    
    attr_accessor :items
    
    # Creates a new Tasks object and loads in the TODO_FILE
    def initialize
      @items = {'ungrouped' => []}
      self.read
    end
    
    # Reads TODO_FILE and converts it to a hash
    def read
      t = File.new(TODO_FILE, "r").read
      _group = ''
      t.split("\n").each do |l|
        if l[0] == '-'
          @items['ungrouped'] << l[1..-1].strip
        elsif l[0] == '@'
          _group = l[1..-1].strip
          @items[_group] = []
        elsif l[0..1] == ' -'
          @items[_group] << l[2..-1].strip
        end
      end
    end
    
    # Adds the task to the list
    #
    # @param [String] task to add
    # @param [String] group to add the task to
    # @return [Boolean] whether the task has been added successfully
    def add(task, group=nil)
      if group.nil?
        group = 'ungrouped'
      else
        group = Tdo.get_group(group)
      end
      
      if self.find(task, group)
        false
      else
        @items[group] ||= []
        @items[group] << task.strip
        self.write
        true
      end
    end
    
    # Marks the selected item as done
    #
    # @param [String, Integer] task to mark as done
    # @param [String] group that the task belongs to
    def mark_done(id, group=nil)
      unless group.nil?
        group = Tdo.get_group(group) 
        self.group?(group)
      end
      
      if id.is_a? Integer
        if group
          @items[group][id] += ' #done'
        else
          # should really count across groups, another time!
          @items['ungrouped'][id] += ' #done'
        end
      elsif id.is_a? String
        if group
          @items[group].collect! { |t| 
            t.include?(id) ? t += ' #done' : t
          }
        else
          # should test in every group as above
          @items['ungrouped'].collect! { |t| 
            t.include?(id) ? t += ' #done' : t
          }
        end
      else
        # error
        return false
      end
      self.write
      true
    end 
    
    # Deletes all tasks marked as done
    #
    # @return [Integer] number of tasks cleared
    def clear
      r = 0
      @items.each do |g, ts|
        s = ts.size
        ts.delete_if {|i| i.include?(' #done') }
        r += s - ts.size
      end
      @items.delete_if {|g, ts| ts == [] }
      self.write
      r
    end
    
    # Finds tasks which contain the string to look for
    #
    # @param [String] arg string to look for
    # @param [String] group to look within
    # @return [Array] found tasks
    # @todo find within group
    def find(str, group=nil)
      r = []
      @items.each do |g, ts|
        ts.each do |t|
          r << t if t.include?(str)
        end
      end
      if r == []
        false
      else
        r
      end
    end
    
    # Converts the tasks to a string which can then be written to a file
    #
    # @param [String] group
    # @return [String] string representation of tasks
    def to_s(group=nil)
      r = ''
      if group
        self.group?(group)
        group = Tdo.get_group(group)
        @items[group].each do |t|
          r += "- #{t}\n"
        end
      else
        @items.each do |g, ts|
          if g == 'ungrouped'
            ts.each do |t|
              r += "- #{t}\n"
            end
          else
            r += "\n@#{g}\n"
            ts.each do |t|
              r += " - #{t}\n"
            end
          end
        end
      end
      r
    end
    
    # Writes the tasks to a file
    def write
      File.open(TODO_FILE, "w") {|f| f.write( self.to_s )}
    end
    
    # Tests whether the group exists
    #
    # @param [String] group name
    # @return [Boolean] whether the group exists
    def group?( name )
      if self.items.has_key?( Tdo.get_group(name) )
        true
      else
        raise InvalidGroup, "'#{name}' is not a valid group name", caller
      end
    end
    
    # Override default insepct
    def inspect
      "#<Tdo::Tasks>"
    end
  
  end
  
  ##
  # These are a group of methods to make it easy to use the above class
  #
  def self.read_tasks(group=nil)
    Tdo::Tasks.new.to_s(group)
  end
  
  def self.mark_done(id, group=nil)
    Tdo::Tasks.new.mark_done(id, group)
  end
  
  def self.clear
    Tdo::Tasks.new.clear
  end
  
  def self.add(task, group=nil)
    Tdo::Tasks.new.add(task, group)
  end
  

end
