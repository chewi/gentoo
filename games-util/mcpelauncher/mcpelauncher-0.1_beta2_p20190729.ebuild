# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit cmake-utils python-any-r1

DESCRIPTION="Linux and macOS launcher for Minecraft Bedrock Edition"
HOMEPAGE="https://mcpelauncher.readthedocs.io"

# To generate from git repo:
# echo -e "COMMIT=\"$(git rev-parse HEAD)\"\nSRC_URI=\"\n\thttps://github.com/minecraft-linux/\${PN}-manifest/archive/\${COMMIT}.tar.gz -> \${PN}-manifest-\${COMMIT}.tar.gz" && git submodule --quiet foreach 'url=$(git remote get-url origin); gh=${url#*github.com[:/]}; gh=${gh%.git}; echo -e "\thttps://github.com/${gh}/archive/${sha1}.tar.gz -> ${gh##*/}-${sha1}.tar.gz"' | sort && echo '"'
COMMIT="d9cc8d91dee02792984e215a7e6181cfaefb0fee"
SRC_URI="
	https://github.com/minecraft-linux/${PN}-manifest/archive/${COMMIT}.tar.gz -> ${PN}-manifest-${COMMIT}.tar.gz
	https://github.com/MCMrARM/linux-gamepad/archive/ff0f7d9a5ecf2692c4088b0a16aa479ad2da72a4.tar.gz -> linux-gamepad-ff0f7d9a5ecf2692c4088b0a16aa479ad2da72a4.tar.gz
	https://github.com/MCMrARM/simple-ipc/archive/62c1d5c8040cfbecf5728d901bf066d8fcab5657.tar.gz -> simple-ipc-62c1d5c8040cfbecf5728d901bf066d8fcab5657.tar.gz
	https://github.com/minecraft-linux/arg-parser/archive/96c5e2412fed0e8968aed77f630daae521f613ce.tar.gz -> arg-parser-96c5e2412fed0e8968aed77f630daae521f613ce.tar.gz
	https://github.com/minecraft-linux/base64/archive/1cf21f742e7fda79ff34b60c5d156e290ca7b6c6.tar.gz -> base64-1cf21f742e7fda79ff34b60c5d156e290ca7b6c6.tar.gz
	https://github.com/minecraft-linux/cll-telemetry/archive/f60f11260c29e90ec6ec8bdd409c59d25a1a2c13.tar.gz -> cll-telemetry-f60f11260c29e90ec6ec8bdd409c59d25a1a2c13.tar.gz
	https://github.com/minecraft-linux/daemon-utils/archive/db43d0b919e5bc079b61fc47acb0fa81f99cf569.tar.gz -> daemon-utils-db43d0b919e5bc079b61fc47acb0fa81f99cf569.tar.gz
	https://github.com/minecraft-linux/eglut/archive/3608c8b5a32145a081cbbec6080616c67c5802cf.tar.gz -> eglut-3608c8b5a32145a081cbbec6080616c67c5802cf.tar.gz
	https://github.com/minecraft-linux/epoll-shim/archive/3ae95d8a1eb36b9ad72dcc9a77ac42d54e822e77.tar.gz -> epoll-shim-3ae95d8a1eb36b9ad72dcc9a77ac42d54e822e77.tar.gz
	https://github.com/minecraft-linux/file-picker/archive/54b36967c46fa2e0baf273a422ea010dbe5841db.tar.gz -> file-picker-54b36967c46fa2e0baf273a422ea010dbe5841db.tar.gz
	https://github.com/minecraft-linux/file-util/archive/2e0d2f911144cae16e8f59e8ca63064dac6c8997.tar.gz -> file-util-2e0d2f911144cae16e8f59e8ca63064dac6c8997.tar.gz
	https://github.com/minecraft-linux/game-window/archive/2018e451e8b47d4d73262bfb23c8df103cea380f.tar.gz -> game-window-2018e451e8b47d4d73262bfb23c8df103cea380f.tar.gz
	https://github.com/minecraft-linux/libhybris/archive/8f1ad601d857c56feb5db1482ef3bd9a4230edaa.tar.gz -> libhybris-8f1ad601d857c56feb5db1482ef3bd9a4230edaa.tar.gz
	https://github.com/minecraft-linux/logger/archive/a559598e8c1a6d8ec701b203e141dd74e21518c0.tar.gz -> logger-a559598e8c1a6d8ec701b203e141dd74e21518c0.tar.gz
	https://github.com/minecraft-linux/mcpelauncher-client/archive/a83f857cc106711a30de6a6cc6b9630dc8d44caa.tar.gz -> mcpelauncher-client-a83f857cc106711a30de6a6cc6b9630dc8d44caa.tar.gz
	https://github.com/minecraft-linux/mcpelauncher-common/archive/1709aef9c417f03e03587ef9840a1c5617bfa584.tar.gz -> mcpelauncher-common-1709aef9c417f03e03587ef9840a1c5617bfa584.tar.gz
	https://github.com/minecraft-linux/mcpelauncher-core/archive/d378595b25f276171a16cc08bbc3ef6f360afcd7.tar.gz -> mcpelauncher-core-d378595b25f276171a16cc08bbc3ef6f360afcd7.tar.gz
	https://github.com/minecraft-linux/mcpelauncher-just/archive/96a6b59d1f73abff8bdb3af04a6f7ecbd34cac4f.tar.gz -> mcpelauncher-just-96a6b59d1f73abff8bdb3af04a6f7ecbd34cac4f.tar.gz
	https://github.com/minecraft-linux/mcpelauncher-linux-bin/archive/0a74c99776808f5eb7494c8fc4607558c6ac0bce.tar.gz -> mcpelauncher-linux-bin-0a74c99776808f5eb7494c8fc4607558c6ac0bce.tar.gz
	https://github.com/minecraft-linux/mcpelauncher-mac-bin/archive/1f7ab4c5af6454d1d9641014a0b29594e062829e.tar.gz -> mcpelauncher-mac-bin-1f7ab4c5af6454d1d9641014a0b29594e062829e.tar.gz
	https://github.com/minecraft-linux/mcpelauncher-server/archive/6321ebedba58218231fd9863d31575120c7cd86d.tar.gz -> mcpelauncher-server-6321ebedba58218231fd9863d31575120c7cd86d.tar.gz
	https://github.com/minecraft-linux/minecraft-imported-symbols/archive/d188ac360822c809c631a488921c413081ca2736.tar.gz -> minecraft-imported-symbols-d188ac360822c809c631a488921c413081ca2736.tar.gz
	https://github.com/minecraft-linux/minecraft-symbols/archive/78b62cbaf30996b75751ea579323c9c3d833c52f.tar.gz -> minecraft-symbols-78b62cbaf30996b75751ea579323c9c3d833c52f.tar.gz
	https://github.com/minecraft-linux/msa-daemon-client/archive/2f2130d72f999ab971c764d9ffc3167c8ee761da.tar.gz -> msa-daemon-client-2f2130d72f999ab971c764d9ffc3167c8ee761da.tar.gz
	https://github.com/minecraft-linux/osx-elf-header/archive/3af774abbd9bb006fcbf2636e6b3a61acfd5ff2a.tar.gz -> osx-elf-header-3af774abbd9bb006fcbf2636e6b3a61acfd5ff2a.tar.gz
	https://github.com/minecraft-linux/properties-parser/archive/192f77636099ed1c19b98aa5e7d36ebe6b660883.tar.gz -> properties-parser-192f77636099ed1c19b98aa5e7d36ebe6b660883.tar.gz
