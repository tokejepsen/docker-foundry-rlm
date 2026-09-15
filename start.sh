#!/bin/bash

LICENSE_DIR=${LICENSE_DIR:-/opt/rlm/licenses}
STORED_LICENSE=/opt/foundry_float.lic

# Store the license file inside the container for later reuse, so restarts work
# even when the mounted license file is gone.
license=$(find "${LICENSE_DIR}" -maxdepth 1 -type f -name '*.lic' 2>/dev/null | sort | head -n 1)

if [ -n "${license}" ]; then
    echo "Using license file ${license}"
    cp "${license}" "${STORED_LICENSE}"
elif [ -f "${STORED_LICENSE}" ]; then
    echo "No .lic file found in ${LICENSE_DIR}, reusing previously stored license"
else
    echo "ERROR: no .lic file found in ${LICENSE_DIR} and no stored license available" >&2
    exit 1
fi

# Run the license server directly with the copied license file.
exec /usr/local/foundry/LicensingTools7.1/bin/RLM/rlm.foundry -c "${STORED_LICENSE}"
