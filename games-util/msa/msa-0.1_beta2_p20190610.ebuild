# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="The Microsoft Account login daemon"
HOMEPAGE="https://mcpelauncher.readthedocs.io"

# To generate from git repo:
# echo -e "COMMIT=\"$(git rev-parse HEAD)\"\nSRC_URI=\"\n\thttps://github.com/minecraft-linux/\${PN}-manifest/archive/\${COMMIT}.tar.gz -> \${PN}-manifest-\${COMMIT}.tar.gz" && git submodule --quiet foreach --recursive 'url=$(git remote get-url origin); gh=${url#*github.com[:/]}; gh=${gh%.git}; echo -e "\thttps://github.com/${gh}/archive/${sha1}.tar.gz -> ${gh##*/}-${sha1}.tar.gz"' | sort && echo '"'
COMMIT="cc72517977c176641413f40ab0e077a926c6c57b"
SRC_URI="
	https://github.com/minecraft-linux/${PN}-manifest/archive/${COMMIT}.tar.gz -> ${PN}-manifest-${COMMIT}.tar.gz
	https://github.com/MCMrARM/simple-ipc/archive/62c1d5c8040cfbecf5728d901bf066d8fcab5657.tar.gz -> simple-ipc-62c1d5c8040cfbecf5728d901bf066d8fcab5657.tar.gz
	https://github.com/minecraft-linux/arg-parser/archive/96c5e2412fed0e8968aed77f630daae521f613ce.tar.gz -> arg-parser-96c5e2412fed0e8968aed77f630daae521f613ce.tar.gz
	https://github.com/minecraft-linux/base64/archive/1cf21f742e7fda79ff34b60c5d156e290ca7b6c6.tar.gz -> base64-1cf21f742e7fda79ff34b60c5d156e290ca7b6c6.tar.gz
	https://github.com/minecraft-linux/daemon-utils/archive/db43d0b919e5bc079b61fc47acb0fa81f99cf569.tar.gz -> daemon-utils-db43d0b919e5bc079b61fc47acb0fa81f99cf569.tar.gz
	https://github.com/minecraft-linux/file-util/archive/2e0d2f911144cae16e8f59e8ca63064dac6c8997.tar.gz -> file-util-2e0d2f911144cae16e8f59e8ca63064dac6c8997.tar.gz
	https://github.com/minecraft-linux/logger/archive/e882405e4e254ae26bfd512927cd8a2bbb5c408d.tar.gz -> logger-e882405e4e254ae26bfd512927cd8a2bbb5c408d.tar.gz
	https://github.com/minecraft-linux/msa/archive/be51e43efc8e66cba34c542844a2bfbe85e5aab3.tar.gz -> msa-be51e43efc8e66cba34c542844a2bfbe85e5aab3.tar.gz
	https://github.com/minecraft-linux/msa-daemon/archive/d5922bad7d11b1ebba706de2a1f924a1f1a9676c.tar.gz -> msa-daemon-d5922bad7d11b1ebba706de2a1f924a1f1a9676c.tar.gz
	https://github.com/minecraft-linux/msa-daemon-client/archive/2f2130d72f999ab971c764d9ffc3167c8ee761da.tar.gz -> msa-daemon-client-2f2130d72f999ab971c764d9ffc3167c8ee761da.tar.gz
	https://github.com/minecraft-linux/msa-ui-gtk/archive/65e4761a9e6552377f0afae803b631b961a790a1.tar.gz -> msa-ui-gtk-65e4761a9e6552377f0afae803b631b961a790a1.tar.gz
	https://github.com/minecraft-linux/msa-ui-qt/archive/41ac171c387e7c47f5d77680587c10ad1454b542.tar.gz -> msa-ui-qt-41ac171c387e7c47f5d77680587c10ad1454b542.tar.gz
	https://github.com/minecraft-linux/rapidxml/archive/8a5078a97903a91f0931373f3dc04332e19dbd9e.tar.gz -> rapidxml-8a5078a97903a91f0931373f3dc04332e19dbd9e.tar.gz
"

LICENSE="MIT GPL-3 public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk qt5"

RDEPEND="
	dev-libs/openssl:0=
	net-misc/curl[ssl]
	gtk? (
		dev-cpp/gtkmm:3.0
		net-libs/webkit-gtk:4=
	)
	qt5? (
		dev-qt/qtcore:5=
		dev-qt/qtnetwork:5=[ssl]
		dev-qt/qtwebengine:5=[widgets]
		dev-qt/qtwidgets:5=
	)
"

DEPEND="
	${RDEPEND}
	>=dev-cpp/nlohmann_json-3.6.1-r1
"

BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${PN}-manifest-${COMMIT}"

PATCHES=(
	"${FILESDIR}"/nlohmann_json.patch
	"${FILESDIR}"/target_compile_features.patch
)

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
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=OFF
		-DMSA_UI_DEV_PATH=OFF
		-DUSE_OWN_JSON=OFF
		-DENABLE_MSA_GTK_UI=$(usex gtk)
		-DENABLE_MSA_QT_UI=$(usex qt5)
	)

	cmake-utils_src_configure
}
