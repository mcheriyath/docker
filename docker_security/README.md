# Docker Security Best practices

This document is built from different sources like [docker security best practices](https://elastic-security.com/2016/04/11/docker-best-security-practices/) and tools for [docker security benchmarking](https://github.com/docker/docker-bench-security).
References given below: <br>
## Best Security Practice for Docker

Basic intro on Docker Security can be found [here](https://d3oypxn00j2a10.cloudfront.net/assets/img/Docker%20Security/WP_Intro_to_container_security_03.20.2015.pdf) <br>

1. Secure and harden the Linux server (with regular and trusted updates, limit traffic with iptables, etc.).
2. Use the script provided by Docker for [CIS Benchmark](https://benchmarks.cisecurity.org/downloads/show-single/index.cfm?file=docker16.100) to address some security issues 
3. <b>Don’t run apps with root privileges</b>, not even within a container. In addition to this, take advantage of namespaces, thanks to which you can map a user within a container to a user (with no privileges) on the host
4. Use <b>Genuine/Trusted official docker base images</b>, Docker provides a tool named [Notary](https://github.com/docker/notary) which allows anyone to have trust over arbitrary collections of data on docker.com
5. Use <b>seccomp</b> to disable unused but potentially harmful system calls (by default seccomp already disables privileged system calls)
6. Use tools such as <b>AppArmor and SELinux</b> to properly track the activity of your containers and stop any unusual and potentially malicious activity
7. Carefully analyze Docker capabilities (you can find the full list [here](https://docs.docker.com/engine/reference/run/#runtime-privilege-linux-capabilities-and-lxc-configuration)) to minimize the privileges given to your containers. Be aware that Docker enables by default some capabilities (e.g. <b>CHOWN</b> which allows the container to arbitrarily change file owners bypassing all security controls) which are (mistakenly?) not considered harmful. However, it is always a good practice to drop all capabilities that are not necessary for your container. This will reduce the attack surface in case your container is compromised.


## Docker Bench for Security

Latest CIS Docker Benchmark is found [here](https://benchmarks.cisecurity.org/tools2/docker/CIS_Docker_1.11.0_Benchmark_v1.0.0.pdf)

Based on the above, there is a Docker bench security tool available for testing your own environment.

I have built a Vagrant box which has docker installed and tried this on it and below are the results.

Downloaded the github repo
````ruby
vagrant@labs:~$ git clone https://github.com/docker/docker-bench-security.git
Cloning into 'docker-bench-security'...
remote: Counting objects: 805, done.
Receiving objects: 100% (805/805), 395.37 KiB | 0 bytes/s, done.
remote: Total 805 (delta 0), reused 0 (delta 0), pack-reused 805
Resolving deltas: 100% (543/543), done.
Checking connectivity... done.
vagrant@labs:~$ ls
docker-bench-security
vagrant@labs:~$ cd docker-bench-security
````
Ran a Docker container with a basic apache installation from ubuntu base image
````code
vagrant@labs:~/docker-bench-security$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED              STATUS              PORTS                  NAMES
96a0725e6722        web2                "/bin/bash"         About a minute ago   Up About a minute   0.0.0.0:8080->80/tcp   apache
````

Ran the script on the host machine to perform checks on docker containers running.
````ruby
vagrant@labs:~/docker-bench-security$ sh docker-bench-security.sh
# ------------------------------------------------------------------------------
# Docker Bench for Security v1.1.0
#
# Docker, Inc. (c) 2015-
#
# Checks for dozens of common best-practices around deploying Docker containers in production.
# Inspired by the CIS Docker 1.11 Benchmark:
# https://benchmarks.cisecurity.org/downloads/show-single/index.cfm?file=docker16.110
# ------------------------------------------------------------------------------

[WARN] Some tests might require root to run
Initializing Tue Nov 22 22:37:48 UTC 2016


[INFO] 1 - Host Configuration
[WARN] 1.1  - Create a separate partition for containers
[PASS] 1.2  - Use an updated Linux Kernel
[PASS] 1.4  - Remove all non-essential services from the host - Network
[PASS] 1.5  - Keep Docker up to date
[INFO]       * Using 1.12.3 which is current as of 2016-10-26
[INFO]       * Check with your operating system vendor for support and security maintenance for docker
[INFO] 1.6  - Only allow trusted users to control Docker daemon
[INFO]      * docker:x:999:vagrant
[WARN] 1.7  - Failed to inspect: auditctl command not found.
[WARN] 1.8  - Failed to inspect: auditctl command not found.
[WARN] 1.9  - Failed to inspect: auditctl command not found.
[INFO] 1.10 - Audit Docker files and directories - docker.service
[INFO]      * File not found
[INFO] 1.11 - Audit Docker files and directories - docker.socket
[INFO]      * File not found
[WARN] 1.12 - Failed to inspect: auditctl command not found.
[INFO] 1.13 - Audit Docker files and directories - /etc/docker/daemon.json
[INFO]      * File not found
[WARN] 1.14 - Failed to inspect: auditctl command not found.
[WARN] 1.15 - Failed to inspect: auditctl command not found.


[INFO] 2 - Docker Daemon Configuration
[WARN] 2.1  - Restrict network traffic between containers
[WARN] 2.2  - Set the logging level
[PASS] 2.3  - Allow Docker to make changes to iptables
[PASS] 2.4  - Do not use insecure registries
[WARN] 2.5  - Do not use the aufs storage driver
[INFO] 2.6  - Configure TLS authentication for Docker daemon
[INFO]      * Docker daemon not listening on TCP
[INFO] 2.7 - Set default ulimit as appropriate
[INFO]      * Default ulimit doesn't appear to be set
[WARN] 2.8  - Enable user namespace support
[PASS] 2.9  - Confirm default cgroup usage
[PASS] 2.10 - Do not change base device size until needed
[WARN] 2.11 - Use authorization plugin
[WARN] 2.12 - Configure centralized and remote logging
[WARN] 2.13 - Disable operations on legacy registry (v1)


[INFO] 3 - Docker Daemon Configuration Files
[INFO] 3.1  - Verify that docker.service file ownership is set to root:root
[INFO]      * File not found
[INFO] 3.2  - Verify that docker.service file permissions are set to 644
[INFO]      * File not found
[INFO] 3.3  - Verify that docker.socket file ownership is set to root:root
[INFO]      * File not found
[INFO] 3.4  - Verify that docker.socket file permissions are set to 644
[INFO]      * File not found
[PASS] 3.5  - Verify that /etc/docker directory ownership is set to root:root
[PASS] 3.6  - Verify that /etc/docker directory permissions are set to 755
[INFO] 3.7  - Verify that registry certificate file ownership is set to root:root
[INFO]      * Directory not found
[INFO] 3.8  - Verify that registry certificate file permissions are set to 444
[INFO]      * Directory not found
[INFO] 3.9  - Verify that TLS CA certificate file ownership is set to root:root
[INFO]      * No TLS CA certificate found
[INFO] 3.10 - Verify that TLS CA certificate file permissions are set to 444
[INFO]      * No TLS CA certificate found
[INFO] 3.11 - Verify that Docker server certificate file ownership is set to root:root
[INFO]      * No TLS Server certificate found
[INFO] 3.12 - Verify that Docker server certificate file permissions are set to 444
[INFO]      * No TLS Server certificate found
[INFO] 3.13 - Verify that Docker server key file ownership is set to root:root
[INFO]      * No TLS Key found
[INFO] 3.14 - Verify that Docker server key file permissions are set to 400
[INFO]      * No TLS Key found
[PASS] 3.15 - Verify that Docker socket file ownership is set to root:docker
[PASS] 3.16 - Verify that Docker socket file permissions are set to 660
[INFO] 3.17 - Verify that daemon.json file ownership is set to root:root
[INFO]      * File not found
[INFO] 3.18 - Verify that daemon.json file permissions are set to 644
[INFO]      * File not found
[PASS] 3.19 - Verify that /etc/default/docker file ownership is set to root:root
[PASS] 3.20 - Verify that /etc/default/docker file permissions are set to 644


[INFO] 4 - Container Images and Build Files
[WARN] 4.1  - Create a user for the container
[WARN]      * Running as root: apache
[WARN] 4.5  - Enable Content trust for Docker


[INFO] 5  - Container Runtime
[WARN] 5.1  - Verify AppArmor Profile, if applicable
[WARN]      * No AppArmorProfile Found: apache
[WARN] 5.2  - Verify SELinux security options, if applicable
[WARN]      * No SecurityOptions Found: apache
[PASS] 5.3  - Restrict Linux Kernel Capabilities within containers
[PASS] 5.4  - Do not use privileged containers
[PASS] 5.5  - Do not mount sensitive host system directories on containers
[PASS] 5.6  - Do not run ssh within containers
[PASS] 5.7  - Do not map privileged ports within containers
[PASS] 5.9 - Do not share the host's network namespace
[WARN] 5.10 - Limit memory usage for container
[WARN]      * Container running without memory restrictions: apache
[WARN] 5.11 - Set container CPU priority appropriately
[WARN]      * Container running without CPU restrictions: apache
[WARN] 5.12 - Mount container's root filesystem as read only
[WARN]      * Container running with root FS mounted R/W: apache
[WARN] 5.13 - Bind incoming container traffic to a specific host interface
[WARN]      * Port being bound to wildcard IP: 0.0.0.0 in apache
[WARN] 5.14 - Set the 'on-failure' container restart policy to 5
[WARN]      * MaximumRetryCount is not set to 5: apache
[PASS] 5.15 - Do not share the host's process namespace
[PASS] 5.16 - Do not share the host's IPC namespace
[PASS] 5.17 - Do not directly expose host devices to containers
[INFO] 5.18 - Override default ulimit at runtime only if needed
[INFO]      * Container no default ulimit override: apache
[PASS] 5.19 - Do not set mount propagation mode to shared
[PASS] 5.20 - Do not share the host's UTS namespace
[PASS] 5.21 - Do not disable default seccomp profile
[PASS] 5.24 - Confirm cgroup usage
[WARN] 5.25 - Restrict container from acquiring additional privileges
[WARN]      * Privileges not restricted: apache


[INFO] 6  - Docker Security Operations
[INFO] 6.4 - Avoid image sprawl
[INFO]      * There are currently: 2 images
[INFO] 6.5 - Avoid container sprawl
[INFO]      * There are currently a total of 1 containers, with 1 of them currently running
vagrant@labs:~/docker-bench-security$
````

There are [other methods/approach](https://github.com/docker/docker-bench-security) to run this test as well. 
