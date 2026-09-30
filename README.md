# kicker

A tiny launcher for local dev servers and periodic commands.

## Config

`~/.config/kicker/config.yml`:

```yaml
web:
  dir: ~/src/myapp
  cmd: bin/dev
  url: http://localhost:3000   # optional

report:
  dir: ~/src/myapp
  cmd: bin/report
  every: 1800                  # run every 30 minutes instead of keeping it running
  during:                      # optional
    wday: 1..5                 # Mon-Fri (0 is Sunday); a list like [1, 3, 5] also works
    hour: 9..19                # 9:00-19:00; 9...19 excludes 19:00
```

## Usage

```console
$ kicker start [app...]       # all apps if omitted
$ kicker stop [app...]
$ kicker restart [app...]
$ kicker status [app...]
$ kicker list
$ kicker log [app...] [-f] [-n N]
```

State lives in `~/.local/state/kicker/`.

## Install

```console
$ ln -s "$PWD/kicker" ~/.local/bin/kicker
$ echo 'source '"$PWD"'/kicker.bash' >> ~/.bashrc   # bash completion
```

To start apps at login on macOS:

```console
$ kicker launchd install
```

The current `PATH` is saved into the LaunchAgent, so reinstall after changing it.
