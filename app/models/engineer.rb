class Engineer < ApplicationRecord
  validates_presence_of :login

  has_one :user
end
