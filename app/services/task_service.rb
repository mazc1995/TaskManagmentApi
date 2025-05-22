class TaskService
  include Pagy::Backend

  attr_reader :repository
  
  def initialize
    @repository = TaskRepository.new
  end

  def list_tasks
    tasks = @repository.all
    tasks
  end

  def find_task(id)
    @repository.find(id)
  end

  def create_task(attributes)
    @repository.create(attributes)
  end

  def update_task(id, attributes)
    @repository.update(id, attributes)
  end

  def delete_task(id)
    @repository.delete(id)
  end
end
