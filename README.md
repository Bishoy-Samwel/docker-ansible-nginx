# Deploying Nginx with Docker and Ansible

## Overview
This project demonstrates how to use **Docker** to run an **Ubuntu** container and configure it using **Ansible** to:

- Update the package cache
- Install the latest version of **Nginx**
- Copy an `index.html` file from the Ansible controller to the host
- Restart the Nginx service
- Verify if `index.html` is accessible via port **80**

## Prerequisites
Before getting started, ensure you have the following installed on your system:

- **Docker** ([Installation Guide](https://docs.docker.com/get-docker/))
- **Ansible** ([Installation Guide](https://docs.ansible.com/ansible/latest/installation_guide/))

## Setup Instructions

### Step 1: Pull and Run Ubuntu Docker Container
Run the following command to pull and start an Ubuntu container:

```bash
docker container build -t nginx-ansible .
docker run -d --name ubuntu-host nginx-ansible
```

Check if the container is running:

```bash
docker ps
```

### Step 2: Install Ansible on Your Machine
If Ansible is not installed, install it using:

```bash
sudo apt update && sudo apt install -y ansible
```

### Step 3: Configure Ansible Inventory
Create an **inventory file (`inventory.ini`)** specifying the container as a remote host:

```ini
[ubuntu]
172.17.0.2 ansible_user=root ansible_connection=docker
```

⚠️ **Note:** Replace `172.17.0.2` with the actual IP of your container (find it using `docker inspect ubuntu-host | grep "IPAddress"`).

### Step 4: Create the Ansible Playbook (`nginx_setup.yml`)
Create a file called `nginx_setup.yml` and add the following content:

```yaml
- name: Configure Ubuntu Container with Nginx
  hosts: ubuntu
  become: true
  tasks:
    - name: Update the package cache
      ansible.builtin.apt:
        update_cache: yes

    - name: Install latest Nginx
      ansible.builtin.apt:
        name: nginx
        state: latest

    - name: Copy index.html to the host
      ansible.builtin.copy:
        src: index.html
        dest: /var/www/html/index.html

    - name: Restart Nginx service
      ansible.builtin.service:
        name: nginx
        state: restarted
```

### Step 5: Create an `index.html` File
Create an `index.html` file in the same directory:

```html
<!DOCTYPE html>
<html>
<body>
    <h1>Hello World!</h1>
</body>
</html>
```

### Step 7: Run the Ansible Playbook
Run the following command to apply the configuration:

```bash
ansible-playbook -i inventory.ini nginx_setup.yml
```

### Step 6: Verify the Deployment
Find the container's IP:

```bash
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ubuntu-host
```

Open your browser or use `curl` to check if Nginx is serving the `index.html` file:

```bash
curl http://172.17.0.2
```

You should see **"Hello World"** 🎉

## Troubleshooting

- If Nginx is not running, restart it manually inside the container:
  ```bash
  docker exec -it ubuntu-host service nginx restart
  ```
- If Ansible cannot connect, ensure the container's SSH setup allows connections.
- If the page is not loading, make sure port **80** is exposed.

## Conclusion
You have successfully set up an **Ubuntu container** with **Ansible**, installed **Nginx**, copied an `index.html` file, and verified the deployment. 🚀

Feel free to extend this setup for further automation!

