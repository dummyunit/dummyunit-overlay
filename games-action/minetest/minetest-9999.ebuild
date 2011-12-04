# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/uzbl/uzbl-9999.ebuild,v 1.23 2011/10/24 06:43:25 tetromino Exp $

EAPI="2"

if [[ ${PV} == *9999* ]]; then
	GIT_ECLASS="git-2"
	EGIT_REPO_URI=${EGIT_REPO_URI:-"git://github.com/celeron55/minetest.git"}
	KEYWORDS=""
	SRC_URI=""
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="http://github.com/celeron55/${PN}/tarball/${PV} -> ${P}.tar.gz"
fi

inherit cmake-utils ${GIT_ECLASS}

DESCRIPTION="An InfiniMiner/Minecraft inspired game."
HOMEPAGE="http://c55.me/minetest/"

LICENSE="GPL-2 CCPL-Attribution-ShareAlike-3.0"
SLOT="0"
IUSE="+client +server"

RDEPEND="
	dev-games/irrlicht
	dev-libs/jthread
	dev-db/sqlite:3
"

DEPEND="${RDEPEND}"

src_unpack() {
	if [[ ${PV} == *9999* ]]; then
		git-2_src_unpack
	else
		unpack ${A}
		mv celeron55-minetest-* "${S}"
	fi
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.3.1-jthread-include.patch"
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_build client)
		$(cmake-utils_use_build server)
		-DRUN_IN_PLACE=OFF
	)
	cmake-utils_src_configure
}
