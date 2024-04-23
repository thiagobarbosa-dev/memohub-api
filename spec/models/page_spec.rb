require 'rails_helper'

RSpec.describe Page, type: :model do
  describe 'validations' do
    subject { build(:page) }

    it { should belong_to(:section) }
  end
end
