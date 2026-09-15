**Goal**

To run Foundry licenses through a Docker container.

**Setup**

Requires Docker Engine 20.10.10 or newer. Older engines fail to build the image, because their seccomp profile blocks syscalls used by `gpgv` in current Ubuntu base images, which makes `apt-get update` fail with `NO_PUBKEY`.

Modern Docker Desktop routes container traffic through a shared-memory channel rather than a virtual network adapter, so container IPs such as `172.17.0.2` are not reachable from the host on either the WSL 2 or the Hyper-V backend. Publish the ports instead, as shown under Usage.

The license file must pin the ISV server port. With a bare `ISV foundry` line, RLM picks a random ISV port on every start and clients cannot reach it through published ports:

```
HOST licenseserver 080027ef70d3
ISV foundry port=4101
```

Only the `LICENSE` lines are signed, so editing the `HOST` and `ISV` lines does not invalidate the license.

**Building**

```bash
docker build -t docker-foundry-rlm .
```

Reprise no longer publishes a stable direct download for the RLM administration bundle, so the build falls back to the `rlm` binary shipped with the Foundry Licensing Tools. To use a newer one, pass the current URL:

```bash
docker build --build-arg RLM_URL=<url to x64_l1.admin.tar.gz> -t docker-foundry-rlm .
```

**Usage**

The container picks up any ```*.lic``` file placed in the volume you map to ```/opt/rlm/licenses``` (if several are present, the first one in alphabetical order is used). Depending on the your license file details you will need to change the mac address and hostname accordingly.

```bash
docker run --restart=always -d --mac-address 08:00:27:ef:70:d3 --hostname licenseserver -p 5053:5053 -p 5054:5054 -p 4101:4101 -v /c/Users/admin/rlm/licenses:/opt/rlm/licenses docker-foundry-rlm
```

Port ```5053``` is the rlm server, ```5054``` the admin web interface, and ```4101``` the ISV server port pinned in the license file. All three must be published, because a client contacts ```5053``` first and is then redirected to the ISV port.

When inputting the license server to use in Nuke use ```5053@localhost``` on the same machine, or ```5053@{HOST IP}``` from other machines on the network. Reaching it from other machines also needs a firewall rule allowing inbound connections to ```com.docker.backend.exe```.

To check the server is serving licenses:

```bash
docker exec <container> /usr/local/foundry/LicensingTools7.1/bin/RLM/rlmutil rlmstat -c 5053@localhost -a
```

**Restarting**

Restarting the container works because the license file is temporarily store in the container until its deleted. This means you can have the license server always running even between reboots of the host machine by adding the ```--restart=always```.
