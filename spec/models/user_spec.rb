require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:full_name) }
  it { should validate_presence_of(:role) }

  it { should validate_uniqueness_of(:email).case_insensitive }

  it { should have_many(:tasks).dependent(:destroy) }
  
end
