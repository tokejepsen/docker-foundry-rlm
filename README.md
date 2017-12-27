**Goal**

To run Foundry licenses through a Docker container.

**Installation**

In order for the container to serve licenses, you need to be able to ping the contaier. For Windows/Mac please follow this: https://stackoverflow.com/questions/39216830/how-could-i-ping-my-docker-container-from-my-host


**Usage**

The container expects a license file to be named ```foundry_float.lic```. This license file needs to be in the volume you map to ```/opt/rlm/licenses```. Depending on the your license file details you will need to change the mac address and hostname.

```bash
docker run --mac-address 08:00:27:ef:70:d3 --hostname licenseserver -v /c/Users/admin/rlm/licenses:/opt/rlm/licenses -i -t foundry-rlm:latest
```
