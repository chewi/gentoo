# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Simple and easy-to-use library to enjoy videogames programming"
HOMEPAGE="https://www.raylib.com"
SRC_URI="https://github.com/raysan5/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="+desktop drm raspberry-pi"
REQUIRED_USE="^^ ( desktop drm raspberry-pi )"

DEPEND="
	desktop? (
		media-libs/glfw
	)
	drm? (
		media-libs/libglvnd
		media-libs/mesa
		x11-libs/libdrm
	)
	raspberry-pi? (
		|| ( media-libs/raspberrypi-userland media-libs/raspberrypi-userland-bin )
	)
"

RDEPEND="
	${DEPEND}
"

src_configure() {
	local mycmakeargs=(
		-DBUILD_EXAMPLES=OFF
		-DUSE_EXTERNAL_GLFW=ON
	)

	if use desktop; then
		mycmakeargs+=( -DPLATFORM=Desktop )
	elif use drm; then
		mycmakeargs+=( -DPLATFORM=DRM )
	elif use raspberry-pi; then
		mycmakeargs+=( -DPLATFORM="Raspberry Pi" )
	else
		die "No platform USE flag enabled"
	fi

	cmake_src_configure
}
