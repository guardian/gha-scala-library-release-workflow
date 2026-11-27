#!/bin/bash

REPO_OWNER=$1
REPO_NAME=$2
CI_WORKFLOW_NAME=$3
COMMIT_ID=$4
WAITING_BEHAVIOUR=$5

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
    echo "Current CI workflow status is $status, workflow has not yet completed"
    return 1
  else
    echo "CI workflow status concluded with $conclusion, not Success"
    exit 2
  fi
}

if [ "$WAITING_BEHAVIOUR" == "NO_WAIT" ]; then
  echo "Check of CI status (will not wait for Success, but will exit if CI failed)"
  fetch_ci_status
else
  echo "Waiting for CI success"
  until fetch_ci_status; do
    sleep 5
  done
fi
