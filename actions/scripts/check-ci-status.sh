#!/bin/bash

REPO_OWNER=$1
REPO_NAME=$2
CI_WORKFLOW_NAME=$3
COMMIT_ID=$4

gh api graphql -f query="query {
  repository(owner: \"$REPO_OWNER\", name: \"$REPO_NAME\") {
    object(expression: \"$COMMIT_ID\" ) {
       ... on Commit {
        statusCheckRollup {
          contexts(first: 100) {
            nodes {
              ... on CheckRun {
                name
                status
                conclusion
                detailsUrl
                checkSuite {
                  workflowRun {
                    workflow {
                      name
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}" | jq "[.data.repository.object.statusCheckRollup.contexts.nodes[] |
  select(.checkSuite.workflowRun.workflow.name == \"$CI_WORKFLOW_NAME\") |
{
  workflow: .checkSuite.workflowRun.workflow.name,
  status,
  conclusion, detailsUrl
}]"