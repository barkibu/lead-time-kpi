# frozen_string_literal: true

require 'singleton'

class Configuration
  include Singleton

  def change_types
    ENV.fetch('CHANGE_TYPES', 'defect,tech_debt,feature').split(',')
  end

  def ignorable_change_types
    ENV.fetch('CHANGE_TYPES_IGNORED', 'translation,ignore-for-kpis').split(',')
  end

  def change_type_priority(base_type)
    change_types.find_index(base_type) || -1
  end

  def alias?(type)
    change_type_aliases.keys? type
  end

  def version_regexp
    Regexp.new ENV.fetch('VERSION_REGEXP', "\d+.\d+.\d+")
  end

  def default_change_type
    ENV.fetch('CHANGE_TYPE_DEFAULT', 'feature')
  end

  def project
    ENV.fetch('PROJECT_NAME')
  end

  def change_type_aliases
    @change_type_aliases ||= change_types.each_with_object({}) do |base_type, aliases|
      alias_key = "CHANGE_TYPE_#{base_type.upcase}_ALIASES"
      aliases[base_type] = base_type
      ENV.fetch(alias_key, '').split(',').each do |type_alias|
        aliases[type_alias] = base_type
      end
    end
  end

  def github_access_token
    ENV['GITHUB_ACCESS_TOKEN']
  end
end
