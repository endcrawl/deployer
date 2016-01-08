## Deployer - Automated Zero Downtime Deployments

More documentation to come.

### Getting Started

Requirements:

- `git`
- `setlock` from `daemontools`
- `trigger-listen` and `trigger-pull` from `trigger`
- `fsq-run`

See that tests pass:

```
make -B check
```

### Usage

Fear not; many of these manual steps will be automated.

- First, create a config file for `deployer`:
  - For user installs, this is `~/deployer.conf`.
  - For system installs, this is `$PREFIX/etc/deployer.conf`.
  - [x] Provide an example conf file to start with.
  - [ ] Make this easier for user installs.

- Make sure the deployer binaries are on your path.
  - [ ] Provide binary packages that handle installation.

- Create the necessary filesystem structure.
  - [x] Write `deployer-init`.
  - [x] Write `deployer-manage`.
  - [x] Write `deployer-unmanage`.

- Set up a `daemontools` service which runs `deployer-service`.
  - [ ] Provide something to make this easier.

- Start managing your first deployment:

```
deployer-manage foo git@github.com:yourname/foo.git
```

- Push some new commits to the `master` branch of `foo`.

- Request your first automated deployment:

```
deploy foo master
```

- Watch it work:

```
tail -n 100 -f /var/service/deployer/log/main/current
```

### TODO

- [x] `deployer-manage` should create the initial symlink.
- [x] `deployer` should take one less argument and get deploy root from env.
- [x] `deployer-queue` should take one less argument and cd to the queue dir specified by env.
- [ ] make `trigger-pull` quieter if nothing's listening on the fifo:
  - `trigger-pull: fatal: cannot open var/lib/deployer/trigger.fifo: device not configured`
- [ ] eliminate the `git stash` warning:
  - fatal: /usr/lib/git-core/git-stash cannot be used without a working tree.


