#!/bin/bash

echo "IP ADDRESS:"
hostname -i

# Run the license server directly with a license file called "foundry_float.lic"
/usr/local/foundry/LicensingTools7.1/bin/RLM/rlm.foundry -c /opt/rlm/licenses/foundry_float.lic
