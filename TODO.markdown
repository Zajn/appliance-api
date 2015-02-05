
# User Stories

## As an admin, I want to see which targets are reachable so that I can monitor appliances in the field.

We need a status web page to show what percentage of targets are reachable with
a simple `ping`-style implementation[0]. Research shows customers may be satisfied
with some combination of: a pie chart, a detailed listing, or cumulative totals.

It's important to provide high-level data across all targets in the system.

Customers also say they want this report to load quickly when they view it.

We kicked off this project by writing some basic models and generating some
data. This is the first customer-facing feature request.

[0]: For the purposes of development lets assume a TCP connection on a port
with a listener. For example, port `3000`, `80`, or `443`. Something you're
running this app on.
