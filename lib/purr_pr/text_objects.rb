# frozen_string_literal: true

class PurrPr
  module TextObjects
    def newline(count = 1)
      "\n" * count
    end

    def space(count = 1)
      ' ' * count
    end
  end
end
