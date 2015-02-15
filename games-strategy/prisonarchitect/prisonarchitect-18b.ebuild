# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit games

MY_P="${PN}-alpha${PV}-linux"

DESCRIPTION="A prison construction and management simulation game"
HOMEPAGE="http://www.introversion.co.uk/prisonarchitect"
SRC_URI="${MY_P}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="fetch"

RDEPEND="media-libs/libsdl
	virtual/opengl
	virtual/glu"
DEPEND=""

S="${WORKDIR}/${MY_P}"

INSTALL_DIR="${GAMES_PREFIX_OPT}/${PN}"
QA_PREBUILT="${INSTALL_DIR}/PrisonArchitect.*"

pkg_nofetch() {
	ewarn
	ewarn "Download ${A} from http://www.introversion.co.uk/prisonarchitect/builds.html"
	ewarn "and place it to ${DISTDIR}"
	ewarn
}

src_install() {
	insinto "${INSTALL_DIR}"
	doins *.dat

	exeinto "${INSTALL_DIR}"
	use amd64 && doexe PrisonArchitect.x86_64
	use x86   && doexe PrisonArchitect.i686
	doexe PrisonArchitect

	games_make_wrapper "${PN}" "${INSTALL_DIR}/PrisonArchitect"
	prepgamesdirs
}