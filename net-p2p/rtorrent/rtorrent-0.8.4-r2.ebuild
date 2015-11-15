# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit base eutils toolchain-funcs flag-o-matic user

DESCRIPTION="BitTorrent Client using libtorrent"
HOMEPAGE="http://libtorrent.rakshasa.no/"
SRC_URI="http://libtorrent.rakshasa.no/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ia64 ppc ppc64 ~sparc x86 ~x86-fbsd"
IUSE="screen dtach debug ipv6 xmlrpc"

COMMON_DEPEND=">=net-libs/libtorrent-0.12.${PV##*.}
	>=dev-libs/libsigc++-2.2.2
	>=net-misc/curl-7.19.1
	sys-libs/ncurses
	xmlrpc? ( dev-libs/xmlrpc-c )"
RDEPEND="${COMMON_DEPEND}
	screen? ( app-misc/screen )
	dtach? ( !screen? ( app-misc/dtach ) )"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}/${PN}-0.8.2-gcc34.patch" )

pkg_setup() {
	if use screen && use dtach; then
		ewarn "You can't use app-misc/screen and app-misc/dtach"
		ewarn "with rtorrent at the same time!"
		ewarn "app-misc/screen will be used by default"
	fi
}

src_compile() {
	replace-flags -Os -O2
	append-flags -fno-strict-aliasing

	if [[ $(tc-arch) = "x86" ]]; then
		filter-flags -fomit-frame-pointer -fforce-addr
	fi

	econf	$(use_enable debug) \
		$(use_enable ipv6) \
		$(use_with xmlrpc xmlrpc-c) \
		--disable-dependency-tracking \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS README TODO doc/rtorrent.rc

	if use screen; then
		newinitd "${FILESDIR}/rtorrentd.init.screen" rtorrentd || die "newinitd failed"
		newconfd "${FILESDIR}/rtorrentd.conf.screen" rtorrentd || die "newconfd failed"
	elif use dtach; then
		newinitd "${FILESDIR}/rtorrentd.init.dtach" rtorrentd || die "newinitd failed"
		newconfd "${FILESDIR}/rtorrentd.conf.dtach" rtorrentd || die "newconfd failed"
		exeinto /usr/bin
		doexe "${FILESDIR}/rtorrent-attach" || die "doexe failed"
	fi
}

pkg_postinst() {
	elog "rtorrent now supports a configuration file."
	elog "A sample configuration file for rtorrent can be found"
	elog "in ${ROOT}usr/share/doc/${PF}/rtorrent.rc.gz."
	elog ""
	ewarn "If you're upgrading from rtorrent <0.8.0, you will have to delete your"
	ewarn "session directory or run the fixSession080-c.py script from this address:"
	ewarn "http://rssdler.googlecode.com/files/fixSession080-c.py"
	ewarn "See http://libtorrent.rakshasa.no/wiki/LibTorrentKnownIssues for more info."

	if use screen || use dtach; then
		enewgroup p2p
		enewuser p2p -1 -1 /home/p2p p2p

		elog ""
		elog "Now you must create .rtorrent.rc in /home/p2p"
		elog "It is good idea to add session setting into them"
	fi
	if use dtach && ! use screen; then
		elog ""
		ewarn "Remember, to access daemonized rtorrent via rtorrent-attach you must be in p2p group"
	fi

}
