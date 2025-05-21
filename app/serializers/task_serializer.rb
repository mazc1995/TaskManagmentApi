class TaskSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :status, :due_date

  belongs_to :user

  def due_date
    object.due_date.strftime('%a, %d %b %Y') if object.due_date
  end
end
