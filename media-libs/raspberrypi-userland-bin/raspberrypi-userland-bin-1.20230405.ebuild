# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_P="raspberrypi-firmware-${PV}"
DESCRIPTION="Raspberry Pi userspace tools and libraries"
HOMEPAGE="https://github.com/raspberrypi/firmware"
SRC_URI="https://github.com/raspberrypi/firmware/archive/${PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/firmware-${PV}"

LICENSE="BSD GPL-2 raspberrypi-videocore-bin"
SLOT="0"
KEYWORDS="-* ~arm"
IUSE="examples"
RESTRICT="strip"

RDEPEND="!media-libs/raspberrypi-userland"

QA_PREBUILT="opt/vc"

src_install() {
	cd $([[ $(tc-is-softfloat) = no ]] && echo hardfp/)opt/vc || die

	insinto /opt/vc
	doins -r include

	into /opt
	dobin bin/*

	insopts -m 0755
	insinto /opt/vc/lib
	doins -r lib/*

	doenvd "${FILESDIR}"/04${PN}

	if use examples ; then
		insopts -m 0644
		docinto examples
		dodoc -r src/hello_pi
	fi
}
