# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit versionator

MY_PV=$(replace_all_version_separators _)

DESCRIPTION="Jamfiles needed to build Boost libraries"
HOMEPAGE="http://www.boost.org/"
SRC_URI="mirror://sourceforge/boost/boost_${MY_PV}.tar.bz2"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND=""
DEPEND="~dev-libs/boost-${PV}"

S=${WORKDIR}/boost_${MY_PV}

src_unpack() {
	tar xjpf "${DISTDIR}/${A}" boost_${MY_PV}/{Jamroot,boostcpp.jam}
}

src_prepare() {
	epatch "${FILESDIR}/remove-toolset-1.48.0.patch"
}

src_install() {
	insinto "/usr/share/${PN}"
	doins Jamroot boostcpp.jam
}
