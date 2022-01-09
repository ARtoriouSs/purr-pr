# frozen_string_literal: true

require_relative 'purr_pr/version'
require_relative 'purr_pr/editor.rb'

require 'pry' # TODO

module PurrPr
  def self.title(&block)
    @title = edit(:title, &block)
  end

  def self.body(&block)
    @body = edit(:body, &block)
  end

  def self.assignee(assignee)
    @assignee = assignee
  end

  def self.self_assign
    assignee('@me')
  end

  private

  def edit(subject, &block)
    editor = Editor.new(subject)

    catch(:abort) { editor.evaluate(&block) }

    interrupt if editor.interrupted?

    editor.content
  end

  def interrupt
    puts 'aborted'
    exit
  end
end
