require 'helper'

class TestTdo < Test::Unit::TestCase
  
  should "read tasks" do
    clear_todo
    assert_equal Tdo.read_tasks, file_text
  end
  
  should "read tasks from specific group" do
    clear_todo
    assert_equal Tdo.read_tasks('@home'), "- Another group\n"
  end

  should "add new task" do
    clear_todo
    b = Tdo.read_tasks
    Tdo.add_task("Pick up milk")

    assert_equal Tdo.read_tasks.size, b.size + " - Pick up milk".size
  end
  
  should "add new task to group" do
    clear_todo
    Tdo.add_task('Pick up milk', '@test')
    
    assert_equal Tdo.read_tasks('@test').size, " - Pick up milk".size
  end
  
  should "mark task as done" do
    clear_todo
    b = Tdo.read_tasks('@ungrouped').strip
    Tdo.mark_done('A task', '@ungrouped')
    
    assert_equal Tdo.read_tasks('@ungrouped'), b + " #done\n"
  end
  
  should "mark task at index as done" do
    clear_todo
    b = Tdo.read_tasks( '@ungrouped').strip
    Tdo.mark_done(0, '@ungrouped')
    
    assert_equal Tdo.read_tasks('@ungrouped'), b + " #done\n"
  end
  
  should "remove all tasks marked done" do
    clear_todo
    Tdo.clear_done
    
    assert_equal Tdo.read_tasks('@group'), "- Another task\n"
  end
  
end
