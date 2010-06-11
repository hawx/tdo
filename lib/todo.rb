
module Todo

  TODO_FILE = File.expand_path "~/.todo.txt"
  
  def self.read_file
    f = File.new(TODO_FILE, "r")
    
    r = {'ungrouped' => []}
    last_group ||= ''
    f.each do |l|
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
  
  def self.add_task( task, group=nil )
    
  end
  
  def self.mark_done( id )
    
  end
  
  def self.delete_task( id )
  
  end
  
  def self.clear_done
  
  end

end


puts Todo.read_file