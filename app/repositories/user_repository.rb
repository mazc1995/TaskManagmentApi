class UserRepository
  def initialize
    @model = User
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
end
