# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Linux firmware files"
HOMEPAGE="http://www.kernel.org/pub/linux/kernel/people/dwmw2/firmware"
SRC_URI="mirror://kernel/linux/kernel/people/dwmw2/firmware/${P}.tar.bz2"

LICENSE="GPL-1 GPL-2 GPL-3 BSD freedist"
KEYWORDS="~amd64 ~x86"
SLOT="0"

src_unpack() {
	unpack ${A}
}

src_install() {
	dodir /lib/firmware
	cp -R "${S}/"* "${D}lib/firmware/" || die "Install failed!"
}
