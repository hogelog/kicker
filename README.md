# kicker

自分用の開発サーバ起動ツール。起動する app は `~/.config/kicker/config.yml`
(`XDG_CONFIG_HOME` があればそちら) に書く。

```yaml
web:
  dir: ~/src/myapp
  cmd: bin/dev
  url: http://localhost:3000
```

`dir` と `cmd` は必須。`url` は任意で、`start` / `status` / `list` の表示に出る。

`every` (秒) を書いた app は常駐せず、`cmd` を終わるたびに `every` 秒空けて繰り返し実行する。
`start` / `stop` / `status` / `log` の扱いは常駐する app と同じ。

`during` で実行する曜日 (`wday`、0 が日曜) と時間帯 (`hour`) を絞れる。
`hour: 9..19` は 9:00 から 19:00 ちょうどまで、`9...19` なら 19:00 を含まない。
`wday` は `[1, 3, 5]` のように配列でも書ける。
時間帯の外では次に入る時刻まで待つので、例えば月曜は 9:00 ちょうどに最初の実行が走る。

```yaml
report:
  dir: ~/src/myapp
  cmd: bin/report
  every: 1800
  during:
    wday: 1..5
    hour: 9..19
```

設定は起動時に読むので、変えたら `kicker restart <app>` で反映する。

## 使い方

```console
$ kicker start                # 全部起動 (kicker start web で個別)
$ kicker status
$ kicker log web -f
$ kicker restart web
$ kicker stop
$ kicker list
```

app 名を省略、または `all` を渡すと全 app が対象になる。

`log` は行頭に app 名を付けて出す (`-f` で追尾、`-n N` で行数)。

```console
$ kicker log -n 2
web   : Completed 200 OK in 38ms
worker: [ActiveJob] Performed ExampleJob
```

pid は `~/.local/state/kicker/pids/<app>.pid`、ログは `~/.local/state/kicker/logs/<app>.log`
(`XDG_STATE_HOME` があればそちら)。

## インストール

```console
$ ln -s "$PWD/kicker" ~/.local/bin/kicker
$ echo 'source '"$PWD"'/kicker.bash' >> ~/.bashrc
```

bash-completion@2 を使っているなら、`.bashrc` に書く代わりに置き場所へ symlink してもよい。

```console
$ ln -s "$PWD/kicker.bash" "$(brew --prefix)/etc/bash_completion.d/kicker"
```

補完は app 一覧を `kicker list` から取るので、`kicker` が PATH 上にあること。

### ログイン時に起動する (macOS)

```console
$ kicker launchd install      # ~/Library/LaunchAgents に登録し、その場で kicker start も走る
$ kicker launchd uninstall
```

ログイン時に `kicker start` を 1 回走らせるだけで、落ちた app の再起動はしない。
launchd には install した時点の `PATH` を渡すので、`PATH` や kicker の置き場所を変えたら install し直す。
launchd から起動したときの出力は `~/.local/state/kicker/logs/launchd.log` に出る。
