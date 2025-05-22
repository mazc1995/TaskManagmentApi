require 'swagger_helper'

RSpec.describe 'API::Users', type: :request do
  let(:existing_user) { create(:user) }
  let(:credentials) { ActionController::HttpAuthentication::Basic.encode_credentials(existing_user.email, existing_user.password) }

  path '/api/users' do
    get 'Lista todos los usuarios' do
      tags 'Users'
      security [basic_auth: []]
      produces 'application/json'
      parameter name: :page, in: :query, type: :integer, required: false, description: 'Número de página'

      response '200', 'lista de usuarios' do
        let(:Authorization) { credentials }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to include('users', 'pagination')
          expect(data['users']).to be_an(Array)
          expect(data['pagination']).to include('page', 'items', 'count', 'pages')
        end
      end

      response '401', 'no autorizado' do
        let(:Authorization) { 'invalid' }
        run_test!
      end
    end

    post 'Crea un nuevo usuario' do
      tags 'Users'
      security [basic_auth: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: 'user@example.com' },
          full_name: { type: :string, example: 'John Doe' },
          role: { type: :string, enum: ['user', 'admin'], example: 'user' },
          password: { type: :string, example: 'password123' },
          password_confirmation: { type: :string, example: 'password123' }
        },
        required: ['email', 'full_name', 'role', 'password', 'password_confirmation']
      }

      response '201', 'usuario creado' do
        let(:Authorization) { credentials }
        let(:user) { { user: attributes_for(:user) } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['email']).to eq(user[:user][:email])
        end
      end

      response '401', 'no autorizado' do
        let(:Authorization) { 'invalid' }
        let(:user) { { user: attributes_for(:user) } }
        run_test!
      end

      response '422', 'entidad no procesable' do
        let(:Authorization) { credentials }
        let(:user) { { user: attributes_for(:user).except(:email) } }
        run_test!
      end
    end
  end

  path '/api/users/{id}' do
    get 'Obtiene un usuario específico' do
      tags 'Users'
      security [basic_auth: []]
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'usuario encontrado' do
        let(:Authorization) { credentials }
        let(:id) { existing_user.id }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['id']).to eq(existing_user.id)
        end
      end

      response '401', 'no autorizado' do
        let(:Authorization) { 'invalid' }
        let(:id) { existing_user.id }
        run_test!
      end

      response '404', 'usuario no encontrado' do
        let(:Authorization) { credentials }
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end 