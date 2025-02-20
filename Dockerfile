ARG DOTNET=false
FROM debian:bookworm-slim AS base
LABEL maintainer="ThePawlow <business.shine939@passinbox.com>"

# Expose Ports
EXPOSE 22005/udp
EXPOSE 22006

# ------------------------
# Install Dependencies
# ------------------------
RUN SERVERFILES="/opt/ragemp" && apt update && \
    apt install wget gcc libunwind8 icu-devtools curl libssl3 libssl-dev procps -y && \
    wget -O /tmp/server.tar.gz https://cdn.rage.mp/updater/prerelease/server-files/linux_x64.tar.gz && \
	tar -xzf /tmp/server.tar.gz -C /tmp && \
	mkdir $SERVERFILES && \
	mv /tmp/ragemp-srv/ragemp-server $SERVERFILES/ragemp-server && \
	mv /tmp/ragemp-srv/bin $SERVERFILES/bin && \
    mv /tmp/ragemp-srv/dotnet $SERVERFILES/dotnet && \
	chmod +x $SERVERFILES/ragemp-server

# ------------------------
# Optional .NET Installation (Only if DOTNET=true)
# ------------------------
ARG DOTNET
RUN if [ "$DOTNET" = "true" ]; then \
    wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O /tmp/packages-microsoft-prod.deb && \
    dpkg -i /tmp/packages-microsoft-prod.deb && \
    rm /tmp/packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y --no-install-recommends dotnet-runtime-9.0 && \
    rm -rf /var/lib/apt/lists/*; \
fi

ADD entrypoint.sh /opt/ragemp/entrypoint.sh
ADD conf.json /opt/ragemp/conf.json

#VOLUME /ragemp

RUN useradd -m -d /opt/ragemp -s /usr/sbin/nologin ragempuser && \
    chown -R ragempuser:ragempuser /opt/ragemp
USER ragempuser
WORKDIR /opt/ragemp

ENTRYPOINT ["sh", "/opt/ragemp/entrypoint.sh"]