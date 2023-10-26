# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

GIT_COMMIT="1f1d0ccd65d3a1caa86dc79d2863a8f067c8e3f8"
DESCRIPTION="Command line media player for the Raspberry Pi"
HOMEPAGE="https://github.com/popcornmix/omxplayer"
SRC_URI="https://github.com/popcornmix/omxplayer/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm"
IUSE="X"

DEPEND="
	dev-libs/boost:=
	dev-libs/libpcre:3
	media-libs/freetype:2
	media-video/ffmpeg:=
	sys-apps/dbus
	|| ( media-libs/raspberrypi-userland[fakekms] media-libs/raspberrypi-userland-bin[fakekms] )
"

RDEPEND="
	${DEPEND}
	media-fonts/freefont
	sys-apps/fbset
	X? (
		x11-apps/xrefresh
		x11-apps/xset
	)
"

BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/fonts-path.patch
)

DOCS=( README.md )

S="${WORKDIR}/omxplayer-${GIT_COMMIT}"

src_prepare() {
	default
	cat > Makefile.include << EOF
LIBS=-lvchostif -lvchiq_arm -lvcos -lbcm_host -lEGL -lGLESv2 -lopenmaxil -lrt -lpthread
EOF

	tc-export CXX PKG_CONFIG
}

src_compile() {
	emake omxplayer.bin
}

src_install() {
	dobin omxplayer omxplayer.bin
	einstalldocs
}
