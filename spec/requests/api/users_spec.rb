require 'rails_helper'

RSpec.describe "Api::Users", type: :request do
  describe "GET /index" do
    describe "returns a list of users" do
      it "returns a list of users" do
        create_list(:user, 3)
        get "/api/users"
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body).size).to eq(3)
      end
    end
  end

  describe "POST /create" do
    describe "returns a new user" do
      it "creates a new user" do
        post "/api/users", params: { user: attributes_for(:user) }
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)["email"]).to eq(attributes_for(:user)[:email])
        expect(JSON.parse(response.body)["full_name"]).to eq(attributes_for(:user)[:full_name])
        expect(JSON.parse(response.body)["role"]).to eq(attributes_for(:user)[:role])
      end
    end
  end
end
