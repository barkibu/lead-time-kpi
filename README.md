# Lead Time Notes on Release

## Situation

Current KPIs extraction is manual and time-consuming for. We want to save time automatically pulling the lead time (merge to prod) from Github.

## Github Action Workflow as a Savior

Add a workfow that executes whenever a new release is published with the following:

```yaml
name: Lead Time For Release
on:
  release:
    types: [published]

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
          docker run --rm -e GITHUB_ACCESS_TOKEN=${{ secrets.GITHUB_TOKEN}} -v $GITHUB_EVENT_PATH:/usr/app/event.json bkbinfra/release_kpi_extractor -d true
```

## In the daily work

Make sure to tag your Pull requests with the appropriate tags. Currently supported ones are:

- technical_debt
- feature
- bug

For features that are composed of various PullRequests you can combine their KPIs by adding to the body of the child PR:

```yaml
Parent PR #{PrNumberOfTheParentPr}
```

At the next release, the workflow will iterate over the commits, looking for those tags, extract, format and bind as notes to the release the estimate Lead Time KPIs. 

You can then copy/paste  thoses into the KPI AirTable.

You can explore the repo [barkibu/lead-time-kpi-demo](https://github.com/barkibu/lead-time-kpi-demo) and its pull requests as well as release note to get a grasp of how it's working.
