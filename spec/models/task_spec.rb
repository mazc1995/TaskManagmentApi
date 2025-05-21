require 'rails_helper'

RSpec.describe Task, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:status) }
  it { should validate_presence_of(:due_date) }

  it { should belong_to(:user) }

  it { should validate_presence_of(:user) }
  
end
