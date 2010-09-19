# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/rtorrent/rtorrent-0.8.6-r1.ebuild,v 1.3 2010/04/03 15:54:04 phajdan.jr Exp $

EAPI=2

inherit eutils

DESCRIPTION="BitTorrent Client using libtorrent"
HOMEPAGE="http://libtorrent.rakshasa.no/"
SRC_URI="http://libtorrent.rakshasa.no/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"
IUSE="screen dtach debug ipv6 xmlrpc"

COMMON_DEPEND=">=net-libs/libtorrent-0.12.${PV##*.}
	>=dev-libs/libsigc++-2.2.2:2
	>=net-misc/curl-7.19.1
	sys-libs/ncurses
	xmlrpc? ( dev-libs/xmlrpc-c )"
RDEPEND="${COMMON_DEPEND}
	screen? ( app-misc/screen )
	dtach? ( !screen? ( app-misc/dtach ) )"
DEPEND="${COMMON_DEPEND}
	dev-util/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-canvas-fix.patch
}

src_configure() {
	econf \
		--disable-dependency-tracking \
		$(use_enable debug) \
		$(use_enable ipv6) \
		$(use_with xmlrpc xmlrpc-c)
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS README TODO doc/rtorrent.rc

	if use screen; then
		newinitd "${FILESDIR}/rtorrentd.init.screen" rtorrentd || die
		newconfd "${FILESDIR}/rtorrentd.conf.screen" rtorrentd || die
	elif use dtach; then
		newinitd "${FILESDIR}/rtorrentd.init.dtach" rtorrentd || die
		newconfd "${FILESDIR}/rtorrentd.conf.dtach" rtorrentd || die
		exeinto /usr/bin
		doexe "${FILESDIR}/rtorrent-attach" || die
	fi
}

pkg_postinst() {
	elog "rtorrent colors patch"
	elog "Set colors using the options below in .rtorrent.rc:"
	elog "Options: done_fg_color, done_bg_color, active_fg_color, active_bg_color"
	elog "Colors: 0 = black, 1 = red, 2 = green, 3 = yellow, 4 = blue,"
	elog "5 = magenta, 6 = cyan and 7 = white"
	elog "Example: done_fg_color = 1"

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
