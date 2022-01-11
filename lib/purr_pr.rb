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

    command = 'gh pr create'
    command += " --title '#{config.values.title}'" if config.values.title
    command += " --body '#{config.values.body}'"
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

    # The later arguments will override the earlier ones,
    # e.g. after `gh pr create --title a --title b` the title will equal 'b',
    # so explicit options will override the config
    command += ARGV.join(' ').prepend(' ')

    system(command)
  end

  private

  def config_code
    File.read(config_file_path)
  end
end
