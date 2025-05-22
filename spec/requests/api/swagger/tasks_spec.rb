require 'swagger_helper'

RSpec.describe 'API::Tasks', type: :request do
  let(:user) { create(:user) }
  let(:existing_task) { create(:task, user: user) }
  let(:credentials) { ActionController::HttpAuthentication::Basic.encode_credentials(user.email, user.password) }

  path '/api/tasks' do
    get 'Lista todas las tareas' do
      tags 'Tasks'
      security [basic_auth: []]
      produces 'application/json'
      parameter name: :page, in: :query, type: :integer, required: false, description: 'Número de página'

      response '200', 'lista de tareas' do
        let(:Authorization) { credentials }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to include('tasks', 'pagination')
          expect(data['tasks']).to be_an(Array)
          expect(data['pagination']).to include('page', 'items', 'count', 'pages')
        end
      end

      response '401', 'no autorizado' do
        let(:Authorization) { 'invalid' }
        run_test!
      end
    end

    post 'Crea una nueva tarea' do
      tags 'Tasks'
      security [basic_auth: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :task, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string, example: 'Mi tarea' },
          description: { type: :string, example: 'Descripción de la tarea' },
          status: { type: :string, enum: ['pending', 'in_progress', 'completed'], example: 'pending' },
          due_date: { type: :string, format: 'date', example: '2024-12-31' },
          user_id: { type: :integer, example: 1 }
        },
        required: ['title', 'description', 'status', 'due_date', 'user_id']
      }

      response '201', 'tarea creada' do
        let(:Authorization) { credentials }
        let(:task) { { task: attributes_for(:task, user_id: user.id) } }
        run_test!
      end

      response '401', 'no autorizado' do
        let(:Authorization) { 'invalid' }
        let(:task) { { task: attributes_for(:task, user_id: user.id) } }
        run_test!
      end

      response '422', 'entidad no procesable' do
        let(:Authorization) { credentials }
        let(:task) { { task: attributes_for(:task, user_id: user.id).except(:title) } }
        run_test!
      end
    end
  end

  path '/api/tasks/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Obtiene una tarea específica' do
      tags 'Tasks'
      security [basic_auth: []]
      produces 'application/json'

      response '200', 'tarea encontrada' do
        let(:Authorization) { credentials }
        let(:id) { existing_task.id }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['id']).to eq(existing_task.id)
        end
      end

      response '401', 'no autorizado' do
        let(:Authorization) { 'invalid' }
        let(:id) { existing_task.id }
        run_test!
      end

      response '404', 'tarea no encontrada' do
        let(:Authorization) { credentials }
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put 'Actualiza una tarea' do
      tags 'Tasks'
      security [basic_auth: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :task, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string, example: 'Mi tarea actualizada' },
          description: { type: :string, example: 'Nueva descripción' },
          status: { type: :string, enum: ['pending', 'in_progress', 'completed'], example: 'in_progress' },
          due_date: { type: :string, format: 'date', example: '2024-12-31' }
        }
      }

      response '200', 'tarea actualizada' do
        let(:Authorization) { credentials }
        let(:id) { existing_task.id }
        let(:task) { { task: { title: 'Updated Title', description: 'Updated description' } } }
        run_test!
      end

      response '401', 'no autorizado' do
        let(:Authorization) { 'invalid' }
        let(:id) { existing_task.id }
        let(:task) { { task: { title: 'Updated Title' } } }
        run_test!
      end

      response '404', 'tarea no encontrada' do
        let(:Authorization) { credentials }
        let(:id) { 'invalid' }
        let(:task) { { task: { title: 'Updated Title' } } }
        run_test!
      end
    end

    delete 'Elimina una tarea' do
      tags 'Tasks'
      security [basic_auth: []]

      response '204', 'tarea eliminada' do
        let(:Authorization) { credentials }
        let(:id) { existing_task.id }
        run_test!
      end

      response '401', 'no autorizado' do
        let(:Authorization) { 'invalid' }
        let(:id) { existing_task.id }
        run_test!
      end

      response '404', 'tarea no encontrada' do
        let(:Authorization) { credentials }
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end 