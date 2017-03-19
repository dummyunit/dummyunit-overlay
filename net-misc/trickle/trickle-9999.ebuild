# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

EGIT_REPO_URI="git://github.com/mariusaeriksen/trickle.git"
inherit autotools git-r3

DESCRIPTION="Portable lightweight userspace bandwidth shaper"
HOMEPAGE="https://github.com/mariusaeriksen/trickle"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-libs/libevent"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -ie '/^overload_DATA *=/d' Makefile.am || die 'sed failed'
	eautoreconf
}
