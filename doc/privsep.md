### Introducing Settings for each Managed Unit

A managed unit "foo" has its settings stored in a directory `$DEPLOYER_UNITS_DIR/units/foo/`. For system installs, `DEPLOYER_UNITS_DIR` is by default `/var/lib/deployer`.

For one thing, this allows the `deploy` program to `test -d` for whether a unit is managed, and bail early with an error message (or possibly just ignore) if it isn't.


### Privilege Separation

When `deployer-queue` is running as root, the `$DEPLOYER_UNITS_DIR/units/foo/DEPLOYER_USER` file determines which user account we drop privileges to before conducting any deployment operations. It's a fatal error if this file is missing and we're running as root.

Since deployment operations can now happen under one of many user accounts, and, in most setups, the `git fetch` operation needs access to a shared ssh key, this presents a problem: ssh refuses to use an `~/.ssh/id_rsa` file that's group readable.

So, we use `ssh-agent`. The `DEPLOYER_SSH_KEY` setting tells us where to find the shared ssh keypair, which should be `root:root`. Before switching to `DEPLOYER_USER`, we run `ssh-agent`, we add the keypair, and we make `SSH_AUTH_SOCK` group-accessible to `DEPLOYER_USER`.

Then we drop privileges to `DEPLOYER_USER`, taking care to preserve `SSH_AUTH_SOCK` in the environment. Once dropped, we may need to set up a particular environment with things like `PATH`, `PYTHONPATH` etc in it. It would be nice if this was done in a standard way (eg `/etc/environment` plus some user-specific dot-file).

The `ssh-agent` approach has the nice property that `DEPLOYER_USER` accounts don't need access to the ssh keypair directly, and permission to use the keypair is only granted temporarily. Normally these accounts won't have any ssh access.

We can also unload the keypair from `SSH_AUTH_SOCK` after the `git fetch` operation, so the subsequent post-deploy command (eg `make`) doesn't have access.

#### Operational Issues

Privilege separation will also require some refactoring. The `deployer` script will need to be factored into a "top half" and a "bottom half". The top half is running as root. The bottom half runs as `DEPLOYER_USER`. Let's call the bottom half `deployer-update`. It determines what the active and inactive checkouts are, what branch we're using, performs the git fetch, deletes the ssh deploy key from the agent, performs the git checkout, and runs the post-update command (typically just `make`).

The top half, after initial validation, runs itself under ssh-agent, loads the ssh key, does the chmod + chown on `SSH_AUTH_SOCK`, invokes `deployer-update` as `DEPLOYER_USER`, then updates the active symlink if necessary.

To avoid other kinds of cross-unit compromises, the `DEPLOYER_DEPLOY_ROOT` directory itself should not be writable by `DEPLOYER_USER`. This prevents unit A from updating the symlink for unit B, and thus replacing it with arbitrary code.

#### Questions

- [x] Will ssh-agent let you dump the private key for an identity?
  - Nope. Good. 

- [x] After deleting an identity, does ssh-agent provide any way to reload it that doesn't require access to the private key file?
  - Nope. Good.

- [ ] Can `git fetch` be coerced into running arbitrary local commands via `.git/` directory configuration?
  - Yes :(
  - The `pre-auto-gc` hook could be executed.
  - In addition, these git config settings could execute commands:
    - `core.gitProxy`
    - `core.askpass`
    - ...probably a number of others
  - Mitigations?
    - Hooks: refuse to proceed if any hook scripts are executable?
    - Config: check `git config --list` against some kind of whitelist? Tricky.
  - Could just say meh, this isn't an issue. So `DEPLOYER_USER` could use the ssh key to get read-only access to the other repositories it already has access to...so what? The root problem is maybe the ssh key grants access to too many things. You could always use a separate ssh deploy key per repository.
    - [x] Should we encourage a separate ssh key per repository by making the `-k` option to `deployer-manage` required, although it could perhaps be empty?
      - Nah. Some people won't care about this feature, which complicates setups operationally.
      - I want to switch us to per-repository deploy keys in github though. That lets us eliminate the deploy bot github user.

- Would be nice if `ssh-agent` could make an identity single-use.
  - It can't though.


### Unprivileged Mode

When `deployer-queue` isn't running as root, none of the above happens:

- The `DEPLOYER_USER` setting is ignored.
- We don't attempt to self-exec with dropped privileges.
- We don't attempt to self-exec under ssh-agent.
- We don't attempt to load `DEPLOYER_SSH_KEY` into ssh-agent.
- We don't attempt to chmod the ssh-agent socket.
- We don't attempt to unload `DEPLOYER_SSH_KEY` after the actual update step.


### Interface-Level Changes

- [x] New option: `deployer-manage -u username`
  - Stores `DEPLOYER_USER` setting. Optional, but privileged mode deployments will fail without it.
- [x] New option: `deployer-manage -k path/to/ssh/private/key`
  - Stores `DEPLOYER_SSH_KEY` setting. Optional, but git+ssh deployments may fail without it. Pubkey is assumed by ssh-agent to be same path with `.pub` appended.
- [x] Should `deployer-manage -x` store the `DEPLOYER_IN_PLACE` option somewhere?
  - Not necessary. There are some settings which are already manifest in the checkouts themselves. No sense in storing them twice.

