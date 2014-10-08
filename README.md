DailyTrello
===========

Produces daily summary based on the layout of the MAS responsive tool checklist Trellos.  For each board gives:

* Board Name
* Number of items in "To do"
* List of each item in "Doing"
* List of each item in "For Review"
* List of items that have entered "Done" during the current day (UTC)
* Number of items in Done

Output is to standard out.

# Installation

* Needs Erlang/OTP 17 installed, with escript on the path
* A binary version to put on your path is [here](https://github.com/paulanthonywilson/daily_trello/releases)


# Calling

```
daily_trello [-k key -t token] board1id [other board ids]
```

If key and token are not provided, then will attempt to use the environment variables $TRELLO_KEY AND $TRELLO_TOKEN.


