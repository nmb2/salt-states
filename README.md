# REMnux Salt States

Work in Progress: Working on creating state files.

## Known Issues

Not all state files have been created yet.

## Goals

* Be compatible with SIFT.
* Make it easy to update and make changes.
* Support Ubuntu 18.04 LTE as the base OS.
* Stay lightweight, installing only the prerequisites needed for the tools.

## How to Use this Repository to Install REMnux

For the full REMnux experience, [set up a dedicated REMnux system](#setting-up-a-dedicated-remnux-system). Alternatively, you can [install REMnux on your existing system](#installing-remnux-on-an-existing-system), in which case you'll get the tools that comprise REMnux without REMnux-specific configuration tweeks that give the distro its look-and-feel.

### Setting Up a Dedicated REMnux System

Install REMnux on a dedicated system for the full REMnux experience. In this case, you'll get all aspects of the REMnux distro, including the REMnux look-and-feel. The resulting system will be as lightweight as practical, because it only includes the necessary dependencies to run REMnux tools. To proceed this way:

1. Download the [ISO of the "MinimalCD" version of Ubuntu 18.04](https://help.ubuntu.com/community/Installation/MinimalCD).

2. Install the "MinimalCD" version of Ubuntu 18.04 on your system. A common way to do this is to set up a virtual machine. When going through the installation steps:
   
   * Set up the user named "**remnux**" when prompted. This is important.
   * Don't add any software packages when prompted to install optional packages.

3. Once the minimal system boots up, you'll see the console login prompt. Log in as the user "remnux".
4. Run the following commands to install the graphical interface and essential packages, then reboot:

```bash
sudo apt install -y gnome-session gdm3 open-vm-tools-desktop gnome-terminal
reboot
```

5. Once the system reboots, log into the graphical interface as the user "remnux".
6. Go to the Activities menu in the top left corner, click there, then launch the Terminal.
7. Run the following commands as root (start with `sudo -s`) in the Terminal to install SaltStack:

```bash
wget -O - https://repo.saltstack.com/apt/ubuntu/18.04/amd64/latest/SALTSTACK-GPG-KEY.pub | apt-key add -
echo "deb http://repo.saltstack.com/apt/ubuntu/18.04/amd64/2019.2 bionic main" | sudo tee /etc/apt/sources.list.d/saltstack.list
apt update -y
apt install -y salt-minion git 
systemctl disable salt-minion
systemctl stop salt-minion
echo "file_client: local" > /etc/salt/minion
```

8. Run the following commands as root (start with `sudo -s`)  to clone this repository and direct SaltStack to install the dedicated version of REMnux. As a reminder, this assumes you  created the user named "remnux" as part of the Ubuntu installation process.

```bash
git clone https://github.com/REMnux/salt-states.git /srv/salt
salt-call --local state.sls remnux.dedicated
```

If you'd like to observe progress of the installation, you can supply the optional parameter `-l info` to the `salt-call` command.

The installation (mostly the  `salt-call` command) will take about an hour or more, depending on the capabilities of your system and your internet connection.

### Installing REMnux on an Existing System

You can install REMnux on your existing system, if your system is running Ubuntu 18.04. This configuration doesn't modify your system's look and feel, so you won't have the REMnux look and feel. To proceed this way:

1. Run the following commands as root (start with `sudo -s`) on your system to install SaltStack. That the version of SaltStack that comes with Ubuntu 18.04 might not be compatible with REMnux, so you need to do this to install the supported SaltStack version:

```bash
wget -O - https://repo.saltstack.com/apt/ubuntu/18.04/amd64/latest/SALTSTACK-GPG-KEY.pub | apt-key add -
echo "deb http://repo.saltstack.com/apt/ubuntu/18.04/amd64/2019.2 bionic main" | sudo tee /etc/apt/sources.list.d/saltstack.list
apt update -y
apt install -y salt-minion git 
systemctl disable salt-minion
systemctl stop salt-minion
echo "file_client: local" > /etc/salt/minion
```

2. Run the following commands as root on your system (start with `sudo -s`) to clone the REMnux state file repository and direct SaltStack to install the addon version of REMnux. Replace **YOUR_USERNAME** with your username:

```bash
git clone https://github.com/REMnux/salt-states.git /srv/salt
salt-call --local state.sls remnux.addon pillar='{"remnux_user": "YOUR_USERNAME"}'
```
Remember to replace **YOUR_USERNAME** with the username you use to log into your system. The installation will take about an hour, depending on the capabilities of your system and your internet connection.

If you'd like to observe progress of the installation, you can supply the optional parameter `-l info` to the `salt-call` command.

The installation (mostly the  `salt-call` command) will take about an hour or more, depending on the capabilities of your system and your internet connection.

## Testing States

If you are on Linux or using Docker, you can test every state using a script that resides in the `.ci` directory.

### Testing a Single State

This will run SaltStack in a Docker container, mount the current changes of all the states into the container and then run it. By default debug logging is on, so you'll see a bunch of logging, below is an example of success output.

Run this command from the directory where you cloned this salt-states repository.

```bash
 .ci/test-state.sh remnux.python-packages.peframe
```

#### Output
```bash
local:
  Name: git - Function: pkg.installed - Result: Changed Started: - 01:10:43.540606 Duration: 35394.214 ms
  Name: libssl-dev - Function: pkg.installed - Result: Changed Started: - 01:11:18.946678 Duration: 8377.478 ms
  Name: swig - Function: pkg.installed - Result: Changed Started: - 01:11:27.336325 Duration: 5725.027 ms
  Name: python3 - Function: pkg.installed - Result: Clean Started: - 01:11:33.071909 Duration: 862.358 ms
  Name: python3-pip - Function: pkg.installed - Result: Changed Started: - 01:11:33.934581 Duration: 172933.827 ms
  Name: python - Function: pkg.installed - Result: Clean Started: - 01:14:26.880151 Duration: 862.198 ms
  Name: python-pip - Function: pkg.installed - Result: Changed Started: - 01:14:27.742717 Duration: 58663.826 ms
  Name: git+https://github.com/guelfoweb/peframe.git@master - Function: pip.installed - Result: Changed Started: - 01:15:27.562448 Duration: 33464.807 ms

Summary for local
------------
Succeeded: 8 (changed=6)
Failed:    0
------------
Total states run:     8
Total run time: 316.284 s
```

If you see the "Succeeded," you'll know the build works. However, the Docker container within which you installed peframe will have exited. To get interactive access to the container for troubleshooting the state file, see [How to Test a State Interactively](#how-to-test-a-state-interactively).

## Building States
This repository is built to run with SaltStack minionless setup with a local state tree. What this means is that everything is self container to run on a server where a SaltStack base code is installed. 

This allows for different build targets within the saltstack deployment, for now the only install method is `state.apply remnux`.

The states are designed to make use of require and watch statements against the `sls` module, but you can do it against other typical required modules as well, but the benefit of requiring against `sls` is that you can ensure _all_ states in a file pass before things continue.

### Requirements for Building State Files

* Use absolute paths when including and referencing other state files.
* Use `sls` require statements when dealing with a large includes, this ensures all states pass properly without having to specify them all.
* Prefix all state names with `remnux-`
* States should be added to the `init.sls` file in it's directory, unless it's purely a dependency for another package. There are two places in the `init.sls` to add, first under the `include:` directive (this ensures that the state is included in the execution) and then under the `test.nop require` directive. **Note:** the `test.nop` is used as a rollup state function to ensure all child states execute properly. As long as all require functions pass, it'll pass.
* All dependencies should be defined as state files. If a python packages requires something to be installed from _apt_, that package should get an entry in the `remnux/packages` folder, and then it should be included and required by the python package state. 

### How to Test a State Interactively

If you are working on a new state and want to be in a shell where you can just continue to test running the state without loosing history, you can launch into a Docker container (so long as you are on Linux or using Docker) and all the states will be mounted into a volume. A script called `.ci/dev-state.sh` is there to set this up for you.

You can create (or modify) your state file using your favorite text editor. When you are ready to test it, just run the following command `salt-call -l debug --local --retcode-passthrough --state-output=mixed state.sls <state_dot_path>`.

The `<state_dot_path>` will be something like `remnux.packages.state-filename` or `remnux.python-packages.state-filename`.

### Example States

#### Python Package Not in PIP

```yaml
include:
  - remnux.packages.git
  - remnux.packages.libssl-dev
  - remnux.packages.swig
  - remnux.packages.python3-pip
  - remnux.packages.python-pip

remnux-pip-peframe:
  pip.installed:
    - name: git+https://github.com/guelfoweb/peframe.git@master
    - bin_env: /usr/bin/pip3
    - require:
      - sls: remnux.packages.git
      - sls: remnux.packages.libssl-dev
      - sls: remnux.packages.swig
      - sls: remnux.packages.python3-pip
      - sls: remnux.packages.python-pip
```

Note: for those not familar with saltstack, `.sls` files are just YAML files, and they are "state" definitions. In the example above `remnux-pip-peframe` is just the name of a state(ment), where `pip.installed` is the SaltStack "state function" and then `- name` and `- require` are named arguments to that "state function." The /usr/bin/pip3 reference ensures that the Python 3 version of PIP will be used.


1. First we include `remnux.packages.git` and `remnux.packages.python3-pip` -- This is important because it helps SaltStack determine the proper execution order of all the states. Same for references to other peframe dependencies (libssl-dev and swig). The reference to python-pip is needed here for some strange reason--even though we'll be using PIP3 for peframe--because without it SaltStack gives an error.
2. The includes have been added as a require statement using `sls` for the state. -- This is important because it continues to help with the proper execution order and ensures that those state files are executed first and _onl if_ they both pass successful will the `pip.installed` run.
3. In this case peframe isn't in PIP, but it has a setup.py file, so it can be installed using the `pip.installed` state function from SaltStack.

In the end this state when run by itself will ensure that git and python pip are both installed before installing peframe. Git is required to clone the code from Github and PIP is installed because it uses the setup.py that is in the repo to actually install the module.
