User.create(email: 'admin@example.com', full_name: 'Admin User', role: :admin, password: 'password', password_confirmation: 'password')

Task.create(title: 'Task 1', description: 'Task 1 description', status: :pending, due_date: Date.today + 1.day, user_id: User.first.id)
Task.create(title: 'Task 2', description: 'Task 2 description', status: :in_progress, due_date: Date.today + 2.days, user_id: User.first.id)
Task.create(title: 'Task 3', description: 'Task 3 description', status: :completed, due_date: Date.today + 3.days, user_id: User.first.id)

User.create(email: 'user@example.com', full_name: 'User User', role: :user, password: 'password', password_confirmation: 'password')
Task.create(title: 'Task 1', description: 'Task 1 description', status: :pending, due_date: Date.today + 1.day, user_id: User.last.id)
Task.create(title: 'Task 2', description: 'Task 2 description', status: :in_progress, due_date: Date.today + 2.days, user_id: User.last.id)
Task.create(title: 'Task 3', description: 'Task 3 description', status: :completed, due_date: Date.today + 3.days, user_id: User.last.id)
