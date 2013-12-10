class Status < ActiveRecord::Base
  belongs_to :user

  validates :content, presence: true
  validates :content, length: {minimum: 2}
  validates :user_id, presence: true
end
