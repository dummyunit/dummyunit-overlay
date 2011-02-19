# Copyright 2011 Stanislav Cymbalov
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

CMAKE_MIN_VERSION="2.8"
inherit eutils games cmake-utils wxwidgets

DESCRIPTION="MegaGlest is an open source 3D-real-time strategy game"
HOMEPAGE="http://www.megaglest.org/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-source-${PV}.tar.bz2
	mirror://sourceforge/${PN}/${PN}-fixed_data-${PV}.7z"

LICENSE="GPL-3 CCPL-Attribution-ShareAlike-3.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="editor +icons xml"

RDEPEND="media-libs/libsdl[video]
	virtual/opengl
	virtual/glu
	media-libs/libpng
	media-libs/jpeg
	media-libs/libvorbis
	media-libs/openal
	>=net-misc/curl-7.21.0
	>=dev-lang/lua-5.1
	editor? ( x11-libs/wxGTK:2.8[X] )
	dev-libs/xerces-c
	xml? ( dev-libs/libxml2 )"
DEPEND="${RDEPEND}
	app-arch/p7zip
	icons? ( media-gfx/icoutils )"

S="${WORKDIR}/${PN}-source-${PV}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
	sed -i -e "s:@GENTOO_DATADIR@:${GAMES_DATADIR}/${PN}:" \
		source/glest_game/main/main.cpp || die "sed failed"
}

src_configure() {
	if use editor; then
		WX_GTK_VER="2.8"
		need-wxwidgets unicode
	fi
	cmake -DWANT_SVN_STAMP=OFF $(cmake-utils_use_build editor EDITOR) || die "cmake failed"
}

src_compile() {
	cmake-utils_src_compile
	if use icons; then
		cd "${WORKDIR}"
		icotool -x -o- --height=48 --width=48 megaglest.ico > megaglest.png
		icotool -x -o- --height=48 --width=48 editor.ico > megaglest_editor.png
	fi
}

src_install() {
	insinto "${GAMES_DATADIR}/${PN}"

	doins glest.ini glestkeys.ini || die "doins failed"
	newgamesbin mk/linux/glest.bin megaglest || die "newgamesbin failed"
	if use editor; then
		newgamesbin mk/linux/glest_editor megaglest_editor || die "newgamesbin failed"
		newgamesbin mk/linux/glest_g3dviewer megaglest_g3dviewer || die "newgamesbin failed"
	fi

	cd "${WORKDIR}"
	doins -r data maps scenarios techs tilesets tutorials || die "doins failed"
	dodoc docs/README docs/CHANGELOG docs/AUTHORS || die "dodoc failed"
	dohtml -r docs/glest_factions || die "dohtml failed"

	use icons && doicon megaglest.png || die "doicon failed"
	make_desktop_entry megaglest "MegaGlest" \
		$(use icons && echo megaglest) || die "make_desktop_entry failed"
	if use editor; then
		use icons && doicon megaglest_editor.png || die "newicon failed"
		make_desktop_entry megaglest_editor "MegaGlest Editor" \
			$(use icons && echo megaglest_editor) || die "make_desktop_entry failed"
	fi
	prepgamesdirs
}
