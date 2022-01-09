# frozen_string_literal: true

require_relative 'purr/version'
require_relative 'purr/editor.rb'

require 'pry' # TODO

module Purr
  def self.title
    @title = edit(:title)
  end

  def self.body
    @body = edit(:body)
  end

  def self.assignee(assignee)
    @assignee = assignee
  end

  def self.self_assign
    assignee('@me')
  end

  private

  def edit(subject)
    editor = Editor.new(subject)

    catch(:abort) { yield(editor) }

    interrupt if editor.interrupted?

    editor.content
  end

  def interrupt
    puts 'aborted'
    exit
  end
end
