# frozen_string_literal: true

class MarkdownEventsTable
  attr_reader :events

  def initialize(events)
    @events = events
  end

  def render
    header + events.map(&method(:content_for)).join("\n")
  end

  private

  def header
    "| Date | Name | Project | Value | Payload |\n|-|-|-|-|-|\n"
  end

  def content_for(event)
    "| #{event.date.strftime('%d/%m/%Y')} | #{event.name} | #{event.project} | #{event.value} | #{event.payload&.to_json} |"
  end
end