"

LICENSE="GPL-3 MIT public-domain fmod"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm ~x86"
IUSE="+client +gui +server"

RDEPEND="
	media-libs/libpng:0=[%]
	client? (
		dev-libs/libevdev[%]
		media-libs/mesa[%,egl]
		net-misc/curl[%,ssl]
		sys-libs/zlib[%]
		virtual/libudev[%]
		x11-libs/libX11[%]
		x11-libs/libXi[%]
	)
"

RDEPEND="
	amd64? ( ${RDEPEND//%/abi_x86_32} )
	!amd64? ( ${RDEPEND//%} )
"

RDEPEND="${RDEPEND//[,/[}"
RDEPEND="${RDEPEND//[]}"

DEPEND="
	${RDEPEND}
	>=dev-cpp/nlohmann_json-3.6.1-r1
	x11-base/xorg-proto
"

BDEPEND="
	virtual/pkgconfig
	arm? ( ${PYTHON_DEPS} )
"

PDEPEND="gui? ( games-util/${PN}-ui )"

S="${WORKDIR}/${PN}-manifest-${COMMIT}"

PATCHES=(
	"${FILESDIR}"/arm.patch
	"${FILESDIR}"/exec-stack.patch
	"${FILESDIR}"/nlohmann_json.patch
	"${FILESDIR}"/optimisation.patch
	"${FILESDIR}"/target_compile_features.patch
)

QA_PREBUILT="usr/share/mcpelauncher/libs/native/libfmod.so.*"

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
	if use arm; then
		pushd minecraft-symbols/tools || die
		"${EPYTHON}" process_headers.py --armhf || die
		popd || die
	fi

	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=OFF
		-DENABLE_DEV_PATHS=OFF
		-DUSE_GAMECONTROLLERDB=OFF
		-DUSE_OWN_CURL=OFF
		-DUSE_OWN_JSON=OFF
		-DBUILD_CLIENT=$(usex client)
		-DBUILD_SERVER=$(usex server)
	)

	cmake-utils_src_configure
}
