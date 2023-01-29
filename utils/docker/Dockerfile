# Var
ARG GPGOPT='keyserver-options auto-key-retrieve'

# Builder

FROM archlinux:base-devel as BUILDER
ARG GPGOPT
RUN pacman -Sy archlinux-keyring --noconfirm --noprogressbar && pacman -Syy --needed --noconfirm --noprogressbar git base-devel \
   && pacman -Sc --noconfirm
RUN useradd --create-home --shell /bin/bash makepkg && touch /etc/sudoers.d/makepkg \
   && printf "makepkg ALL=(ALL) NOPASSWD: /usr/bin/makepkg, /usr/bin/pacman\n" > /etc/sudoers.d/makepkg && mkdir /build \
   && mkdir /home/makepkg/.gnupg && chown makepkg:makepkg /home/makepkg/.gnupg /build
USER makepkg
WORKDIR /build
RUN printf "${GPGOPT}\n" >> /home/makepkg/.gnupg/gpg.conf \
   && git clone https://aur.archlinux.org/aurutils.git && cd aurutils; makepkg -sic --noconfirm;

# Main

FROM archlinux:base-devel
ARG GPGOPT
LABEL maintainer="brokenpip3 <brokenpip3@gmail.com>" \
      org.opencontainers.image.authors="brokenpip3 <brokenpip3@gmail.com>" \
      org.opencontainers.image.title="aur-builder" \
      org.opencontainers.image.description="docker utility to build aur packages" \
      org.opencontainers.image.url="ghcr.io/brokenpip3/my-pkgbuilds" \
      org.opencontainers.image.source="https://www.github.com/brokenpip3/my-pkgbuilds" \
      org.opencontainers.image.base.name="docker.io/archlinux:base-devel"
COPY --from=BUILDER /build/aurutils/*.pkg.tar.zst /tmp/
RUN pacman -Sy archlinux-keyring --noconfirm --noprogressbar && pacman -Syy --needed --noconfirm --noprogressbar pacman-contrib icu base-devel \
   && pacman -U /tmp/*.pkg.tar.zst --noconfirm && pacman -Sc --noconfirm
RUN useradd --create-home -u 1001 --shell /bin/bash makepkg && touch /etc/sudoers.d/makepkg \
   && printf "makepkg ALL=(ALL) NOPASSWD: /usr/bin/makepkg, /usr/bin/pacman\n" > /etc/sudoers.d/makepkg \
   && mkdir /build /home/makepkg/.gnupg \
   && chown makepkg:makepkg /home/makepkg/ /build /home/makepkg/.gnupg \
   && printf "${GPGOPT}\n" >> /home/makepkg/.gnupg/gpg.conf
USER makepkg

# No workdir or entrypoint instructions to accomodate the flow inside the github runner
# User 1001 for the same exact reason
