class Section < ApplicationRecord
  belongs_to :notebook
  has_many :pages, dependent: :destroy
end
