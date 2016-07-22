class Board < ActiveRecord::Base
  belongs_to :user
  has_many :pinnings
  has_many :pins, through: :pinnings
end
