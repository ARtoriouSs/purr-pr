# frozen_string_literal: true

require_relative 'purr/version'
require_relative 'purr/editor.rb'

require 'pry' # TODO

module Purr
  def self.title
    editor = Editor.new(:title)

    catch(:abort) { yield(editor) }

    if editor.interrupted?
      puts 'aborted' # TODO
    end
  end
end
