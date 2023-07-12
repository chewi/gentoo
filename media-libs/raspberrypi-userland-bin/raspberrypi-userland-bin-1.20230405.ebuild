# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit prefix toolchain-funcs

MY_P="raspberrypi-firmware-${PV}"
DESCRIPTION="Raspberry Pi userspace tools and libraries"
HOMEPAGE="https://github.com/raspberrypi/firmware"
SRC_URI="https://github.com/raspberrypi/firmware/archive/${PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/firmware-${PV}"

LICENSE="BSD GPL-2 raspberrypi-videocore-bin"
SLOT="0"
KEYWORDS="-* ~arm"
IUSE="examples fakekms"
REQUIRED_USE="examples? ( fakekms )"
RESTRICT="strip"

RDEPEND="!media-libs/raspberrypi-userland"

QA_PREBUILT="opt/vc/*"

cdvc() {
	cd $([[ $(tc-is-softfloat) = no ]] && echo hardfp/)opt/vc || die
}

src_prepare() {
	default
	cdvc

	if ! use fakekms; then
		rm -rv \
			bin/raspistill \
			include/{EGL,GLES,GLES2,IL,KHR,VG,WF}/ \
			include/interface/mmal/util/mmal_il.h \
			include/interface/vmcs_host/{khronos/,*ilcs*.h} \
			lib/lib*{EGL,GLES,khrn_static,openmaxil,OpenVG,vcilcs,WFC}* \
			lib/pkgconfig/brcm{egl,glesv2,vg}.pc \
			|| die
	fi

	hprefixify lib/pkgconfig/*.pc
}

src_install() {
	cdvc

	into /opt
	dobin bin/*

	insinto /opt/vc
	doins -r include/

	into /opt/vc
	dolib.a lib/*.a
	dolib.so lib/*.so

	exeinto /opt/vc/lib/plugins
	doexe lib/plugins/*.so

	insinto /usr/$(get_libdir)/pkgconfig
	doins lib/pkgconfig/*.pc

	doenvd $(prefixify_ro "${FILESDIR}"/04${PN})

	if use examples ; then
		docinto examples
		dodoc -r src/hello_pi/
	fi
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
