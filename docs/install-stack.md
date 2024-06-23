# Install stack

1. On the [control node][setup-control-node], open an Ubuntu terminal, `cd` to
   the cloned local repository root directory and update it to the latest code
   from the GitHub remote server by running the following commands. (Assuming
   `logging` is the local root repository directory as shown
   in step 7 of [Setup a control node][setup-control-node]):

   ```bash
   cd logging
   git pull
   ```

1. Connect once with SSH to the target Ubuntu device setup in [Install Ubuntu on
   device][install-os]. Both the control node and the Ubuntu device must be
   on the same network. This may ask if you are sure to continue connecting. If
   asked, type `yes`. This connection is done to save the Ubuntu device
   fingerprint into the control node's `known_hosts` file. This is required
   for the next step that uses Ansible calls inside a script.

   ```bash
   ssh <REMOTE_USERNAME>@<REMOTE_HOST_OR_IP_ADDRESS>
   ```

1. Once connected to the device, close the SSH connection.

   ```bash
   exit
   ```

1. Edit the configuration file `configuration.yml` using a text editor. This
   file contains all the settings and options that can be customize in the
   Machine Metrics Monitoring stack. Uncomment any settings and change their
   values. The next command will open `configuration.yml` in GNU nano, a well
   known text editor on Linux based systems. Once the changes applied, use
   `Ctrl-S` to save the changes and then `Ctrl-X` to close GNU nano. See the
   configuration section of the readme for more details on the
   Logging configuration.

   ```bash
   nano configuration.yml
   ```

1. Install the Logging stack with the next command. 

   ```bash
   bash install.sh --host <HOST> --user <REMOTE_USER>
   ```

1. Repeat steps 2 to 5 for additional Ubuntu devices.


