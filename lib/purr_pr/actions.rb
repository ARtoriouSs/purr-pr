# frozen_string_literal: true

require 'io/console'

module PurrPr
  module Actions
    def ask(message, default: nil, multiline: false, newline: true)
      puts(message)

      text = input(multiline: multiline)

      return default if text.empty?

      newline ? text + "\n" : text
    end

    def ask_yn(message, confirm: -> {}, decline: -> {})
      puts(message)

      callback = STDIN.getch.downcase == 'y' ? confirm : decline
      callback.call
    end

    def read_file(path)
      File.read(path)
    end

    def finish
      throw(:abort)
    end

    def interrupt
      @interrupted = true
      throw(:abort)
    end

    def interrupted?
      @interrupted
    end

    private

    def input(multiline: false)
      # multiline input until empty line entered
      separator = multiline ? "\n\n" : "\n"
      gets(separator).chomp(separator)
    end
  end
end
