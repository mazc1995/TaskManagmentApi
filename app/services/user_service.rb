class UserService
  include Pagy::Backend

  attr_reader :repository
  
  def initialize
    @repository = UserRepository.new
  end

  def list_users
    users = @repository.all
    users
  end

  def find_user(id)
    @repository.find(id)
  end

  def create_user(attributes)
    @repository.create(attributes)
  end
end
