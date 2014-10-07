DailyTrello
===========

Produces daily summary based on the layout of the MAS responsive tool checklist Trellos.  For each board gives:

* Board Name
* Number of items in "To do"
* List of each item in "Doing"
* List of each item in "For Review"
* List of items that have entered "Done" during the current day (UK time)
* Number of items in Done

Output is to standard out.

# Calling

```
daily_trello [-k key -t token] board1id [other board ids]
```

If key and token are not provided, then will attempt to use the environment variables $TRELLO_KEY AND $TRELLO_TOKEN.


# Implementation

* For each board
** Get the board name
** Get all the cards
** Get the ids of the "To do", "Doing", "For Review", and "Done" lists
** Count the "To do" cards
** Get the titles for the Doing cards
** Get the titles for review cards
** For each card in "Done"
*** Get the change list activities
*** Filter on having moved to "Done" during the current day
** Count the number of cards in the Done list


