# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils

DESCRIPTION="MessagePack is a binary-based efficient data interchange format"
HOMEPAGE="http://msgpack.org/"
SRC_URI="http://msgpack.org/releases/cpp/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE="static-libs test"

DEPEND="test? ( dev-cpp/gtest )"
RDEPEND=""

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.5.7-fix-empty-struct-pack.patch
	epatch "${FILESDIR}"/${PN}-0.5.7-fix-vrefbuffer-migrate.patch
}

src_configure() {
	econf $(use_enable static-libs static) || die
}

src_install() {
	emake DESTDIR="${D}" install || die

	if ! use static-libs ; then
		find "${ED}" -name '*.la' -exec rm {} +
	fi
	dodoc AUTHORS ChangeLog NEWS README || die
}
