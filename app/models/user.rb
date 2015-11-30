class User < ActiveRecord::Base
  has_many :questions
  has_many :answers
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def author_of?(entity)
    self.id == entity.user_id
  end

  def is_author_of!(entity)
    entity.user_id = self.id

  end
  def to_s
    "#{self.class}"
  end
end
