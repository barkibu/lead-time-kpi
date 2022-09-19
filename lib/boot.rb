# frozen_string_literal: true

require 'dotenv'
require 'octokit'
require 'active_support/core_ext/string/inflections'

begin
  require 'byebug'
rescue LoadError
end

Dotenv.load

require_relative './configuration'
require_relative './model'
require_relative './github_client'
require_relative './release_repository'
require_relative './commit_repository'
require_relative './pr_repository'
require_relative './markdown_events_table'
require_relative './get_lead_time_events'

class Hash
  def stringify_keys
    transform_keys(&:to_s)
  end
end
