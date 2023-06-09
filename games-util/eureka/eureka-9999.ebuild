# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop xdg cmake

DESCRIPTION="Graphical map editor for games using the DOOM engine"
HOMEPAGE="http://eureka-editor.sourceforge.net/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.code.sf.net/p/eureka-editor/git"
else
	SRC_URI="mirror://sourceforge/${PN}-editor/Eureka/${PV%[a-z]}/${P}-source.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${P}-source"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="+opengl"

DEPEND="
	sys-libs/zlib
	x11-libs/fltk:1[opengl?]
	opengl? (
		media-libs/glu
		virtual/opengl
	)
"

RDEPEND="
	${DEPEND}
"

PATCHES=(
	"${FILESDIR}"/${PN}-CMake.patch
	"${FILESDIR}"/${PN}-Makefile.patch
)

DOCS=(
	AUTHORS.txt
	README.txt
	TODO.txt
)

src_configure() {
	local mycmakeargs=(
		-DENABLE_OPENGL=$(usex opengl)
	)

	cmake_src_configure
}

src_install() {
	# No CMake-based install yet so use Makefile.
	ln -snf "${BUILD_DIR}/${PN}" . || die
	emake -o ${PN} install PREFIX="${ED}/usr"
	einstalldocs

	doicon -s 32 misc/${PN}.xpm
	domenu misc/${PN}.desktop
}
