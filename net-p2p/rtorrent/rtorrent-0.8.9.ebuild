# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/rtorrent/rtorrent-0.8.9.ebuild,v 1.4 2011/11/28 23:27:23 chainsaw Exp $

EAPI=4

inherit autotools-utils eutils

DESCRIPTION="BitTorrent Client using libtorrent"
HOMEPAGE="http://libtorrent.rakshasa.no/"
SRC_URI="http://libtorrent.rakshasa.no/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="color screen dtach debug ipv6 test xmlrpc"

COMMON_DEPEND=">=net-libs/libtorrent-0.12.${PV##*.}
	>=dev-libs/libsigc++-2.2.2:2
	>=net-misc/curl-7.19.1
	sys-libs/ncurses
	xmlrpc? ( dev-libs/xmlrpc-c )"
RDEPEND="${COMMON_DEPEND}
	screen? ( app-misc/screen )
	dtach? ( !screen? ( app-misc/dtach ) )"
DEPEND="${COMMON_DEPEND}
	test? ( dev-util/cppunit )
	dev-util/pkgconfig"

RESTRICT=test

src_prepare() {
	local PATCHES=(
		"${FILESDIR}"/${P}-ncurses.patch
	)
	autotools-utils_src_prepare

	use color && EPATCH_OPTS="-p1" epatch "${FILESDIR}"/${P}-canvas-fix.patch
}

src_configure() {
	local myeconfargs=(
		--disable-dependency-tracking
		$(use_enable debug)
		$(use_enable ipv6)
		$(use_with xmlrpc xmlrpc-c)
	)

	autotools-utils_src_configure
}

src_install() {
	local DOCS=( AUTHORS README TODO doc/rtorrent.rc )

	autotools-utils_src_install
	doman doc/rtorrent.1

	if use daemon; then
		newinitd "${FILESDIR}/rtorrentd.init" rtorrentd
		newconfd "${FILESDIR}/rtorrentd.conf" rtorrentd
	fi
	if use screen; then
		newinitd "${FILESDIR}/rtorrentd.init.screen" rtorrentd
		newconfd "${FILESDIR}/rtorrentd.conf.screen" rtorrentd
	elif use dtach; then
		newinitd "${FILESDIR}/rtorrentd.init.dtach" rtorrentd
		newconfd "${FILESDIR}/rtorrentd.conf.dtach" rtorrentd
		exeinto /usr/bin
		doexe "${FILESDIR}/rtorrent-attach"
	fi
}

pkg_postinst() {
	if use color; then
		elog "rtorrent colors patch"
		elog "Set colors using the options below in .rtorrent.rc:"
		elog "Options: done_fg_color, done_bg_color, active_fg_color, active_bg_color"
		elog "Colors: 0 = black, 1 = red, 2 = green, 3 = yellow, 4 = blue,"
		elog "5 = magenta, 6 = cyan and 7 = white"
		elog "Example: done_fg_color = 1"
	fi

	if use screen || use dtach; then
		enewgroup p2p
		enewuser p2p -1 -1 /home/p2p p2p
		elog "Now you must create .rtorrent.rc in /home/p2p"
		elog "It is good idea to add session setting into them"
	fi
	if use dtach && ! use screen; then
		ewarn "Remember, to access daemonized rtorrent via rtorrent-attach you must be in p2p group"
	fi
}
