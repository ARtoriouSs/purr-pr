# frozen_string_literal: true

require_relative 'purr_pr/version'
require_relative 'purr_pr/editor.rb'
require_relative 'purr_pr/config.rb'

require 'pry' # TODO

class PurrPr
  attr_reader :config_file_path, :config

  DEFAULT_CONFIG_FILE_PATH = 'purr.rb'

  def initialize(config_file_path = DEFAULT_CONFIG_FILE_PATH)
    @config_file_path = config_file_path
    @config = Config.new
  end

  def create
    config.instance_eval(config_code)
    # TODO - proxy other args + override existing
    system <<~SHELL
      gh pr create \
        --title #{config.title} \
        --body #{config.body} \
        --assignee #{config.assignee}
    SHELL
  end

  private

  def config_code
    File.read(config_file_path)
  end
end
