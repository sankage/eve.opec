# OPEC (Office of POS Electricity Consumption)

This is a tool for monitoring Player Owned Station fuel levels and to alert
Slack chat when towers have issues.


## Alerts

There are currently 3 kinds of alerts that OPEC can send.

* __Fuel Alert:__ A notice that the tower has 24 hours or less before running
  out of fuel. This alert will be sent to the general channel.
* __Security Alert:__ A notice that the tower has more access than it should. A
  tower is considered insecure if it allows Corp or Alliance members.
* __Status Change:__ A notice that the tower has changed states. This could be
  any change of the possible states: Unanchored, Anchored / Offline, Onlining,
  Reinforced, Online


## Usage

Set environment variables for various settings:

* `SECRET_KEY_BASE` – Standard Rails secret
* `EVESSO_CLIENT_ID` and `EVESSO_SECRET_KEY` – Create an application at
  https://developers.eveonline.com/applications. Its settings will be
  __Authentication Only__ and the callback url will be whatever your domain is
  and will end in `/auth/evesso/callback`
* `CORP_API_ID` and `CORP_API_VCODE` – Create a corporate api key with an
  access mask of 17434624
* `SLACK_WEBHOOK_URL` – Create a __Incoming WebHooks__ integration for your
  Slack chat
* `EXCLUDED_TOWERS` – This is an array of tower itemIDs that should not alert
  you for security issues (ie a general alliance/corp tower)
* `SLACK_ADMIN_CHANNEL` – This is the name of the channel/group that you would
  like Security and Status Change alerts to be sent to.
* `SLACK_GENERAL_CHANNEL` – This is the name of the channel/group that you would
  like general Fuel alerts to be sent to.


## SDD Update

* Login to server
* perform these commands

  ```bash
  $ su postgres
  $ cd
  $ wget https://www.fuzzwork.co.uk/dump/postgres-latest.dmp.bz2
  $ bzip2 -f -d postgres-latest.dmp.bz2
  $ pg_restore --clean \
               --username=eve \
               --host=127.0.0.1 \
               --dbname=eve_static_data \
               postgres-latest.dmp
  ```
