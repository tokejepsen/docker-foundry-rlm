# syntax=docker/dockerfile:1

FROM ubuntu:24.04

ARG FLT_TOOLS_DIR=LicensingTools7.1
ARG FLT_URL=https://thefoundry.s3.amazonaws.com/tools/FLT/7.1v1/FLT7.1v1-linux-x86-release-64.tgz
ARG RLM_URL=https://www.reprisesoftware.com/license_admin_kits/x64_l1.admin.tar.gz

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends ca-certificates wget; \
    rm -rf /var/lib/apt/lists/*

# Download/Install Foundry Licensing Tools
RUN set -eux; \
    wget -q -O /tmp/flt.tgz "${FLT_URL}"; \
    tar xzf /tmp/flt.tgz -C /tmp; \
    cd /tmp/FLT_*linux-x86-release-64*; \
    echo yes | bash install.sh; \
    rm -rf /tmp/flt.tgz /tmp/FLT_*

# Update Reprise to latest version. Reprise no longer publishes a stable direct
# download URL, so fall back to the rlm binary shipped with FLT.
RUN set -eux; \
    if wget -q -O /tmp/rlm.tar.gz "${RLM_URL}"; then \
        tar xzf /tmp/rlm.tar.gz -C /tmp; \
        cp /tmp/x64_l1.admin/rlm "/usr/local/foundry/${FLT_TOOLS_DIR}/bin/RLM/rlm.foundry"; \
        rm -rf /tmp/x64_l1.admin; \
    else \
        echo "WARNING: ${RLM_URL} unavailable, keeping the rlm binary bundled with FLT"; \
    fi; \
    rm -f /tmp/rlm.tar.gz

VOLUME /opt/rlm/licenses

# rlm server
EXPOSE 5053
# admin gui
EXPOSE 5054
# isv server
EXPOSE 4101

# Add startup script
COPY ./start.sh /opt/start.sh
RUN chmod +x /opt/start.sh

# Run the startup script
CMD ["/opt/start.sh"]
