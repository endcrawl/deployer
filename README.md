## Deployer - Automated Zero Downtime Deployments

More documentation and packaging to come.

### Getting Started

```sh
which git
which setlock         # from acg/daemontools-encore
which setuidgid       # from acg/daemontools-encore
which trigger-listen  # from acg/trigger
which trigger-pull    # from acg/trigger
which fsq-run         # from endcrawl/fsq-run
which shellsafe       # from endcrawl/daemontools-extras
make                  # ensure tests pass
```

### Usage Notes

Fear not; many of these manual steps will be automated.

- First, create a config file for `deployer`:
  - For user installs, this is `~/.deployer.conf`.
  - For system installs, this is `$PREFIX/etc/deployer.conf`.
  - [x] Provide an example conf file to start with.
  - [ ] Make this easier for user installs.

- Make sure the deployer binaries are on your path.
  - [ ] Provide binary packages that handle installation.

- Create the necessary filesystem structure.
  - `deployer-init`

- Set up a `daemontools` service which runs `deployer-service`.
  - [ ] Provide something to make this easier.

- Start managing your first deployment:

```sh
deployer-manage foo git@github.com:yourname/foo.git
```

- Push some new commits to the `master` branch of `foo`.

- Request your first automated deployment:

```sh
deploy foo master
```

- Watch it work:

```sh
tail -n 100 -f /var/service/deployer/log/main/current
```

