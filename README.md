# Namely Connect

[![Code Climate](https://codeclimate.com/github/namely/connect/badges/gpa.svg)](https://codeclimate.com/github/namely/connect)
[![Circle CI](https://circleci.com/gh/namely/connect.svg?style=svg&circle-token=07c371714354bf58f4d2af8e0d92d793b5998880)](https://circleci.com/gh/namely/connect)

Simple web app for connecting external apps with Namely.

Planned integrations:

* Jobvite (create new Namely Profiles based on candidate data)

## Getting set up

Install qt

```sh
brew install qt
```

Set up the application environment, dependencies, and databases:

```sh

bin/setup
```

Run the tests:

```sh
rake
```

When changing feature specs that make API calls, you will need to rebuild one or
more VCR fixtures (in `spec/fixtures/vcr_cassettes`). When running these specs
without a saved VCR cassette, you will have to set the following environment
variables in your `.env` file:

* `TEST_JOBVITE_KEY` and `TEST_JOBVITE_SECRET`: A valid Jobvite API key and
  secret.
* `TEST_NAMELY_SUBDOMAIN`: The subdomain of a Namely sandbox account, e.g. if
  the account is at `foobar.namely.com`, you would set this to `foobar`.
* `TEST_NAMELY_ACCESS_TOKEN`: A valid access token for the Namely sandbox
  account specified by `TEST_NAMELY_SUBDOMAIN`.
* `TEST_NAMELY_AUTH_CODE`: An OAuth auth code for the Namely sandbox account
  specified by `TEST_NAMELY_SUBDOMAIN`.

## Importing data from Jobvite to Namely

To import newly hired Jobvite candidates for all users, run:

```sh
rake jobvite:import
```

This task can be invoked by a cron job or otherwise scheduled to regularly
import newly hired candidates.

## Development

### Pull Requests

#### Tags

We tag pull requests, so their state is obvious. The following tags should be used in the subject as [TAG] My contribution.

* WIP - Work In Progress. The pull request will change, and there is no need to review it yet.
* RFC - Request For Comment. The request is ready for +1s (:+1:) and/or comments.
* RDY - The request is ready to be merged. The request must have received at least 2 +1s (:+1:) (approvals) from other developers before being marked RDY. 

NOTE: When you approve a pull request (ie, give a +1), please add a short comment about your decision.
