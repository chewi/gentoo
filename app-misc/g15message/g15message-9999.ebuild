# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A simple message/alert client for G15daemon"
HOMEPAGE="https://gitlab.com/menelkir/g15message"
if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/menelkir/g15message.git"
else
	SRC_URI="https://gitlab.com/menelkir/${PN}/-/archive/${PV}/${P}.tar.bz2"
	KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	>=app-misc/g15daemon-3.0
	>=dev-libs/libg15-3.0
	>=dev-libs/libg15render-3.0
	sys-libs/zlib
"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	eautoreconf
}
