require 'rails_helper'

RSpec.describe Section, type: :model do
  describe 'validations' do
    subject { build(:section) }

    it { should validate_presence_of(:title) }
    it { should belong_to(:notebook) }
  end
end
