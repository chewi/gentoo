# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop meson optfeature prefix readme.gentoo-r1

MY_P="df_${PV//./_}"

DESCRIPTION="Single-player fantasy game"
HOMEPAGE="https://www.bay12games.com/dwarves/"
SRC_URI="https://www.bay12games.com/dwarves/${MY_P}_linux.tar.bz2
	https://dev.gentoo.org/~ionen/distfiles/${PN}.png"
S="${WORKDIR}"

LICENSE="free-noncomm BSD BitstreamVera"
SLOT="0"
KEYWORDS="-* ~amd64"

RDEPEND="
	dev-libs/glib:2
	media-libs/glew:0=
	media-libs/libglvnd[X]
	media-libs/libsdl[joystick,opengl,video]
	media-libs/sdl-image[png]
	media-libs/sdl-ttf
	sys-libs/zlib:=
	virtual/glu"
# libsndfile, openal and ncurses are only needed at compile-time,
# optfeature through dlopen() at runtime if requested
DEPEND="
	${RDEPEND}
	sys-libs/ncurses"

BDEPEND="
	dev-build/meson-format-array
	virtual/pkgconfig
"

QA_PREBUILT="opt/${PN}/libs/Dwarf_Fortress"

PATCHES=(
 	"${FILESDIR}"/${P}-includes.patch
# 	"${FILESDIR}"/${P}-missing-cmath.patch
# 	"${FILESDIR}"/${P}-ncurses6.patch
)

src_prepare() {
	default

	# Windows-only code.
	# Unbundle GLEW.
	# We don't have FMOD.
	rm -r \
		g_src/find_files.cpp g_src/glaiel/ \
		g_src/GL/ \
		g_src/music_and_sound_fmod.cpp

	# Fix includes.
	sed -i 's:\.\./zlib/contrib/minizip/::g' g_src/*.cpp || die

	sed "s:%SOURCES%:$(meson-format-array g_src/*.cpp):" \
		"${FILESDIR}"/meson.build > meson.build || die
}

src_install() {
	insinto /opt/${PN}
	doins -r data libs raw

	fperms +x /opt/${PN}/libs/Dwarf_Fortress

	dobin "$(prefixify_ro "${FILESDIR}"/dwarf-fortress)"

	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry dwarf-fortress "Dwarf Fortress"

	dodoc README.linux *.txt

	local DOC_CONTENTS="
		Dwarf Fortress has been installed to ${EPREFIX}/opt/${PN}. This is
		symlinked to ~/.${PN} when ${PN} is run. For more information on what
		exactly is replaced, see ${EPREFIX}/usr/bin/${PN}. Note: This means
		that the primary entry point is ${EPREFIX}/usr/bin/${PN}, do not run
		${EPREFIX}/opt/${PN}/libs/Dwarf_Fortress."
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog

	optfeature "text PRINT_MODE" sys-libs/ncurses
	optfeature "audio output" "media-libs/openal media-libs/libsndfile[-minimal]"
}
