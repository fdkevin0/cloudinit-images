# fdkevin-cn Cloud Images

Customize the official Debian 13 (Trixie) AMD64 genericcloud image for Proxmox VE / QEMU.

All image customization lives in [scripts/build_debian-13.sh](scripts/build_debian-13.sh):

- Set the timezone to `Asia/Hong_Kong` and configure NTP servers.
- Update packages and install QEMU Guest Agent and common tools.
- Configure USTC and Tsinghua APT mirror lists and disable their regeneration by cloud-init.
- Clean cloud-init state, machine ID, logs and APT caches, then compress the QCOW2 image.

## GitHub Actions

Push to `main` to trigger [the workflow](.github/workflows/build.yml). The workflow runs on Ubuntu 24.04, checks QCOW2 integrity, and uploads the finished image to **Actions → workflow run → Artifacts**:

`debian-13-genericcloud-amd64-fdkevin-cn.qcow2`

To build manually, push the workflow to the default branch, then select **Actions → Build cloud image → Run workflow**, or run `gh workflow run build.yml --ref main`.

## Local build

From the repository root on an x86_64 Ubuntu / Debian Linux host:

```sh
env -u XDG_RUNTIME_DIR LIBGUESTFS_BACKEND=direct bash -e scripts/build_debian-13.sh
```

The script installs its build dependencies and writes both the source and finished images to the current directory. On macOS, use a Linux VM.

Inspired by [Sukka's guide to customizing Debian cloud images](https://blog.skk.moe/post/proxmox-ve-customize-debian-cloud-image/).
