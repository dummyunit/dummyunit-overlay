# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_REPO_URI="https://github.com/mariusaeriksen/trickle"
inherit autotools git-r3

DESCRIPTION="Portable lightweight userspace bandwidth shaper"
HOMEPAGE="https://github.com/mariusaeriksen/trickle"

LICENSE="BSD"
SLOT="0"

RDEPEND="
	dev-libs/libevent
	net-libs/libtirpc
"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	sed -ie '/^overload_DATA *=/d' Makefile.am || die 'sed failed'
	sed -ie "/^AM_CFLAGS *=/ a\AM_CFLAGS += -I /usr/include/tirpc\nAM_LDFLAGS = -ltirpc" Makefile.am || die 'sed failed'
	eautoreconf
}
