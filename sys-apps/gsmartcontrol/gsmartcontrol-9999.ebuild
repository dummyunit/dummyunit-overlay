# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit flag-o-matic gnome2-utils

DESCRIPTION="Hard disk drive health inspection tool"
HOMEPAGE="http://gsmartcontrol.sourceforge.net/home/"

if [[ ${PV} == "9999" ]] ; then
	inherit subversion
	ESVN_REPO_URI="https://svn.code.sf.net/p/${PN}/code/trunk/${PN}"
	KEYWORDS=""
else
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
	KEYWORDS="amd64 x86"
fi

LICENSE="|| ( GPL-2 GPL-3 ) Boost-1.0 BSD Unlicense ZLIB"
SLOT="0"
IUSE="test"

COMMON_DEPEND="
	dev-cpp/gtkmm:3.0
	dev-libs/libpcre:3
	sys-apps/smartmontools
"
RDEPEND="${COMMON_DEPEND}
	x11-apps/xmessage
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	test? ( dev-util/gtk-builder-convert )
"

DOCS="TODO" # See 'dist_doc_DATA' value in Makefile.am

src_prepare() {
	default
	append-cxxflags -std=c++11
	if [[ ${PV} == "9999" ]]; then
		./autogen.sh || die "autogen.sh failed"
	fi
}

src_configure() {
	econf $(use test tests)
}

src_install() {
	default
	rm -f "${ED}"/usr/share/doc/${PF}/LICENSE_* || die
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
