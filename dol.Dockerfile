FROM mono
RUN apt-get update \
    && apt-get install -y \
        gettext-base \
        git-core \
        netcat \
        procps \
        telnet \
        vim \
    && mkdir -p ~/dol

WORKDIR /root/dol
RUN git clone https://github.com/Dawn-of-Light/DOLSharp.git ~/dolgit \
    && cp -rf ~/dolgit/* ~/dol/ \
    && rm -rf ~/dol/.git \
    && sed -i 's@ColoredConsoleAppender@ConsoleAppender@g' ~/dol/GameServer/config/logconfig.xml \
    && sed -i 's@admincommands@AdminCommands@g' ~/dol/GameServer/GameServer.csproj \
    && sed -i 's@gmcommands@GMCommands@g' ~/dol/GameServer/GameServer.csproj \
    && sed -i 's@playercommands@PlayerCommands@g' ~/dol/GameServer/GameServer.csproj \
    && nuget restore ~/dol/'Dawn of Light.sln'

RUN MONO_IOMAP=case xbuild ~/dol/'Dawn of Light.sln' \
    && mkdir -p ~/dol/Debug/config \
    && cp -rf ~/dol/debug/* ~/dol/Debug/ \
    && ln -s ~/dol/Debug/logs /var/log/dol
    # MONO_IOMAP=case xbuild /p:Configuration=Release Dawn\ of\ Light.sln

COPY ./serverconfig.xml /root/serverconfig.xml.template
COPY ./dol-entrypoint.sh /dol-entrypoint.sh

EXPOSE 10300
EXPOSE 10400/udp

ENTRYPOINT ["/dol-entrypoint.sh"]
# CMD [ "mono", "./TestingConsoleApp.exe" ]
# CMD [ "LANG=en_US.CP1252", "mono", "--debug", "--gc=sgen", "--server", "~/dol/Debug/DOLServer.exe" ]
# LANG=en_US.CP1252 mono --debug --gc=sgen --server ~/dol/Debug/DOLServer.exe
