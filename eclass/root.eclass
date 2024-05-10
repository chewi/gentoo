# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: root.eclass
# @MAINTAINER:
# chewi@gentoo.org
# @AUTHOR:
# Original author: James Le Cuirot <chewi@gentoo.org>
# @SUPPORTED_EAPIS: 5 6 7 8
# @BLURB: Functions for installing into a different ROOT
# @DESCRIPTION:
# This eclass useful functions for building and installing software into a ROOT
# other than /. It may also operate on SYSROOT, which can only differ from /
# when ROOT also does.

case ${EAPI} in
	5|6|7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

# @FUNCTION: qemu_arch
# @DESCRIPTION:
# Return the QEMU architecture name for the current CHOST. This name is used in
# qemu-user binary filenames, e.g. qemu-ppc64le.
qemu_arch() {
	case "${CHOST}" in
		armeb*) echo armeb ;;
		arm*) echo arm ;;
		powerpc64le*) echo ppc64le ;;
		powerpc64*) echo ppc64 ;;
		powerpc*) echo ppc ;;
		*) echo "${CHOST%%-*}" ;;
	esac
}

sysroot_run_setup() {
 	[[ -z ${SYSROOT} ]] && return

	local broot_qemu=${BROOT}/usr/bin/qemu-$(qemu_arch)
	local root_qemu=${SYSROOT}${broot_qemu}

	if [[ -x ${broot_qemu} && ! -f ${root_qemu} ]]; then
		SANDBOX_WRITE+=":${SYSROOT}" install -D -m0644 /dev/null "${root_qemu}" ||
			die "Please touch the ${root_qemu} file and retry"
	fi
}

_do_root_run() {
	SANDBOX_WRITE+=":/proc/self/uid_map:/proc/self/gid_map:/proc/self/setgroups" unshare --mount --map-root-user "${BASH}" -e -s -- "${@}" <<-EOF1
		[[ -x "${broot_qemu}" ]] && mount --bind -o ro "${broot_qemu}" "${root_qemu}"
		[[ -d ${root_run_dir}${EPREFIX}/var ]] && mount --rbind "${BROOT}"/var "${root_run_dir}${EPREFIX}"/var
		for dir in /dev /proc /sys /tmp; do
			[[ -d ${root_run_dir}\${dir} ]] && mount --rbind "\${dir}" "${root_run_dir}\${dir}"
		done
		exec chroot "${root_run_dir}" "${EPREFIX}"/bin/sh -e -s -- "\${@}" <<-EOF2
			cd "${EPREFIX}${PWD#${BROOT}}"
			exec "\\\${@}"
		EOF2
	EOF1
}

sysroot_run() {
	if [[ -z ${SYSROOT} ]]; then
		"${@}"
		return $?
	fi

	local root_run_dir=${SYSROOT}
	local broot_qemu=${BROOT}/usr/bin/qemu-$(qemu_arch)
	local root_qemu=${SYSROOT}${broot_qemu}

    _do_root_run "${@}"
}

root_run() {
	if [[ -z ${ROOT} ]]; then
		"${@}"
		return $?
	fi

	local root_run_dir=${ROOT}
	local broot_qemu=${BROOT}/usr/bin/qemu-$(qemu_arch)
	local root_qemu=${ROOT}${broot_qemu}

	if [[ -x ${broot_qemu} && ! -f ${root_qemu} ]]; then
		SANDBOX_WRITE+=":${ROOT}" install -D -m0644 /dev/null "${root_qemu}" ||
			die "Please touch the ${root_qemu} file and retry"
	fi

    _do_root_run "${@}"
}
