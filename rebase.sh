#!/usr/bin/sh

echo "Getting the IP...."
sleep 10s #Waits for 10s

vm_ip=$(sudo virsh domifaddr atomic-node | tail -2| awk '{print $4}' | cut -d/ -f1)
echo "$vm_ip"
touch inventory

echo -e "[atomichost]\n$vm_ip ansible_ssh_user=atomic-user ansible_ssh_pass=atomic" > inventory

ssh-copy-id -i ~/.ssh/id_rsa.pub atomic-user@$vm_ip

ansible-playbook rebase.yml --ask-sudo-pass -i inventory
