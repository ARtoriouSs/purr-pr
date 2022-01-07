require 'securerandom'

module Purr
  class Editor
    attr_reader :content, :subject

    def initialize(subject)
      @subject = subject.to_s
      @content = ''
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

    #def newline
      #@content += "\n"
    #end

    #def ask(message, default: nil)
      #puts(message)
      #input = gets.strip
    #end

    def editor
      file = Tempfile.new(subject + SecureRandom.hex(8))
      file.write(content)
      file.rewind

      system("$VISUAL #{file.path}") # TODO - $EDITOR

      @content = file.read
    ensure
      file.close
    end
    alias_method :edit, :editor

    def confirm
      print <<-TEXT
        Current #{subject}:

        #{content}

        Continue? (Y/N)
      TEXT

      throw(:abort, true) unless gets.strip.downcase == 'y'
    end
    alias_method :confirmation, :confirm
  end
end
