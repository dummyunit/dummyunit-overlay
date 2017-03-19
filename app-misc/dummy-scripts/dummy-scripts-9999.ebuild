# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

EGIT_REPO_URI="git://dummyunit.dtdns.net/scripts"
inherit cmake-utils git-r3

DESCRIPTION="Collection of useful scripts"
HOMEPAGE="http://dummyunit.dtdns.net/git/?p=scripts.git;a=summary"

LICENSE="GPL-3"
SLOT="0"
IUSE="pull-dependencies"

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}
	pull-dependencies? (
		net-firewall/ipset
		sys-fs/cryptsetup
	)"

src_configure() {
	local mycmakeargs
	mycmakeargs=(
		-DBUILD_MAN=ON
	)

	cmake-utils_src_configure
}
