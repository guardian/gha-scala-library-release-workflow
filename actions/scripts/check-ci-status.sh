#!/bin/bash

REPO_OWNER=$1
REPO_NAME=$2
CI_WORKFLOW_NAME=$3
COMMIT_ID=$4
BLOCK_FOR_SUCCESS=$5

fetch_ci_status() {
  ci_status=$(gh api graphql -f query="query {
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
  }]")

  status=$(jq -r '.[0].status' <<< "$ci_status")
  conclusion=$(jq -r '.[0].conclusion' <<< "$ci_status")

  echo $ci_status
  echo $conclusion

  if [ "$conclusion" == "SUCCESS" ]; then
    return 0
  elif [ "$status" != "COMPLETED" ]; then
    return 1
  else
    return 2
  fi
}

fetch_ci_status
echo $?
