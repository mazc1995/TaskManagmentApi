require 'rails_helper'

RSpec.describe "Api::Tasks", type: :request do
  let(:user) { create(:user) }
  let(:task) { create(:task, user: user) }

  describe "GET /index" do
    context "when authenticated" do
      it "returns a list of tasks" do
        create_list(:task, 3, user: user)
        get "/api/tasks", headers: auth_headers(user)
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body).size).to eq(3)
      end
    end

    context "when not authenticated" do
      it "returns unauthorized" do
        get "/api/tasks"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET /show" do
    context "when authenticated" do
      it "returns a task" do
        get "/api/tasks/#{task.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)["title"]).to eq(task.title)
        expect(JSON.parse(response.body)["description"]).to eq(task.description)
        expect(JSON.parse(response.body)["status"]).to eq(task.status)
        expect(JSON.parse(response.body)["due_date"]).to eq(task.due_date.strftime('%a, %d %b %Y'))
      end
    end

    context "when not authenticated" do
      it "returns unauthorized" do
        get "/api/tasks/#{task.id}"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "POST /create" do
    let(:task_attributes) { attributes_for(:task, user_id: user.id) }

    context "when authenticated" do
      it "creates a new task" do
        post "/api/tasks", params: { task: task_attributes }, headers: auth_headers(user)
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)["title"]).to eq(task_attributes[:title])
        expect(JSON.parse(response.body)["description"]).to eq(task_attributes[:description])
        expect(JSON.parse(response.body)["status"]).to eq(task_attributes[:status].to_s)
        expect(JSON.parse(response.body)["due_date"]).to eq(task_attributes[:due_date].strftime('%a, %d %b %Y'))
      end
    end

    context "when not authenticated" do
      it "returns unauthorized" do
        post "/api/tasks", params: { task: task_attributes }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "PUT /update" do
    let(:new_attributes) { attributes_for(:task) }

    context "when authenticated" do
      it "updates a task" do
        put "/api/tasks/#{task.id}", params: { task: new_attributes }, headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["title"]).to eq(new_attributes[:title])
        expect(JSON.parse(response.body)["description"]).to eq(new_attributes[:description])
        expect(JSON.parse(response.body)["status"]).to eq(new_attributes[:status].to_s)
        expect(JSON.parse(response.body)["due_date"]).to eq(new_attributes[:due_date].strftime('%a, %d %b %Y'))
      end
    end

    context "when not authenticated" do
      it "returns unauthorized" do
        put "/api/tasks/#{task.id}", params: { task: new_attributes }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /destroy" do
    context "when authenticated" do
      it "deletes a task" do
        delete "/api/tasks/#{task.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:no_content)
      end
    end

    context "when not authenticated" do
      it "returns unauthorized" do
        delete "/api/tasks/#{task.id}"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end