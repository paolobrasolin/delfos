# frozen_string_literal: true
class BasicObject
  def self.method_added(*args)
    nil
  end

  def self.singleton_method_added(*_args)
    nil
  end
end


