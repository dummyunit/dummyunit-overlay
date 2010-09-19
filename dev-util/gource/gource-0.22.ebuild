# Copyright 2008-2010 Stanislav Cymbalov
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="Gource is a software version control visualization tool"
HOMEPAGE="http://code.google.com/p/gource/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE="X"

DEPEND=">=media-libs/libsdl-1.2.10[X?,opengl]
	media-libs/sdl-image[png,jpeg]
	>=media-libs/freetype-2.0.9
	>=media-libs/ftgl-2.1.3_rc5
	dev-libs/libpcre"

src_configure() {
	econf $(use_with X x)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README THANKS
}
