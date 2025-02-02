#!/bin/bash

# Путь к файлу sources.list
sources_list="/etc/apt/sources.list"

# Проверка наличия файла sources.list и его резервной копии
if [ -f "$sources_list" ]; then
    # Создание резервной копии исходного файла
    cp "$sources_list" "$sources_list.backup"

    # Замена содержимого файла sources.list
    cat > "$sources_list" <<EOL
# deb cdrom:[Ubuntu-Server 20.04 LTS _Focal Fossa_ - Beta amd64 (20200401)]/ focal main restricted

# See http://help.ubuntu.com/community/UpgradeNotes for how to upgrade to
# newer versions of the distribution.
deb http://archive.ubuntu.com/ubuntu/ focal main restricted
# deb-src http://archive.ubuntu.com/ubuntu/ focal main restricted

## Major bug fix updates produced after the final release of the
## distribution.
deb http://archive.ubuntu.com/ubuntu/ focal-updates main restricted
# deb-src http://archive.ubuntu.com/ubuntu/ focal-updates main restricted

## N.B. software from this repository is ENTIRELY UNSUPPORTED by the Ubuntu
## team. Also, please note that software in universe WILL NOT receive any
## review or updates from the Ubuntu security team.
deb http://archive.ubuntu.com/ubuntu/ focal universe
# deb-src http://archive.ubuntu.com/ubuntu/ focal universe
deb http://archive.ubuntu.com/ubuntu/ focal-updates universe
# deb-src http://archive.ubuntu.com/ubuntu/ focal-updates universe
## N.B. software from this repository is ENTIRELY UNSUPPORTED by the Ubuntu
## team, and may not be under a free licence. Please satisfy yourself as to
## your rights to use the software. Also, please note that software in
## multiverse WILL NOT receive any review or updates from the Ubuntu
## security team.
deb http://archive.ubuntu.com/ubuntu/ focal multiverse
# deb-src http://archive.ubuntu.com/ubuntu/ focal multiverse
deb http://archive.ubuntu.com/ubuntu/ focal-updates multiverse
# deb-src http://archive.ubuntu.com/ubuntu/ focal-updates multiverse

## N.B. software from this repository may not have been tested as
## extensively as that contained in the main release, although it includes
## newer versions of some applications which may provide useful features.
## Also, please note that software in backports WILL NOT receive any review
## or updates from the Ubuntu security team.
deb http://archive.ubuntu.com/ubuntu/ focal-backports main restricted
# deb-src http://archive.ubuntu.com/ubuntu/ focal-backports main restricted
## Uncomment the following two lines to add software from Canonical's
## 'partner' repository.
## This software is not part of Ubuntu, but is offered by Canonical and the
## respective vendors as a service to Ubuntu users.
# deb http://archive.canonical.com/ubuntu focal partner
# deb-src http://archive.canonical.com/ubuntu focal partner

deb http://archive.ubuntu.com/ubuntu focal-security main restricted
# deb-src http://archive.ubuntu.com/ubuntu focal-security main restricted
deb http://archive.ubuntu.com/ubuntu focal-security universe
# deb-src http://archive.ubuntu.com/ubuntu focal-security universe
deb http://archive.ubuntu.com/ubuntu focal-security multiverse
# deb-src http://archive.ubuntu.com/ubuntu focal-security multiverse

# This system was installed using small removable media
# (e.g. netinst, live or single CD). The matching "deb cdrom"
# entries were disabled at the end of the installation process.
# For information about how to configure apt package sources,
# see the sources.list(5) manual.
EOL

    echo "Содержимое файла sources.list успешно заменено."
else
    echo "Файл sources.list не найден."
fi
