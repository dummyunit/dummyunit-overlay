# Copyright 1999-2024 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop toolchain-funcs

if [[ ${PV} = *9999 ]]; then
	EGIT_REPO_URI="git://git.tdb.fi/pmount-gui"
	inherit git-r3
else
	COMMIT=b70580815b02ba5ccf83d8d96c5138afbc7124ae
	SRC_URI="http://git.tdb.fi/?p=pmount-gui.git;a=snapshot;h=${COMMIT};sf=tgz -> ${P}.tar.gz"
	S="${WORKDIR}"/${PN}-${COMMIT:0:7}
	KEYWORDS="~amd64 ~x86"
fi

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
