# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cmake-utils

EAPI=3

DESCRIPTION="Qt gui for google translate based on ajax api"
HOMEPAGE="http://code.google.com/p/qgt/"
SRC_URI="http://qgt.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	x11-libs/qt-gui:4
	x11-libs/qt-gui:4
	>=x11-libs/libqxt-0.6.0
	dev-libs/qjson"
RDEPEND="${DEPEND}"

src_prepare() {
	find ${S} -type d -name ".svn" -exec rm -rf '{}' \; 2>/dev/null
}

src_install() {
	cmake-utils_src_install

	dodoc WISHLIST.txt
}
