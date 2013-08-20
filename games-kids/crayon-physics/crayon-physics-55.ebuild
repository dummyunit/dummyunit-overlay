# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils gnome2-utils games

DESCRIPTION="2D physics puzzle/sandbox game with drawing"
HOMEPAGE="http://www.crayonphysics.com/"
SRC_URI="crayon_physics_deluxe-linux-release${PV}.tar.gz"

LICENSE="CRAYON-PHYSICS"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""
RESTRICT="bindist fetch splitdebug"

MYGAMEDIR=${GAMES_PREFIX_OPT}/${PN}
QA_PREBUILT="${MYGAMEDIR#/}/crayon"

RDEPEND="
	virtual/opengl
	amd64? (
		app-emulation/emul-linux-x86-opengl
		app-emulation/emul-linux-x86-qtlibs
		app-emulation/emul-linux-x86-sdl
		app-emulation/emul-linux-x86-xlibs
	)
	x86? (
		media-libs/libsdl:0[X,audio,video,opengl]
		media-libs/sdl-image[png,jpeg]
		media-libs/sdl-mixer[vorbis,wav]
		virtual/glu
		dev-qt/qtcore:4
		dev-qt/qtgui:4
		x11-libs/libX11
	)"

S=${WORKDIR}/CrayonPhysicsDeluxe

pkg_nofetch() {
	einfo "Please buy & download ${SRC_URI} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to ${DISTDIR}"
	einfo
}

src_install() {
	insinto "${MYGAMEDIR}"
	doins -r cache data crayon autoexec.txt version.xml

	newicon -s 256 icon.png ${PN}.png
	make_desktop_entry ${PN}
	games_make_wrapper ${PN} "./crayon" "${MYGAMEDIR}"

	dodoc changelog.txt linux_hotfix_notes.txt
	dohtml readme.html

	fperms +x "${MYGAMEDIR}"/crayon
	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
