# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools linux-info user systemd

DESCRIPTION="BitTorrent Client using libtorrent"
HOMEPAGE="https://rakshasa.github.io/rtorrent/"
SRC_URI="http://rtorrent.net/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris"
IUSE="daemon dtach debug selinux test xmlrpc"
RESTRICT="!test? ( test )"

COMMON_DEPEND="~net-libs/libtorrent-0.13.${PV##*.}
	>=net-misc/curl-7.19.1
	sys-libs/ncurses:0=
	xmlrpc? ( dev-libs/xmlrpc-c )"
RDEPEND="${COMMON_DEPEND}
	daemon? ( dtach? ( app-misc/dtach ) !dtach? ( app-misc/screen ) )
	selinux? ( sec-policy/selinux-rtorrent )
"
DEPEND="${COMMON_DEPEND}
	dev-util/cppunit
	virtual/pkgconfig"

DOCS=( doc/rtorrent.rc )

pkg_setup() {
	if ! linux_config_exists || ! linux_chkconfig_present IPV6; then
		ewarn "rtorrent will not start without IPv6 support in your kernel"
		ewarn "without further configuration. Please set bind=0.0.0.0 or"
		ewarn "similar in your rtorrent.rc"
		ewarn "Upstream bug: https://github.com/rakshasa/rtorrent/issues/732"
	fi
}

src_prepare() {
	default

	# https://github.com/rakshasa/rtorrent/issues/332
	cp "${FILESDIR}"/rtorrent.1 "${S}"/doc/ || die

	eautoreconf
}

src_configure() {
	default

	# configure needs bash or script bombs out on some null shift, bug #291229
	CONFIG_SHELL=${BASH} econf \
		--disable-dependency-tracking \
		$(use_enable debug) \
		$(use_with xmlrpc xmlrpc-c)
}

src_install() {
	default
	doman doc/rtorrent.1

	if use daemon; then
		if use dtach; then
			newinitd "${FILESDIR}/rtorrentd.init.dtach" rtorrentd
			newconfd "${FILESDIR}/rtorrentd.conf.dtach" rtorrentd
			exeinto /usr/bin
			doexe "${FILESDIR}/rtorrent-attach"
		else
			newinitd "${FILESDIR}/rtorrentd.init" rtorrentd
			newconfd "${FILESDIR}/rtorrentd.conf" rtorrentd
			systemd_newunit "${FILESDIR}/rtorrentd_at.service" "rtorrentd@.service"
		fi
	fi
}

pkg_postinst() {
	if use daemon; then
		enewgroup p2p
		enewuser p2p -1 -1 /home/p2p p2p
		elog "Now you must create .rtorrent.rc in /home/p2p"
		elog "It is good idea to add session setting into them"
	fi
	if use dtach; then
		ewarn "Remember, to access daemonized rtorrent via rtorrent-attach you must be in p2p group"
	fi
}
