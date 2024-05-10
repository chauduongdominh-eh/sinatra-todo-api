# frozen_string_literal: true

class Note < Base
  def validate
    super
    validates_presence :content
  end
end
