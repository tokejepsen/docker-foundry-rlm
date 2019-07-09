FROM ubuntu:latest

# Download/Install Foundry Licensing Tools
RUN apt-get update
RUN apt-get install wget apt-utils -y

RUN wget https://thefoundry.s3.amazonaws.com/products/licensing/releases/8.0.0/FoundryLicensingUtility_8.0.0.deb
RUN apt-get install ./FoundryLicensingUtility_8.0.0.deb -y
RUN rm FoundryLicensingUtility_8.0.0.deb

VOLUME /opt/rlm/licenses

# rlm server
EXPOSE 5053
# admin gui
EXPOSE 5054
# isv server
EXPOSE 4101
# additional isv port
#EXPOSE 4500

# Add startup script
COPY ./start.sh /opt/start.sh
RUN chmod +x /opt/start.sh

# Run the startup script
CMD ["/opt/start.sh"]
