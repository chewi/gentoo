# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic toolchain-funcs udev

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN/-//}.git"
	SRC_URI=""
else
	# We base our versioning on Raspberry Pi OS
	# Go to https://archive.raspberrypi.org/debian/pool/main/r/raspberrypi-userland/
	# Example:
	# * libraspberrypi-bin-dbgsym_2+git20201022~151804+e432bc3-1_arm64.deb
	# * "e432bc3" is the first 7 hex digits of the commit hash.
	# * Go to https://github.com/raspberrypi/userland/commits/master and find the full hash
	GIT_COMMIT="44a3953fd13d5f0b9b0cd120b904aa7db370244e"
	SRC_URI="https://github.com/raspberrypi/userland/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~arm ~arm64"
	S="${WORKDIR}/userland-${GIT_COMMIT}"
fi

DESCRIPTION="Raspberry Pi userspace tools and libraries"
HOMEPAGE="https://github.com/raspberrypi/userland"

LICENSE="BSD"
SLOT="0"
IUSE="fakekms"

DEPEND=""
RDEPEND="acct-group/video
	!media-libs/raspberrypi-userland-bin"

PATCHES=(
	# Install in $(get_libdir)
	# See https://github.com/raspberrypi/userland/pull/650
	"${FILESDIR}/${PN}-libdir.patch"
	# See https://github.com/raspberrypi/userland/pull/717
	"${FILESDIR}/${PN}-man.patch"
	# Don't install includes that collide.
	"${FILESDIR}/${PN}-include.patch"
	# See https://github.com/raspberrypi/userland/pull/655
	"${FILESDIR}/${PN}-libfdt-static.patch"
	# See https://github.com/raspberrypi/userland/pull/659
	"${FILESDIR}/${PN}-pkgconf-arm64.patch"
)

src_prepare() {
	cmake_src_prepare
	sed -i \
		-e 's:DESTINATION ${VMCS_INSTALL_PREFIX}/src:DESTINATION ${VMCS_INSTALL_PREFIX}/'"share/doc/${PF}:" \
		"${S}/makefiles/cmake/vmcs.cmake" || die "Failed sedding makefiles/cmake/vmcs.cmake"
}

src_configure() {
	append-ldflags $(no-as-needed)

	local mycmakeargs=(
		-DVMCS_INSTALL_PREFIX="${EPREFIX}/opt/vc"
		-DARM64=$(usex arm64)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	udev_dorules "${FILESDIR}/92-local-vchiq-permissions.rules"
}

pkg_postinst() {
	udev_reload
}

pkg_postinst() {
	if ! tc-cross-compiler; then
		if use fakekms; then
			if ! grep -Fq vc4-fkms-v3d /boot/config.txt 2>/dev/null; then
				ewarn "You must add dtoverlay=vc4-fkms-v3d(-pi4) to your /boot/config.txt file"
				ewarn "when fakekms is enabled."
			fi
		else
			if ! grep -Fq vc4-kms-v3d /boot/config.txt 2>/dev/null; then
				ewarn "You must add dtoverlay=vc4-kms-v3d(-pi4) to your /boot/config.txt file"
				ewarn "when fakekms is disabled."
			fi
		fi
	fi
}
