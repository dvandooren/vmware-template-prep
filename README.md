# Ansible Playbook - Template Prep

This playbook prepares a VM so that it can be turned into a template. The steps in the playbook are largely based on the following aritcle by Bob Plankers:
[Preparing Linux Template VMs](https://lonesysadmin.net/2013/03/26/preparing-linux-template-vms/)

## Step 1: Configure Ansible for the project
### Creating/Editing the required files
- Create a `envs/<project>.config` file based on the `envs/sample.config` file and change as needed
- Create a `envs/<project>.config` file based on the `envs/sample.config` file and change as needed

There are a number of settings in the .config file that will allow you to control some of the parts of the playbook. For example there's a config option to tell the playbook to install/update vmware-tools to the latest version, and another one that prevent the /etc/ssh/*keys* files from being removed (useful for testing)

## Step 2: Run the playbook
- Run the template_prep playbook

```Shell
ansible-playbook -i envs/<project>.hosts -e @envs/<project>.config template_prep.yml --ask-pass
    -or-
./scripts/env-ansible.sh <project> template_prep.yml --ask-pass
```

## Step 3: Storage vMotion VM
- If you enabled the ```run_zero_out_disk``` config option, you now need to Storage vMotion the VM from it's existing datastore (since it'll be essentially thick provisioned) to a new datastore and select thin provisioned.
