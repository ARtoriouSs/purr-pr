# frozen_string_literal: true

require 'securerandom'
require 'tempfile'

require_relative 'text_objects'
require_relative 'actions'
require_relative 'shell_helpers'

class PurrPr
  class Editor
    include TextObjects
    include Actions
    include ShellHelpers

    attr_reader :content, :subject

    def initialize(subject, content: '')
      @subject = subject.to_s
      @content = content
    end

    def evaluate(&block)
      @caller_binding = eval('self', block.binding)
      instance_eval(&block)
    end

    def method_missing(method, *args, &block)
      @caller_binding.send(method, *args, &block)
    end

    def append(text)
      @content += text
    end

    def prepend(text)
      @content = text + @content
    end

    def replace(text, with: '')
      @content.gsub!(text, with)
    end

    def delete(text)
      replace(text, with: '')
    end

    def clear
      @content = ''
    end

    def edit(format: :md)
      name = subject + SecureRandom.hex(8)
      format = ".#{format}" unless format.nil?

      file = Tempfile.new([name, format])
      file.write(content)
      file.rewind

      editor = `echo $VISUAL`.chomp || `echo $EDITOR`.chomp || 'vim'

      system("#{editor} #{file.path}")

      @content = file.read
    ensure
      file.close
    end
    alias_method :editor, :edit

    def confirm
      text = <<~TEXT
        Current #{subject}:

        #{content}

        Continue? (Y/N)
      TEXT

      ask_yn(text, decline: -> { interrupt })
    end
    alias_method :confirmation, :confirm

    def use_template(path = '.github/pull_request_template.md')
      @content = read_file(path)
    end
  end
end
