class TaskRepository
  def initialize
    @model = Task
  end

  def all
    @model.all
  end

  def find(id)
    @model.find(id)
  end

  def create(attributes)
    @model.create(attributes)
  end

  def update(id, attributes)
    task = @model.find(id)
    task.update(attributes)
    task
  end

  def delete(id)
    @model.find(id).destroy
  end
end
