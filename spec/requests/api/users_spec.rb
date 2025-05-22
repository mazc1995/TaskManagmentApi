require 'rails_helper'

RSpec.describe "Api::Users", type: :request do
  let(:user) { create(:user) }

  describe "GET /index" do
    context "when authenticated" do
      it "returns a paginated list of users" do
        create_list(:user, 15)
        get "/api/users", headers: auth_headers(user)
        expect(response).to have_http_status(:success)
        
        json_response = JSON.parse(response.body)
        expect(json_response).to include('users', 'pagination')
        expect(json_response['users'].size).to eq(10) # Default page size
        
        # Verify pagination metadata
        expect(json_response['pagination']).to include(
          'page',
          'items',
          'count',
          'pages'
        )
        expect(json_response['pagination']['count']).to eq(16) # 15 created + 1 authenticated user
        expect(json_response['pagination']['pages']).to eq(2)
      end

      it "returns the second page of users" do
        create_list(:user, 15)
        get "/api/users", params: { page: 2 }, headers: auth_headers(user)
        expect(response).to have_http_status(:success)
        
        json_response = JSON.parse(response.body)
        expect(json_response['users'].size).to eq(6) # Remaining items on second page (5 + authenticated user)
        expect(json_response['pagination']['page']).to eq(2)
      end
    end

    context "when not authenticated" do
      it "returns unauthorized" do
        get "/api/users"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET /show" do
    context "when authenticated" do
      it "returns a user" do
        get "/api/users/#{user.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)["email"]).to eq(user.email)
        expect(JSON.parse(response.body)["full_name"]).to eq(user.full_name)
        expect(JSON.parse(response.body)["role"]).to eq(user.role)
      end
    end

    context "when not authenticated" do
      it "returns unauthorized" do
        get "/api/users/#{user.id}"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "POST /create" do
    let(:user_attributes) { attributes_for(:user, email: 'new_user@example.com') }

    context "when authenticated" do
      it "creates a new user" do
        post "/api/users", params: { user: user_attributes }, headers: auth_headers(user)
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)["email"]).to eq(user_attributes[:email])
        expect(JSON.parse(response.body)["full_name"]).to eq(user_attributes[:full_name])
        expect(JSON.parse(response.body)["role"]).to eq(user_attributes[:role].to_s)
      end
    end

    context "when not authenticated" do
      it "returns unauthorized" do
        post "/api/users", params: { user: user_attributes }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
