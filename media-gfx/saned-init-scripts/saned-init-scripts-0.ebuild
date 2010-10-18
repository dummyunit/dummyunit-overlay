# Copyright 2010 Stanislav Cymbalov
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit eutils

DESCRIPTION="Init script for saned"
HOMEPAGE="http://www.sane-project.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-gfx/sane-backends-1.0.20"
RDEPEND="${DEPEND}"

pkg_setup() {
	enewuser saned -1 -1 -1 scanner
}

src_install() {
	newinitd "${FILESDIR}/saned.initd" "saned"
}
