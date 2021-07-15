# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

EGIT_REPO_URI="https://github.com/mariusaeriksen/trickle"
inherit autotools git-r3

DESCRIPTION="Portable lightweight userspace bandwidth shaper"
HOMEPAGE="https://github.com/mariusaeriksen/trickle"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	dev-libs/libevent
	net-libs/libtirpc
"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -ie '/^overload_DATA *=/d' Makefile.am || die 'sed failed'
	sed -ie "/^AM_CFLAGS *=/ a\AM_CFLAGS += -I /usr/include/tirpc\nAM_LDFLAGS = -ltirpc" Makefile.am || die 'sed failed'
	eautoreconf
}
