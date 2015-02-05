## Setup

```
$ bundle install
$ rake db:setup
$ bundle exec rspec
$ rails server
```

## How To Contribute

See the `TODO` file.

## Returning Code to WhiteHat

Run the following:

```
$ git format-patch -o /tmp/$(whoami)-submission $(git rev-list --max-parents=0 HEAD)
$ cd /tmp && tar czvf $(whoami)-submission.tgz $(whoami)-submission
```

Send the resulting archive to us by email.

