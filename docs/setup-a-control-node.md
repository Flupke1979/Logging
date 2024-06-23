# Setup a control node

> **Note:** This procedure has been tested on a Window 64-bit system, freshly
> installed and fully updated, using Windows Subsystem for Linux and an Ubuntu
> 22.04 LTS distribution.

This procedure will setup a machine to act as an installer machine for Machine
Metrics Monitoring devices. This is done by setting up the machine as an
[Ansible][ansible] control node.

[ansible]: https://www.ansible.com/

If the machine already has Windows Subsystem for Linux (WSL) enabled with an
Ubuntu distribution installed or the installer machine OS is Ubuntu, skip the
first steps and go directly to step 6.

1. On a machine running Windows, start with the `Run as administrator` option a
   PowerShell terminal.

1. Enable WSL by running the following command:

   ```powershell
   Enable-WindowsOptionalFeature `
       -Online `
       -FeatureName Microsoft-Windows-Subsystem-Linux
   ```

1. If not asked after running the previous command, reboot the control node
   with:

   ```powershell
   Restart-Computer
   ```

1. Start a PowerShell terminal and install the latest Ubuntu LTS with the
   following command (using Ubuntu 22.04 LTS here):

   <!-- cspell:ignore winget -->

   ```powershell
   winget install --accept-source-agreements --exact --id Canonical.Ubuntu.2204
   ```

1. The next command will install the Ubuntu distribution in WSL. This will start
   an Ubuntu terminal. In the terminal, enter the desired new UNIX username and
   password.

   ```powershell
   wsl --install --distribution ubuntu
   ```

1. Still in the Ubuntu terminal, run the following commands to update the
   distribution, install Ansible and it's prerequisites:

    <!-- cspell:ignore sshpass -->

   ```bash
   sudo apt update
   sudo apt upgrade -y
   sudo apt install git grep nano python3 python3-pip sshpass -y
   pip install --no-warn-script-location --user ansible==9.0.1
   ```

1. Clone the 3DMAX logging repository with the following. See the
   GitHub's [Cloning with HTTPS URLs][cloning-url] page on how to get
   authenticated when running this command.

   ```bash
   git clone \
        --depth=1 \
        https://github.com/Flupke1979/Logging \
        logging
   ```

1. Close the Ubuntu terminal with the `exit` command. This Ubuntu terminal needs
   to be closed to make sure Ansible's scripts locations are loaded in the
   `PATH` environment variable for later use.

   ```bash
   exit
   ```

1. Close the PowerShell terminal with:

   ```powershell
   exit
   ```

[cloning-url]: https://docs.github.com/en/get-started/getting-started-with-git/about-remote-repositories#cloning-with-https-urls
