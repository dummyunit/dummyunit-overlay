# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Init script for www-misc/fcgiwrap"
HOMEPAGE="http://www.gentoo.org/"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="www-misc/fcgiwrap"
DEPEND=""

S="${WORKDIR}"

src_install() {
	newinitd "${FILESDIR}/fcgiwrap.initd" fcgiwrap
	newconfd "${FILESDIR}/fcgiwrap.confd" fcgiwrap
}
