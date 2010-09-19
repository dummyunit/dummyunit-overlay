# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit font

DESCRIPTION="Computer Modern Unicode fonts"
HOMEPAGE="http://canopus.iacp.dvo.ru/~panov/cm-unicode/"
SRC_URI="mirror://sourceforge/cm-unicode/${P}-pfb.tar.xz"

LICENSE="OFL"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=""
DEPEND="app-arch/xz-utils"

FONT_S="${S}"
FONT_SUFFIX="afm pfb"
DOCS="README Changes"

src_unpack() {
	xz -dc ${DISTDIR}/${A} | tar -xof -
}
