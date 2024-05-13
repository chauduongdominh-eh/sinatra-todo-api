# frozen_string_literal: true

class Note < Base
  many_to_one :user

  def validate
    super
    validates_presence :content
  end
end
