# frozen_string_literal: true

require_relative 'purr_pr/version'
require_relative 'purr_pr/editor'
require_relative 'purr_pr/config'

require 'tempfile'

class PurrPr
  attr_reader :config_file_path, :config

  DEFAULT_CONFIG_FILE_PATH = 'purr.rb'

  def initialize(config_file_path = DEFAULT_CONFIG_FILE_PATH)
    @config_file_path = config_file_path
    @config = Config.new(ARGV)
  end

  def create
    config.instance_eval(config_code)

    # use file for body to avoid quotes issues
    body_file = Tempfile.new
    body_file.write(config.values.body)
    body_file.rewind

    command = 'gh pr create'
    command += " --title '#{config.values.title}'" if config.values.title
    command += " --body-file '#{body_file.path}'"
    command += " --assignee #{config.values.assignee}" if config.values.assignee
    command += " --base #{config.values.base}" if config.values.base
    command += ' --draft' if config.values.draft
    command += ' --no-maintainer-edit' unless config.values.maintainer_edit

    config.values.labels.each do |label|
      command += " --label #{label}"
    end

    config.values.reviewers.each do |reviewer|
      command += " --reviewer #{reviewer}"
    end

    system(command)
  ensure
    body_file.close
  end

  private

  def config_code
    File.read(config_file_path)
  end
end
