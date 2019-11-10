# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit python-any-r1 toolchain-funcs

COMMIT="b0d91bb797a64cda71ecb64d7ffa860f6d2ee442"
DESCRIPTION="QEMU plugin for the UAE Amiga emulator providing SLIRP and PPC support"
HOMEPAGE="https://fs-uae.net/"
SRC_URI="https://github.com/FrodeSolheim/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2 LGPL-2 BSD-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"

RDEPEND="
	dev-libs/glib:2
	>=sys-apps/dtc-1.4.0
	sys-libs/zlib
	>=x11-libs/pixman-0.28.0
"

DEPEND="
	${RDEPEND}
	~app-emulation/fs-uae-2.8.3
"

BDEPEND="
	${PYTHON_DEPS}
	virtual/pkgconfig
"

S="${WORKDIR}/${PN}-${COMMIT}"

src_configure() {
	./configure \
		--cc="$(tc-getCC)" \
		--cxx="$(tc-getCXX)" \
		--host-cc="$(tc-getBUILD_CC)" \
		--python="${PYTHON}" \
		--with-system-pixman
}

src_install() {
	dolib.so ${PN}.so
}
