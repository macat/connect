# Namely Connect

Simple web app for connecting external apps with Namely.

Planned integrations:

* Jobvite (create new Namely Profiles based on candidate data)

## Importing data

To import newly hired Jobvite candidates for all users, run:

```sh
rake jobvite:import
```

This task can be invoked by a cron job or otherwise scheduled to regularly
import newly hired candidates.
