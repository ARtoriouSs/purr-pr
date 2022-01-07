# frozen_string_literal: true

require_relative 'purr/version'
require_relative 'purr/editor.rb'

require 'pry' # TODO

module Purr
  def self.title
    should_abort = catch(:abort) do
      editor = Editor.new(:title)
      yield(editor)
    end

    if should_abort
      puts 'aborted' # TODO
    end
  end
end
