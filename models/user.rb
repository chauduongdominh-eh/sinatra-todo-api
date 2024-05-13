# frozen_string_literal: true

class User < Base
  one_to_many :notes

  def validate
    super
    validates_presence :username
    validates_unique :username
  end
end
