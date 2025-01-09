# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit crossdev

DESCRIPTION="Symlinks to a Clang crosscompiler"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:LLVM"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~arm64-macos ~x64-macos"

_doclang_cfg() {
	local triple=$1 tool vendor
	insinto /etc/clang

	for tool in clang{,++,-cpp}; do
		# Install wrappers rather than symlinks so that further includes read
		# from the correct directory.
		newins - "${CTARGET}-${tool}.cfg" <<-EOF
			--sysroot=${EPREFIX}/usr/${triple}
			@${EPREFIX}/usr/${triple}/etc/clang/${CTARGET}-${tool}.cfg
		EOF

		# Install wrappers for triples with other vendor strings since some
		# programs insist on mangling the triple.
		for vendor in gentoo pc unknown; do
			local vendor_triple="${triple%%-*}-${vendor}-${triple#*-*-}"
			if [[ ! -f "${ED}/etc/clang/${vendor_triple}-${tool}.cfg" ]]; then
				newins - "${vendor_triple}-${tool}.cfg" <<-EOF
					--sysroot=${EPREFIX}/usr/${triple}
					@${EPREFIX}/usr/${triple}/etc/clang/${vendor_triple}-${tool}.cfg
				EOF
			fi
		done
	done
}

doclang_cfg() {
	local triple="${1}"

	_doclang_cfg ${triple}

	# LLVM may have different arch names in some cases. For example in x86
	# profiles the triple uses i686, but llvm will prefer i386 if invoked
	# with "clang" on x86 or "clang -m32" on x86_64. The gentoo triple will
	# be used if invoked through ${CHOST}-clang{,++,-cpp} though.
	#
	# To make sure the correct triples are installed,
	# see Triple::getArchTypeName() in llvm/lib/TargetParser/Triple.cpp
	# and compare with CHOST values in profiles.

	local abi=${triple%%-*}
	case ${abi} in
		armv4l|armv4t|armv5tel|armv6j|armv7a)
			_doclang_cfg ${triple/${abi}/arm}
			;;
		i686)
			_doclang_cfg ${triple/${abi}/i386}
			;;
		sparc)
			_doclang_cfg ${triple/${abi}/sparcel}
			;;
		sparc64)
			_doclang_cfg ${triple/${abi}/sparcv9}
			;;
	esac
}

src_install() {
	doclang_cfg "${CTARGET}"
}

pkg_preinst() {
	if has_version -b sys-devel/gcc-config && has_version "${CATEGORY}/gcc"
	then
		local gcc_path=$(gcc-config --get-lib-path 2>/dev/null)
		if [[ -n ${gcc_path} ]]; then
			insinto /usr/"${CTARGET}"/etc/clang
			newins - gentoo-gcc-install.cfg <<-EOF
				--gcc-install-dir="${gcc_path%%:*}"
			EOF
		fi
	fi
}
