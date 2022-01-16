# frozen_string_literal: true

require 'ostruct'

require_relative 'editor.rb'

class PurrPr
  class Config
    attr_reader :title, :body, :assignee

    def initialize
      # defaults - if setter is not called
      @maintainer_edit = true
      @reviewers = []
      @labels = []
    end

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

    def maintainer_edit(enabled)
      @maintainer_edit = enabled
    end

    def no_maintainer_edit
      maintainer_edit(false)
    end

    def base(base_branch)
      @base = base_branch
    end

    def draft(enabled = true)
      @draft = enabled
    end

    def labels(labels)
      @labels += labels
    end

    def label(label)
      @labels << label
    end

    def reviewers(reviewers)
      @reviewers += reviewers
    end

    def reviewer(reviewer)
      @reviewers << reviewer
    end

    def values
      OpenStruct.new(
        title:           @title,
        body:            @body,
        assignee:        @assignee,
        base:            @base,
        draft:           @draft,
        reviewers:       @reviewers,
        labels:          @labels,
        maintainer_edit: @maintainer_edit
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
