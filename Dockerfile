FROM archlinux/archlinux:multilib-devel

RUN pacman-key --init && \
    pacman -Syu --noconfirm && \
    pacman -S git --noconfirm && \
    useradd -m perforce-admin && \
    echo 'perforce-admin ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER perforce-admin
WORKDIR /home/perforce-admin

RUN git clone https://aur.archlinux.org/p4d.git && \
    git clone https://aur.archlinux.org/p4.git && \
    cd p4d && makepkg -si --noconfirm --syncdeps && cd .. && \
    cd p4 && makepkg -si --noconfirm --syncdeps && cd .. && \
    rm -rf p4d p4

ENV P4PORT=localhost:1666

RUN p4d -r /home/perforce-admin -p 0.0.0.0:1666 & \
    sleep 2 && \
    p4 -u perforce-admin configure set security=2


EXPOSE 1666
CMD ["p4d", "-r", "/home/perforce-admin", "-p", "0.0.0.0:1666"]