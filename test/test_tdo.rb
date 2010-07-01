require 'helper'

class TestTdo < Test::Unit::TestCase

  should "read tasks" do
    clear_todo
    t = Tdo::Tasks.new
    assert_equal t.to_s, file_text
  end
  
  should "read tasks from specific group" do
    clear_todo
    assert_equal "- Another group\n", Tdo::Tasks.new.to_s('@home')
  end

  should "add new task" do
    clear_todo
    t = Tdo::Tasks.new
    b = t.to_s
    t.add("Pick up milk")
    
    assert_equal b.size + " - Pick up milk".size, t.to_s.size
  end
  
  should "add new task to group" do
    clear_todo
    t = Tdo::Tasks.new
    t.add('Pick up milk', '@test')
    
    assert_equal " - Pick up milk".size, t.to_s('@test').size
  end
  
  should "mark task as done" do
    clear_todo
    t = Tdo::Tasks.new
    b = t.to_s('@ungrouped').strip
    t.mark_done('A task', '@ungrouped')
    
    assert_equal b + " #done\n", t.to_s('@ungrouped')
  end
  
  should "mark task at index as done" do
    clear_todo
    t = Tdo::Tasks.new
    b = t.to_s('@ungrouped').strip
    t.mark_done(0, '@ungrouped')
    
    assert_equal b + " #done\n", t.to_s('@ungrouped')
  end
  
  should "remove all tasks marked done" do
    clear_todo
    t = Tdo::Tasks.new
    t.clear
    
    assert_equal "- Another task\n", t.to_s('@group')
  end
  
  should "remove group when all tasks are cleared" do
    clear_todo
    t = Tdo::Tasks.new
    t.mark_done(0, '@home')
    t.clear
    
    assert_raise Tdo::InvalidGroup do
      t.to_s('@home') 
    end
  end

end
