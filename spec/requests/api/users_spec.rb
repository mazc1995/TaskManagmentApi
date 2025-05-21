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

  describe "GET /show" do
    describe "returns a user" do
      it "returns a user" do
        user = create(:user)
        get "/api/users/#{user.id}"

        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)["email"]).to eq(user.email)
        expect(JSON.parse(response.body)["full_name"]).to eq(user.full_name)
        expect(JSON.parse(response.body)["role"]).to eq(user.role)
      end
    end
  end

  describe "POST /create" do
    describe "returns a new user" do
      it "creates a new user" do
        user_attributes = attributes_for(:user)
        post "/api/users", params: { user: user_attributes }
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)["email"]).to eq(user_attributes[:email])
        expect(JSON.parse(response.body)["full_name"]).to eq(user_attributes[:full_name])
        expect(JSON.parse(response.body)["role"]).to eq(user_attributes[:role].to_s)
      end
    end
  end
end
