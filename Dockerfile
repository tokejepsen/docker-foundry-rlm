FROM ubuntu:latest

# Download/Install Foundry Licensing Tools
RUN apt-get -qq update
RUN apt-get install wget dpkg -y
# RUN wget http://thefoundry.s3.amazonaws.com/tools/FLT/7.1v1/FLT7.1v1-linux-x86-release-64.tgz
# RUN tar xzf FLT7.1v1-linux-x86-release-64.tgz
# RUN rm FLT7.1v1-linux-x86-release-64.tgz
# RUN cd /FLT_7.1v1_linux-x86-release-64RH/ && echo yes | /bin/sh install.sh

RUN wget https://thefoundry.s3.amazonaws.com/products/licensing/releases/8.0.0/FoundryLicensingUtility_8.0.0.deb
RUN dpkg -i FoundryLicensingUtility_8.0.0.deb

# Update Reprise to latest version
# RUN wget http://www.reprisesoftware.com/license_admin_kits/x64_l1.admin.tar.gz
# RUN tar xvf x64_l1.admin.tar.gz
# RUN rm x64_l1.admin.tar.gz
# RUN cp /x64_l1.admin/rlm /usr/local/foundry/LicensingTools7.1/bin/RLM/rlm.foundry

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
