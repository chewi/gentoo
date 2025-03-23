# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: sysroot.eclass
# @MAINTAINER:
# cross@gentoo.org
# @AUTHOR:
# James Le Cuirot <chewi@gentoo.org>
# @SUPPORTED_EAPIS: 8
# @BLURB: common functions for using a different sysroot (e.g. cross-compiling)

qemu_arch() {
	case "${CHOST}" in
		armeb*) echo armeb ;;
		arm*) echo arm ;;
		*) echo "${CHOST%%-*}" ;;
	esac
}

sysroot_make_runner() {
	[[ -z ${SYSROOT} ]] && return

	local \
		broot_qemu=${BROOT}/usr/bin/qemu-$(qemu_arch)
		sysroot_qemu=${SYSROOT}${broot_qemu}

	if [[ -x ${broot_qemu} && ! -f ${sysroot_qemu} ]]; then
		SANDBOX_WRITE+=":${SYSROOT}" install -D -m0644 /dev/null "${sysroot_qemu}" ||
			die "Please touch the ${sysroot_qemu} file and retry"
	fi

	install -m0755 /dev/stdin "${T}"/sysroot-run <<-EOF1 || die
		#!${BASH}

		SANDBOX_WRITE+=":/proc/self/uid_map:/proc/self/gid_map:/proc/self/setgroups" exec unshare --mount --map-root-user "${BASH}" -e -s -- "\${@}" <<-EOF2
			[[ -x "${broot_qemu}" ]] && mount --bind -o ro "${broot_qemu}" "${sysroot_qemu}"

			mount --rbind /dev "${SYSROOT}"/dev
			mount --rbind /proc "${SYSROOT}"/proc
			mount --rbind /sys "${SYSROOT}"/sys
			mount --rbind /tmp "${SYSROOT}"/tmp
			mount --rbind "${BROOT}"/var "${ESYSROOT}"/var

			exec chroot "${SYSROOT}" "${EPREFIX}"/bin/sh -e -s -- "\\\${@}" <<-EOF3
				cd "${EPREFIX}\${PWD#${BROOT}}"
				exec "\\\${@}"
			EOF3
		EOF2
	EOF1
}
