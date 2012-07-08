# Copyright 2008-2010 Stanislav Cymbalov
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit cmake-utils games

MY_P=${PN}-source-${PV}
S="${WORKDIR}/${PV}/build"

DESCRIPTION="Rigs of Rods is a realistic multi-simulator"
HOMEPAGE="http://rigsofrods.com/ http://sourceforge.net/projects/rigsofrods/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="media-libs/freeimage
	media-libs/freetype:2
	media-libs/openal
	dev-libs/zziplib
	dev-games/cegui
	media-gfx/nvidia-cg-toolkit
	x11-libs/wxGTK:2.8"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	#strip bad -mssse3 compiler flag
	sed -i -e '/^[[:space:]]*SET_TARGET_PROPERTIES/ s/-mssse3//' \
		${S}/main/CMakeLists.txt
}

src_configure() {
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	prepgamesdirs
}
