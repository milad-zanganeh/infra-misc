## ssh-tunnel

A minimal Dockerized SSH endpoint intended for tunneling (SSH port forwarding). Use it to create SSH tunnels with `-L` (local), `-R` (remote), or `-D` (dynamic SOCKS) forwarding. Interactive shells are disabled; the container is meant purely for proxying TCP traffic via SSH.

It creates a single non-root user per container via `SSH_USER` and `SSH_PASS` and runs `sshd` with restrictive settings (no root login, password auth enabled, `MaxSessions 1`, `MaxStartups 1:1:1`). The login shell is set to `nologin` to prevent interactive sessions while still permitting TCP forwarding for tunnels.

### Prerequisites
- **Docker** 
- **Docker Compose**

### Quick start (Compose as multiple tunnel endpoints)
This repo includes a `docker-compose.yml` that defines several containers (`ssh-user1` … `ssh-user10`) with distinct users and host ports for parallel tunnels.

```bash
docker compose up -d

# Local port forward (-L): expose target.host:80 locally at 127.0.0.1:8080
ssh -p 2221 -N -L 127.0.0.1:8080:target.host:80 user1@localhost

# Dynamic SOCKS proxy (-D): start a SOCKS5 proxy on 127.0.0.1:1080
ssh -p 2222 -N -D 127.0.0.1:1080 user2@localhost

# Remote port forward (-R): expose local service to the container side
# Note: remote binds are usually loopback-only unless GatewayPorts is enabled
ssh -p 2223 -N -R 127.0.0.1:9000:localhost:9000 user3@localhost
```

Notes:
- Usernames are `user1` … `user10`.
- Passwords are defined in `docker-compose.yml` (do not reuse elsewhere).
- The proxy container must have network reachability to the final target host/port.
