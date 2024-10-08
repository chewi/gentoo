# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MLEHMANN
DIST_VERSION=2013
inherit perl-module

DESCRIPTION="Canary to check perl compatibility for schmorp's modules"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

BDEPEND="
	virtual/perl-ExtUtils-MakeMaker
"
src_test() {
	perl-module_src_test
	perl -Mblib="${S}" -M"Canary::Stability ${DIST_VERSION} ()" -e1	||
		die "Could not load Canary::Stability"
}
