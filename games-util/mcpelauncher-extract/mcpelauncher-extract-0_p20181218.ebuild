# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils multilib

DESCRIPTION="Tool to extract Minecraft Bedrock Edition Android APKs"
HOMEPAGE="https://mcpelauncher.readthedocs.io"

COMMIT="586011d9d78cc9a9fdfb03fa9453a3d9ae0dddde"
SRC_URI="https://github.com/minecraft-linux/${PN}/archive/${COMMIT}.tar.gz -> ${PN}-${COMMIT}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

DEPEND="dev-libs/libzip:="
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${PN}-${COMMIT}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=OFF
	)

	cmake-utils_src_configure
}

src_install() {
	dobin "${BUILD_DIR}/${PN}$(get_exeext)"
}
