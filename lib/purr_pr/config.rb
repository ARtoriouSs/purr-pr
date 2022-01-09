# frozen_string_literal: true

require_relative 'editor.rb'

class PurrPr
  class Config
    attr_reader :title, :body, :assignee

    def title(&block)
      @title = edit(:title, &block)
    end

    def body(&block)
      @body = edit(:body, &block)
    end

    def assignee(assignee)
      @assignee = assignee
    end

    def self_assign
      assignee('@me')
    end

    def values
      OpenStruct.new(
        title:    @title,
        body:     @body,
        assignee: @assignee
      )
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
end
