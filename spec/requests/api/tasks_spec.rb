require 'rails_helper'

RSpec.describe "Api::Tasks", type: :request do
  describe "GET /index" do
    describe "returns a list of tasks" do
      it "returns a list of tasks" do
        create_list(:task, 3)
        get "/api/tasks"
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body).size).to eq(3)
      end
    end
  end

  describe "GET /show" do
    describe "returns a task" do
      it "returns a task" do
        task = create(:task)
        get "/api/tasks/#{task.id}"
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)["title"]).to eq(task.title)
        expect(JSON.parse(response.body)["description"]).to eq(task.description)
        expect(JSON.parse(response.body)["status"]).to eq(task.status)
        expect(JSON.parse(response.body)["due_date"]).to eq(task.due_date.strftime('%a, %d %b %Y'))
      end
    end
  end

  describe "POST /create" do
    describe "returns a new task" do
      it "creates a new task" do
        user = create(:user)
        task_attributes = attributes_for(:task, user_id: user.id)
        post "/api/tasks", params: { task: task_attributes }
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)["title"]).to eq(task_attributes[:title])
        expect(JSON.parse(response.body)["description"]).to eq(task_attributes[:description])
        expect(JSON.parse(response.body)["status"]).to eq(task_attributes[:status].to_s)
        expect(JSON.parse(response.body)["due_date"]).to eq(task_attributes[:due_date].strftime('%a, %d %b %Y'))
      end
    end
  end

  describe "PUT /update" do
    describe "returns a updated task" do
      it "updates a task" do
        task = create(:task)
        new_attributes = attributes_for(:task)
        put "/api/tasks/#{task.id}", params: { task: new_attributes }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["title"]).to eq(new_attributes[:title])
        expect(JSON.parse(response.body)["description"]).to eq(new_attributes[:description])
        expect(JSON.parse(response.body)["status"]).to eq(new_attributes[:status].to_s)
        expect(JSON.parse(response.body)["due_date"]).to eq(new_attributes[:due_date].strftime('%a, %d %b %Y'))
      end
    end
  end

  describe "DELETE /destroy" do
    describe "returns a deleted task" do
      it "deletes a task" do
        task = create(:task)
        delete "/api/tasks/#{task.id}"
        expect(response).to have_http_status(:no_content)
      end
    end
  end
end