# frozen_string_literal: true

class User < Base
  def validate
    super
    validates_presence :username
    validates_unique :username
  end
end
