**Goal**

To run the Foundry licenses server v8 through a Docker container.

**Setup**

In order for the container to serve licenses, you need to be able to ping the container. For Windows/Mac please follow this: https://stackoverflow.com/questions/39216830/how-could-i-ping-my-docker-container-from-my-host or https://github.com/docker/for-win/issues/221

Using Docker Desktop the above setup is not necessary.

**Usage**

The container expects a license file to be named ```foundry_float.lic```. This license file needs to be in the volume you map to ```/opt/rlm/licenses```. Depending on the your license file details you will need to change the mac address and hostname accordingly.

```bash
docker run --mac-address 08:00:27:ef:70:d3 --hostname licenseserver -v /c/Users/admin/rlm/licenses:/opt/rlm/licenses -i -t tokejepsen/docker-foundry-rlm:latest
```

The first line of the output will show the IP address.
```
IP ADDRESS:
172.17.0.2
```

When inputting the license server to use in Nuke use ```{PORT NUMBER}@{IP ADDRESS}```. If you didn't specify a port number in the license file it'll be ```5053```.

**Restarting**

Restarting the container works because the license file is temporarily store in the container until its deleted. This means you can have the license server always running even between reboots of the host machine by adding the ```--restart=always```.

```bash
docker run --restart=always --mac-address 08:00:27:ef:70:d3 --hostname licenseserver -v /c/Users/admin/rlm/licenses:/opt/rlm/licenses -i -t tokejepsen/docker-foundry-rlm:latest
```
