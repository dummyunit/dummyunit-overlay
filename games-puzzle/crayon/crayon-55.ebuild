# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit games

DESCRIPTION="Crayon Physics Deluxe is a 2D physics puzzle/sandbox game"
HOMEPAGE="http://crayonphysics.com/"
SRC_URI="crayon_physics_deluxe-linux-release${PV}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

RDEPEND="
	amd64? (
		app-emulation/emul-linux-x86-opengl
		app-emulation/emul-linux-x86-qtlibs
		app-emulation/emul-linux-x86-xlibs
	)
	x86? (
		media-libs/libsdl[opengl]
		media-libs/sdl-image[png]
		media-libs/sdl-mixer[vorbis]
		virtual/opengl
		virtual/glu
		x11-libs/qt-core:4
		x11-libs/qt-qui:4
		x11-libs/libX11
	)
"
DEPEND=""

S="${WORKDIR}/CrayonPhysicsDeluxe"

QA_PRESTRIPPED="${GAMES_PREFIX_OPT}/${PN}/crayon"

pkg_nofetch() {
	einfo "Please download ${A} and place it into ${DISTDIR}"
}

src_install() {
	local dir="${GAMES_PREFIX_OPT}/${PN}"

	insinto "${dir}"
	doins -r data cache autoexec.txt

	exeinto "${dir}"
	doexe crayon

	games_make_wrapper "${PN}" ./crayon "${dir}"
	newicon icon.png "${PN}.png" || die
	make_desktop_entry "${PN}" "Crayon Physics Deluxe" "${PN}"

	dodoc changelog.txt
	dohtml readme.html
	prepgamesdirs
}
