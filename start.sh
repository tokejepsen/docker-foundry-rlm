#!/bin/bash
echo "HOSTNAME"
hostname
echo "IP ADDRESS:"
hostname -i

# Store the licese file inside the container for later reuse.
cp /opt/rlm/licenses/foundry_float.lic /opt/foundry_float.lic

# Run the license server directly with the copied license file.
echo "Y" | /opt/FoundryLicensingUtility/bin/FoundryLicenseUtility -l /opt/foundry_float.lic
/opt/FoundryLicensingUtility/bin/flt.run
watch /opt/FoundryLicensingUtility/bin/FoundryLicenseUtility -s status
