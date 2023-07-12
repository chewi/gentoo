# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/captain-amygdala/pistorm.git"
	inherit git-r3
else
	KEYWORDS="-* ~arm64"
fi

DESCRIPTION="Turbo charge your Commodore Amiga with a Raspberry Pi and PiStorm hardware adapter"
HOMEPAGE="https://github.com/captain-amygdala/pistorm"
LICENSE="MIT"
SLOT="0"
IUSE="pi3 pi4"
REQUIRED_USE="^^ ( pi3 pi4 )"

DEPEND="
	media-libs/alsa-lib
	media-libs/libglvnd
	x11-libs/libdrm
	|| ( media-libs/raspberrypi-userland media-libs/raspberrypi-userland-bin )
"

RDEPEND="
	${DEPEND}
"

PATCHES=(
	"${FILESDIR}"/${PN}-makefile.patch
)

src_compile() {
	emake \
		CC="$(tc-getBUILD_CC)" \
		PKGCONFIG="$(tc-getPKG_CONFIG)" \
		m68kmake

	# local MYCFLAGS=(
	# 	${CXXFLAGS}
	# 	-D_FILE_OFFSET_BITS=64
	# 	-D_LARGEFILE_SOURCE
	# 	-D_LARGEFILE64_SOURCE
	# 	-I.
	# )

	# use pi3 && MYCFLAGS+=(
	# 	-I./raylib
	# )

	# use pi4 && MYCFLAGS+=(
	# 	-DRPI4_TEST
	# 	-I./raylib_pi4_test
	# )

	# emake -j1 \
	# 	CC="$(tc-getCC)" \
	# 	CXX="$(tc-getCXX)" \
	# 	CFLAGS="${MYCFLAGS[*]}"

	emake \
		PKGCONFIG="$(tc-getPKG_CONFIG)" \
		PLATFORM=$(usex pi3 PI3_BULLSEYE PI4)
}
