# Copyright 1999-2024 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_REPO_URI="git://git.tdb.fi/pmount-gui"
inherit desktop toolchain-funcs git-r3

DESCRIPTION="A simple graphical frontend for pmount"
HOMEPAGE="http://git.tdb.fi/?p=pmount-gui.git;a=summary"

LICENSE="BSD-2"
SLOT="0"

DEPEND="x11-libs/gtk+:2"
RDEPEND="${DEPEND}
	sys-apps/pmount
	virtual/udev"
BDEPEND="virtual/pkgconfig"

src_compile() {
	emake CC="$(tc-getCC) ${CFLAGS} ${LDFLAGS}"
}

src_install() {
	dobin ${PN}
	dodoc README.txt
	make_desktop_entry "${PN} -m"
}
