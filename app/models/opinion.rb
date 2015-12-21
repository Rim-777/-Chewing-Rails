class Opinion < ActiveRecord::Base

  belongs_to :user
  belongs_to :opinionable, polymorphic: true
  validates :value, presence: true
  validates :user_id, uniqueness: { scope: [:opinionable_type, :opinionable_id] }
  scope :rating,    -> { sum(:value)}

 def is_changed?(value)
   self.value != value
 end
end