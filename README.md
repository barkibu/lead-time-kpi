# Lead Time Notes on Release

We want to automate the extraction of some key KPIs for lead time and production deployment tracking.

## Pseudo-code

On each Release:

- Add `deployment_to_production` event on the KPI AirTable
- Create an empty list of LeadTime event
- Look for all PRs included in the release and for each
  - Look for tag (feature / defect / tech debt)
  - Look for potential parent feature
    - If has a parent feature included in the release
      - Update the lead_time event of the parent feature with the day since merge
      - Add the PR id to the lead_time event
    - Else
      - Create a lead_time event with the day since merge
    - Add the PR id to the lead_time event
- Add each LeadTime event to the KPI AirTable

## Launch it

```bash
$ bundle install
$ GITHUB_ACCESS_TOKEN=ghp_yOuYaCcEsSToKeN ./lead_time_extraction.rb 'barkibu/kinship-connectedhealth-backend' 'v1.4.5'
```

## Configuration

Most of the defaults are configurable through environment variables in order to adapt this script to the specificity of any repository and custom tags/labels might be used:

| Environment Variable Name                            | Description                                     | Default Value               |
| ---------------------------------------------------- | ----------------------------------------------- | --------------------------- |
| PROJECT_NAME                                         | Name of the project for the KPI to appear under | App                         |
| CHANGE_TYPES                                         | Comma separated main labels for type of changes | defect,tech_debt,feature    |
| CHANGE_TYPE_DEFAULT                                  | Default change type when no label detected      | feature                     |
| CHANGE\_TYPE\_{*Uppercase Main Change Type*}\_ALIASES | Comma separated aliases                         | ---                         |
| CHANGE_TYPES_IGNORED                                 | Comma separated labels to ignore for KPIs       | translation,ignore-for-kpis |
| VERSION_REGEXP                                       | Regexp to detect versions from tags             | \d+.\d+.\d+                 |

Default Aliases for the default change type defined:

- CHANGE_TYPE_TECH_DEBT_ALIASES: "tech_debt,refactor"
- CHANGE_TYPE_DEFECT_ALIASES: "defect,bug,fix,hotfix"

## Automate it

This script is also available as a docker image built on each push on master.
To use the docker image:

```bash
  docker build . -t bkbinfra/lead_time_automation
  docker pull/push bkbinfra/lead_time_automation
  docker run -v $GITHUB_EVENT_PATH:/usr/app/event.json bkbinfra/lead_time_automation
```

The image accepts the following flags:

- `d`: yes for debug info
- `r`: repository to look for the release
- `v`: Released version
- `b`: Base version to start looking for PRs
- `e`: Path where to find the event json (Release created or published event from GITHUB)

## Usage

On the Github Repository you want to keep track of, add a workfow that executes whenever a new release is published with the following:

```yaml
name: Lead Time For Release
on:
  release:
    types: [published]

  workflow_dispatch: # To allow manual launch with specified version
    inputs:
      version:
        description: "Version for which to extract the KPIs"

permissions:
  contents: write
  pull-requests: read

jobs:
  extractLeadTime:
    runs-on: ubuntu-latest

    steps:
      - name: Bind KPIs Notes to Release
        run: |
          docker pull bkbinfra/release_kpi_extractor
          if [ "$VERSION" != "" ]; then
            docker run --rm -e GITHUB_ACCESS_TOKEN=${{ secrets.GITHUB_TOKEN}} bkbinfra/release_kpi_extractor -d true -v $VERSION -r $REPOSITORY
          else
            docker run --rm -e GITHUB_ACCESS_TOKEN=${{ secrets.GITHUB_TOKEN}} -v $GITHUB_EVENT_PATH:/usr/app/event.json bkbinfra/release_kpi_extractor -d true
          fi
        env:
          REPOSITORY: ${{ github.repository }}
          VERSION: ${{ github.event.inputs.version }}
```

Make sure to tag your Pull requests with the appropriate tags. Currently supported ones are:

- technical_debt
- feature
- bug

For features that are composed of various PullRequests you can combine their KPIs by adding to the body of the child PR:

```yaml
Parent PR: #{PrNumberOfTheParentPr}
```

At the next release, the workflow will iterate over the commits, looking for those tags, extract, format and bind as notes to the release the estimate Lead Time KPIs.

You can then copy/paste thoses into the KPI AirTable.

You can explore the repo [barkibu/lead-time-kpi](https://github.com/barkibu/lead-time-kpi) and its pull requests as well as release note to get a grasp of how it's working.
