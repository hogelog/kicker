# kicker

A tiny launcher for local dev servers and periodic commands. Apps are defined in
`~/.config/kicker/config.yml` (or `$XDG_CONFIG_HOME/kicker/config.yml`).

```yaml
web:
  dir: ~/src/myapp
  cmd: bin/dev
  url: http://localhost:3000
```

`dir` and `cmd` are required. `url` is optional and is shown by `start` / `status` / `list`.

An app with `every` (in seconds) is not kept running; instead `cmd` is run repeatedly, `every` seconds apart.
`start` / `stop` / `status` / `log` work the same as for long-running apps.

`during` restricts runs to certain days of the week (`wday`, 0 is Sunday) and hours (`hour`).
`hour: 9..19` means from 9:00 up to and including 19:00; `9...19` excludes 19:00.
`wday` can also be a list such as `[1, 3, 5]`.
Outside the window, kicker waits until the window opens, so on Monday the first run happens at exactly 9:00.

```yaml
report:
  dir: ~/src/myapp
  cmd: bin/report
  every: 1800
  during:
    wday: 1..5
    hour: 9..19
```

The config is read when an app starts, so run `kicker restart <app>` after editing it.

## Usage

```console
$ kicker start                # start all apps (kicker start web for just one)
$ kicker status
$ kicker log web -f
$ kicker restart web
$ kicker stop
$ kicker list
```

Omitting app names, or passing `all`, targets every app.

`log` prefixes each line with the app name (`-f` to follow, `-n N` for the number of lines).

```console
$ kicker log -n 2
web   : Completed 200 OK in 38ms
worker: [ActiveJob] Performed ExampleJob
```

PID files live in `~/.local/state/kicker/pids/<app>.pid` and logs in `~/.local/state/kicker/logs/<app>.log`
(under `$XDG_STATE_HOME` if set).

## Install

```console
$ ln -s "$PWD/kicker" ~/.local/bin/kicker
$ echo 'source '"$PWD"'/kicker.bash' >> ~/.bashrc
```

With bash-completion@2, you can symlink the completion script instead of sourcing it from `.bashrc`.

```console
$ ln -s "$PWD/kicker.bash" "$(brew --prefix)/etc/bash_completion.d/kicker"
```

Completion reads app names from `kicker list`, so `kicker` must be on your `PATH`.

### Start on login (macOS)

```console
$ kicker launchd install      # registers a LaunchAgent and runs kicker start right away
$ kicker launchd uninstall
```

This runs `kicker start` once at login; it does not restart apps that crash.
The `PATH` at install time is passed to launchd, so reinstall after changing your `PATH` or moving kicker.
Output from the launchd run goes to `~/.local/state/kicker/logs/launchd.log`.
