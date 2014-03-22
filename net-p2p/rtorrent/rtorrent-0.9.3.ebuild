# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils user

DESCRIPTION="BitTorrent Client using libtorrent"
HOMEPAGE="http://libtorrent.rakshasa.no/"
SRC_URI="http://libtorrent.rakshasa.no/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris"
IUSE="screen dtach debug ipv6 test xmlrpc"

COMMON_DEPEND="~net-libs/libtorrent-0.13.${PV##*.}
	>=dev-libs/libsigc++-2.2.2:2
	>=net-misc/curl-7.19.1
	sys-libs/ncurses
	xmlrpc? ( dev-libs/xmlrpc-c )"
RDEPEND="${COMMON_DEPEND}
	screen? ( app-misc/screen )
	dtach? ( !screen? ( app-misc/dtach ) )"
DEPEND="${COMMON_DEPEND}
	test? ( dev-util/cppunit )
	virtual/pkgconfig"

DOCS=( doc/rtorrent.rc )

src_prepare() {
	# bug #358271
	epatch "${FILESDIR}"/${PN}-0.9.1-ncurses.patch

	# upstream forgot to include
	cp ${FILESDIR}/rtorrent.1 ${S}/doc/ || die
}

src_configure() {
	# configure needs bash or script bombs out on some null shift, bug #291229
	CONFIG_SHELL=${BASH} econf \
		--disable-dependency-tracking \
		$(use_enable debug) \
		$(use_enable ipv6) \
		$(use_with xmlrpc xmlrpc-c)
}

src_install() {
	default
	doman doc/rtorrent.1

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
