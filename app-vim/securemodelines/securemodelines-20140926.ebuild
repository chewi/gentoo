# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit vim-plugin

DESCRIPTION="vim plugin: secure, user-configurable modeline support"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=1876 https://github.com/ciaranm/securemodelines"
LICENSE="vim"
KEYWORDS="~alpha amd64 ~arm64 ~hppa ~mips ppc ppc64 sparc x86"

VIM_PLUGIN_HELPTEXT="Make sure that you disable vim's builtin modeline support if you have
enabled it in your .vimrc."
