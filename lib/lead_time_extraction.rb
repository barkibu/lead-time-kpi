# frozen_string_literal: true

require_relative './boot'

REPO = ARGV[0]
VERSION = ARGV[1]
FROM_VERSION = ARGV[2]

RELEASE_NOTES_HEADER = "===== KPI events to add to the AirTable =====\n"
release = ReleaseRepository.new(REPO).find(VERSION)
events = GetLeadTimeEvents.for_version(REPO, FROM_VERSION, VERSION)
deploy_event = Deploy.new(release)

kpi_release_notes = RELEASE_NOTES_HEADER
kpi_release_notes << MarkdownEventsTable.new([deploy_event, *events]).render

release.add_to_body(kpi_release_notes)
