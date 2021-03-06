# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

# ebuild generated by hackport 0.4.3

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

DESCRIPTION="http-client backend using the connection package and tls library"
HOMEPAGE="https://github.com/snoyberg/http-client"
SRC_URI="https://hackage.haskell.org/package/${P}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=dev-haskell/connection-0.2.2:=[profile?]
	dev-haskell/data-default-class:=[profile?]
	>=dev-haskell/http-client-0.3.5:=[profile?]
	dev-haskell/network:=[profile?]
	>=dev-haskell/tls-1.1:=[profile?]
	>=dev-lang/ghc-7.4.1:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.10
	test? ( dev-haskell/hspec
		dev-haskell/http-types )
"

# The only test in the suite requires internet access.
RESTRICT="test"
