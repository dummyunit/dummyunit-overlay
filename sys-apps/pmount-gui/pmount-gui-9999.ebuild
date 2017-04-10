# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_REPO_URI="git://git.tdb.fi/pmount-gui"
inherit eutils toolchain-funcs git-r3

DESCRIPTION="A simple graphical frontend for pmount"
HOMEPAGE="http://git.tdb.fi/?p=pmount-gui.git;a=summary"

LICENSE="BSD-2"
SLOT="0"
IUSE=""

COMMON_DEPEND="x11-libs/gtk+:2"
RDEPEND="${COMMON_DEPEND}
	sys-apps/pmount
	virtual/udev"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"

src_compile() {
	emake CC="$(tc-getCC) ${CFLAGS} ${LDFLAGS}"
}

src_install() {
	dobin ${PN}
	dodoc README.txt
	make_desktop_entry "${PN} -m"
}
