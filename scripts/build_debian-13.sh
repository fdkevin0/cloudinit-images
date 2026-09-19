# libguestfs 1.52 needs dhclient in its appliance for DHCP and DNS.
sudo apt-get update && sudo apt-get install -y libguestfs-tools isc-dhcp-client axel qemu-utils

axel -n 8 -o debian-13-genericcloud-amd64-fdkevin-src.qcow2 https://cdimage.debian.org/images/cloud/trixie/latest/debian-13-genericcloud-amd64.qcow2

sudo dpkg-statoverride --update --add root root 0644 /boot/vmlinuz-`uname -r`

virt-customize -a debian-13-genericcloud-amd64-fdkevin-src.qcow2 \
  --smp 2 --verbose \
  --timezone "Asia/Hong_Kong" \
  --append-line "/etc/default/grub:# disables OS prober to avoid loopback detection which breaks booting" \
  --append-line "/etc/default/grub:GRUB_DISABLE_OS_PROBER=true" \
  --run-command "update-grub" \
  --run-command "systemctl enable serial-getty@ttyS1.service" \
  --run-command "sed -i 's|Types: deb deb-src|Types: deb|g' /etc/apt/sources.list.d/debian.sources" \
  --run-command "sed -i 's|generate_mirrorlists: true|generate_mirrorlists: false|g' /etc/cloud/cloud.cfg.d/01_debian_cloud.cfg" \
  --update --install "sudo,qemu-guest-agent,spice-vdagent,bash-completion,unzip,wget,curl,axel,net-tools,iputils-ping,iputils-arping,iputils-tracepath,nano,most,screen,less,vim,bzip2,lldpd,mtr-tiny,htop,dnsutils,zstd" \
  --run-command "apt-get -y autoremove --purge && apt-get -y clean" \
  --append-line "/etc/systemd/timesyncd.conf:NTP=time.apple.com time.windows.com" \
  --delete "/var/log/*.log" \
  --delete "/var/lib/apt/lists/*" \
  --delete "/var/cache/apt/*" \
  --truncate "/etc/apt/mirrors/debian.list" \
  --append-line "/etc/apt/mirrors/debian.list:https://mirrors.ustc.edu.cn/debian" \
  --append-line "/etc/apt/mirrors/debian.list:https://mirrors.tuna.tsinghua.edu.cn/debian" \
  --truncate "/etc/apt/mirrors/debian-security.list" \
  --append-line "/etc/apt/mirrors/debian-security.list:https://mirrors.ustc.edu.cn/debian-security" \
  --append-line "/etc/apt/mirrors/debian-security.list:https://mirrors.tuna.tsinghua.edu.cn/debian-security" \
  --run-command "cloud-init clean --logs --seed" \
  --truncate "/etc/machine-id"

virt-sparsify --compress debian-13-genericcloud-amd64-fdkevin-src.qcow2 debian-13-genericcloud-amd64-fdkevin-cn.qcow2
