# Generating new credentials

Normally you'll be using [shared organisation-wide credentials](supplying-credentials.md),
but if you need to rotate those credentials, or just create some new ones for your organisation:

## Updating a Sonatype OSSRH Token username & password

As of [January 2024](https://central.sonatype.org/news/20240109_issues_sonatype_org_deprecation/#support-requests),
Sonatype is actively discouraging the legacy username & password method of authentication, recommending
[token authentication](https://central.sonatype.org/publish/generate-token/)
(see link for token-regenerating instructions).

Note these points:

* The token is in a colon:separated username/password format, and _both_ username & password are randomised & revocable
  secret strings.
* Tokens generated on either https://oss.sonatype.org/ or https://s01.oss.sonatype.org/ will be _different_, and
  **a token generated on one will not work on the other**. So, eg, if your `SONATYPE_CREDENTIAL_HOST` is `s01.oss.sonatype.org`,
  you'll need to use a token _generated_ on `s01.oss.sonatype.org`. Remember that the `SONATYPE_CREDENTIAL_HOST` you
  use is [dictated](https://github.com/xerial/sbt-sonatype/pull/461) by which Sonatype OSSRH server your **profile**
  is hosted on.  
  **Guardian developers:** currently the Guardian's `com.gu` profile is hosted on `oss.sonatype.org`, so the token we
  use must be generated [there](https://oss.sonatype.org/), logged in with the `guardian.automated.maven.release`
  account.

## Generating a new PGP key

See [Sonatype's instructions](https://central.sonatype.org/publish/requirements/gpg/#generating-a-key-pair) for
generating a keypair - ensure you upload the public key to a [keyserver](https://keyserver.ubuntu.com/).

However, note that `gha-scala-library-release-workflow` requires a
[**passphrase-less** private key](https://unix.stackexchange.com/a/550538/46453), and that key
should be plaintext, not BASE64-encoded.

```shell
gpg --armor --export-secret-key [insert key fingerprint here] | pbcopy
```

## Generating a new GitHub App private key

See [GitHub's instructions](https://docs.github.com/en/apps/creating-github-apps/authenticating-with-a-github-app/managing-private-keys-for-github-apps#generating-private-keys) for generating a private key. If you haven't already created a GitHub App for the
release workflow, see [Setting up the GitHub App](github-app.md) first.

**Guardian developers:** Here's a direct link to our GitHub App settings page, where you can generate a new private key:
https://github.com/organizations/guardian/settings/apps/gu-scala-library-release
