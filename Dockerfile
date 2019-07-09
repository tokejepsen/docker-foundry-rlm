FROM ubuntu:latest

# Download/Install Foundry Licensing Tools
RUN apt-get update
RUN apt-get install wget apt-utils -y

RUN wget https://thefoundry.s3.amazonaws.com/products/licensing/releases/8.0.0/FoundryLicensingUtility_8.0.0.deb
RUN apt-get install ./FoundryLicensingUtility_8.0.0.deb -y
RUN rm FoundryLicensingUtility_8.0.0.deb

VOLUME /opt/rlm/licenses

# rlm server
EXPOSE 4101
# RLM Web Server (admin gui)
EXPOSE 4102
# isv server
EXPOSE 5053

# Add startup script
COPY ./start.sh /opt/start.sh
RUN chmod +x /opt/start.sh

# Run the startup script
CMD ["/opt/start.sh"]
