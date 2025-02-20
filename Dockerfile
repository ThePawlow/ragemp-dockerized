ARG DOTNET=false
FROM debian:bookworm-slim AS base
LABEL maintainer="ThePawlow <business.shine939@passinbox.com>"

# Expose Ports
EXPOSE 22005/udp
EXPOSE 22006

# ------------------------
# Install Dependencies
# ------------------------
RUN apt update && \
    apt install wget gcc libunwind8 icu-devtools curl libssl-dev procps libc6 libgcc-s1 libgssapi-krb5-2 libicu72 libssl3 libstdc++6 zlib1g libicu-dev libatomic1  -y && \
    wget -O /tmp/server.tar.gz https://cdn.rage.mp/updater/prerelease/server-files/linux_x64.tar.gz && \
	tar -xzf /tmp/server.tar.gz -C /tmp && \
	mkdir /serverfiles && \
	mv /tmp/ragemp-srv/ragemp-server /serverfiles/ragemp-server && \
	mv /tmp/ragemp-srv/bin /serverfiles/bin && \
    mv /tmp/ragemp-srv/dotnet /serverfiles/dotnet && \
	chmod +x /serverfiles/ragemp-server && \
	mkdir /ragemp 

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

ADD entrypoint.sh /home/entrypoint.sh
ADD conf.json /serverfiles/conf.json

VOLUME /ragemp

ENTRYPOINT ["sh", "/home/entrypoint.sh"]