# Setting up the GitHub App

The GitHub App is used by the release workflow to perform actions on your repos, like creating releases and
making PR comments.

Each organisation that uses the release workflow will need to create their _own_ GitHub App.
If `gha-scala-library-release-workflow` had its own server infrastructure, we could probably follow the more
common model of a single GitHub App being used by many organisations, but instead we take advantage of all those
free GitHub Actions minutes, so we need to pass the workflow the private key of the GitHub App so that it can
authenticate as the GitHub App... therefore we must each have our own GitHub App, so that we don't share private keys.

## 1. Create the GitHub App

### GitHub App for a single user account

You can just click this link to get taken to a pre-filled page to create a new GitHub App - you'll just need to
customise the app name:

https://github.com/settings/apps/new?name=scala-library-release&url=https://github.com/guardian/gha-scala-library-release-workflow&public=false&contents=write&pull-requests=write&webhook_active=false

### GitHub App for an organisation account

You can use the link above, but change the url so that it starts like this (the url query parameters stay the same),
and replace `ORGANIZATION` with your organisation's name (eg `guardian`):

```
github.com/organizations/ORGANIZATION/settings/apps/new
```

## 2. Install the GitHub App

Once your GitHub App is created, it'll be _owned_ by your organisation, but it'll still need to be _installed_
on your organisation. You can do this from the `Install App` tag on the GitHub App's settings page. For example,
for the `guardian` organisation, and the `gu-scala-library-release` app, the URL would be:

https://github.com/organizations/guardian/settings/apps/gu-scala-library-release/installations

At this point, you need to decide whether to install the app for all repositories, or just for selected
repositories. Selected repositories is better, as it limits the possible damage a rogue workflow could inflict -
but you'll need make sure you add all relevant repositories to the list as they come along.
