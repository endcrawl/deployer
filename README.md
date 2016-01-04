## Deployer - Automated Zero Downtime Deployments

More documentation to come.

### Getting Started

Requirements:

- `git`
- `trigger-listen` and `trigger-pull`
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
  - TODO: provide an example conf file to start with.

- Make sure the deployer binaries are on your path.
  - TODO: provide binary packages that handle installation.

- Create the necessary filesystem structure.
  - TODO: write `deployer-init`, `deployer-manage`, and `deployer-unmanage` scripts.

- Set up a `daemontools` service which runs `deployer-service`.
  - TODO: provide more to make this easier.

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

