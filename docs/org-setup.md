# Organisation Setup

These steps are the initial setup for an organisation that's going to use `gha-scala-library-release-workflow`.
When we say "organisation", we mean a GitHub organisation (like [github.com/guardian](https://github.com/guardian)), but
these instructions also apply to a single GitHub user account, if you want to set up your own personal
repos to use the workflow.

1. [Create the GitHub App](github-app.md) to perform actions on your repos, like pushing commits and making PR comments.
2. [Generate release credentials](credentials/generating-credentials.md) (ie Sonatype account, PGP key, etc) and
   get ready to [supply them to the workflow](credentials/supplying-credentials.md).
3. [Configure your repos](configuration.md) to use the release workflow.
