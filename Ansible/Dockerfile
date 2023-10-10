FROM opensuse/leap:15.4

ENV LOGLEVEL="vvvvv"

RUN zypper -n update

RUN  zypper -n --no-gpg-checks --quiet install ansible && zypper -n --no-gpg-checks --quiet install docker && zypper -n --no-gpg-checks --quiet install openssh-clients && zypper -n --no-gpg-checks --quiet install sudo && zypper -n --no-gpg-checks --quiet install sshpass