# frozen_string_literal: true

class PurrPr
  module ShellHelpers
    def commits
      `git log --pretty=%B`.split("\n\n").reverse
    end

    def current_branch
      `git branch --show-current`.chomp
    end
  end
end
