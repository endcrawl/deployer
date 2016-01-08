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

