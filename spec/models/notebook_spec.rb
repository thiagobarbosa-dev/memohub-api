require 'rails_helper'

RSpec.describe Notebook, type: :model do
  describe 'validations' do
    subject { build(:notebook) }

    it { should validate_presence_of(:title) }
    it { should belong_to(:user) }
  end
end
