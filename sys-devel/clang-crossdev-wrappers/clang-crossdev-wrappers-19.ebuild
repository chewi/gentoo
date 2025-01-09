# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit crossdev llvm-utils

DESCRIPTION="Symlinks to a Clang crosscompiler"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:LLVM"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~arm64-macos ~x64-macos"

RDEPEND="
	>=${CATEGORY}/clang-crossdev-common-${PV}
	llvm-core/clang:${SLOT}[llvm_targets_$(llvm_tuple_to_target "${CTARGET}")]
	llvm-core/lld:${SLOT}
"

src_install() {
	local llvm_path="${EPREFIX}/usr/lib/llvm/${SLOT}"
	into "${llvm_path}"

	local tool
	for tool in clang{,++,-cpp}; do
		newbin - "${CTARGET}-${tool}" <<-EOF
		#!/bin/sh
		exec ${tool}-${SLOT} --target="${CTARGET}" \${@}
		EOF

		dosym "${CTARGET}-${tool}" "${llvm_path}/bin/${CTARGET}-${tool}-${SLOT}"
	done
}
