class Notebook < ApplicationRecord
  belongs_to :user
  has_many :sections, dependent: :destroy
  validates :title, presence: true
end
