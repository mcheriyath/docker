# Docker Security Best practices

This document is built from different sources like [docker security best practices](https://elastic-security.com/2016/04/11/docker-best-security-practices/) and tools for [docker security benchmarking](https://github.com/docker/docker-bench-security).
References given below: <br>
## [Best Security Practice for Docker](https://d3oypxn00j2a10.cloudfront.net/assets/img/Docker%20Security/WP_Intro_to_container_security_03.20.2015.pdf) <br>

1. Secure and harden the Linux server (with regular and trusted updates, limit traffic with iptables, etc.).
2. Use the script provided by Docker for [CIS Benchmark](https://benchmarks.cisecurity.org/downloads/show-single/index.cfm?file=docker16.100) to address some security issues 
3. <b>Don’t run apps with root privileges</b>, not even within a container. In addition to this, take advantage of namespaces, thanks to which you can map a user within a container to a user (with no privileges) on the host
4. Use <b>Genuine/Trusted official docker base images</b>, Docker provides a tool named [Notary](https://github.com/docker/notary) which allows anyone to have trust over arbitrary collections of data on docker.com
5. Use <b>seccomp</b> to disable unused but potentially harmful system calls (by default seccomp already disables privileged system calls)
6. Use tools such as <b>AppArmor and SELinux</b> to properly track the activity of your containers and stop any unusual and potentially malicious activity
7. Carefully analyze Docker capabilities (you can find the full list [here](https://docs.docker.com/engine/reference/run/#runtime-privilege-linux-capabilities-and-lxc-configuration)) to minimize the privileges given to your containers. Be aware that Docker enables by default some capabilities (e.g. <b>CHOWN</b> which allows the container to arbitrarily change file owners bypassing all security controls) which are (mistakenly?) not considered harmful. However, it is always a good practice to drop all capabilities that are not necessary for your container. This will reduce the attack surface in case your container is compromised.


## Docker Bench for Security

