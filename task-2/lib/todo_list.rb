class TodoList

  # Initialize the TodoList with +items+ (empty by default).
  def initialize(items=[])
    if items[:db].nil?
      raise IllegalArgument
    else
      @database = items[:db]
    end
  end

  def empty?
    @database.items_count == 0
  end
  
  def size
    @database.items_count
  end

  def <<(item)
    unless(item == nil or item[:title] == "" or item[:description] == "")
      @database.add_todo_item(item)
    end
  end

  def first
    if self.empty?
      nil
    else
      @database.get_todo_item(0)
    end
  end

  def toggle_state(index)
    if @database.get_todo_item(index).nil?
      nil
    elsif @database.todo_item_completed?(index) 
      @database.complete_todo_item(index, false)
    else
      @database.complete_todo_item(index, true)
    end
  end

  def last
#    @database.get_todo_item(self.size - 1)
    if self.empty?
      nil
    else
      @database.get_todo_item(self.size - 1)
    end
  end

   
end
