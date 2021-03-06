# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit eutils

DESCRIPTION="Cogs gives the player mechanical structures that need to be fixed in order to function properly"
HOMEPAGE="http://www.cogsgame.com/"
SRC_URI="${PN}_${PV}_all.tar.gz"
RESTRICT="fetch"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

RDEPEND="
	media-libs/libsdl[alsa,opengl]
	media-libs/openal[alsa]
	"
DEPEND=""

S="${WORKDIR}/${PN}"

pkg_nofetch() {
	einfo "Please download ${A} and place it into ${DISTDIR}"
}

src_install() {
	local dir="/opt/${PN}"

	insinto "${dir}"
	doins -r data

	exeinto "${dir}"
	local exe
	if use amd64 ; then
		exe=Cogs-amd64
	elif use x86 ; then
		exe=Cogs-x86
	fi
	doexe "${exe}"

	make_wrapper "${PN}" "./${exe}" "${dir}"
	doicon "${PN}.png" || die
	make_desktop_entry "${PN}" "Cogs" "${PN}"

	dodoc README-linux.txt
}
