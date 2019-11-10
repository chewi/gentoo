# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils xdg-utils

DESCRIPTION="Qt-based GUI for the Minecraft Bedrock Edition launcher"
HOMEPAGE="https://mcpelauncher.readthedocs.io"

# To generate from git repo:
# echo -e "COMMIT=\"$(git rev-parse HEAD)\"\nSRC_URI=\"\n\thttps://github.com/minecraft-linux/\${PN}-manifest/archive/\${COMMIT}.tar.gz -> \${PN}-manifest-\${COMMIT}.tar.gz" && git submodule --quiet foreach --recursive 'url=$(git remote get-url origin); gh=${url#*github.com[:/]}; gh=${gh%.git}; echo -e "\thttps://github.com/${gh}/archive/${sha1}.tar.gz -> ${gh##*/}-${sha1}.tar.gz"' | sort && echo '"'
COMMIT="98ac412221a1056916ff5550ad66fedc157c03d2"
SRC_URI="
	https://github.com/minecraft-linux/${PN}-manifest/archive/${COMMIT}.tar.gz -> ${PN}-manifest-${COMMIT}.tar.gz
	https://github.com/MCMrARM/axml-parser/archive/e5d26109797c69d66260097b315446e774bc3639.tar.gz -> axml-parser-e5d26109797c69d66260097b315446e774bc3639.tar.gz
	https://github.com/MCMrARM/Google-Play-API/archive/513ffa394b7087b4f5a4a1c0ab9b9a5475525c48.tar.gz -> Google-Play-API-513ffa394b7087b4f5a4a1c0ab9b9a5475525c48.tar.gz
	https://github.com/minecraft-linux/file-util/archive/a7d2593eee0e704027bbba28f875657cf282bd9b.tar.gz -> file-util-a7d2593eee0e704027bbba28f875657cf282bd9b.tar.gz
	https://github.com/minecraft-linux/mcpelauncher-apkinfo/archive/04dd54b096697c7ad406742762e9c03a62f047f8.tar.gz -> mcpelauncher-apkinfo-04dd54b096697c7ad406742762e9c03a62f047f8.tar.gz
	https://github.com/minecraft-linux/mcpelauncher-extract/archive/586011d9d78cc9a9fdfb03fa9453a3d9ae0dddde.tar.gz -> mcpelauncher-extract-586011d9d78cc9a9fdfb03fa9453a3d9ae0dddde.tar.gz
	https://github.com/minecraft-linux/mcpelauncher-proprietary/archive/8f82fc42ab5ed8b943eec5255ac07048bc3e46d8.tar.gz -> mcpelauncher-proprietary-8f82fc42ab5ed8b943eec5255ac07048bc3e46d8.tar.gz
	https://github.com/minecraft-linux/mcpelauncher-ui-qt/archive/eac58c4e289da75f1d76e04a97142bfe18bf0cfd.tar.gz -> mcpelauncher-ui-qt-eac58c4e289da75f1d76e04a97142bfe18bf0cfd.tar.gz
	https://github.com/minecraft-linux/playdl-signin-ui-qt/archive/20c9f5bf5d8538210b72415935d80f9315f7e85e.tar.gz -> playdl-signin-ui-qt-20c9f5bf5d8538210b72415935d80f9315f7e85e.tar.gz
"

LICENSE="GPL-3 MIT public-domain"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"

DEPEND="
	dev-libs/libuv:=
	dev-libs/libzip:=
	dev-libs/protobuf:=
	dev-qt/qtcore:5=
	dev-qt/qtconcurrent:5=
	dev-qt/qtnetwork:5=[ssl]
	dev-qt/qtsvg:5=
	dev-qt/qtwebengine:5=[widgets]
	dev-qt/qtwidgets:5=
	net-misc/curl[ssl]
	sys-libs/zlib
"

RDEPEND="
	${DEPEND}
	dev-qt/qtquickcontrols:5
	dev-qt/qtquickcontrols2:5
	games-util/${PN%-ui}
"

BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${PN}-manifest-${COMMIT}"

src_unpack() {
	default

	# This assumes all the submodules are in the top-level directory and
	# that their directory names match their GitHub project names.
	local SRC DST
	for SRC in */; do
		DST=${SRC%-*}
		DST=${DST,,}
		if rmdir "${S}/${DST}" 2>/dev/null; then
			mv "${SRC}" "${S}/${DST}" || die
		fi
	done

	# This submodule is a special case.
	DST=mcpelauncher-ui-qt/Resources/proprietary
	rmdir "${S}/${DST}" || die
	mv mcpelauncher-proprietary-* "${S}/${DST}" || die
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=OFF
	)

	cmake-utils_src_configure
}

pkg_postinst() { xdg_icon_cache_update; }
pkg_postrm() { xdg_icon_cache_update; }
