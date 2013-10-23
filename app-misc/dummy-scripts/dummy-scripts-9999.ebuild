# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils git-2

EGIT_PROJECT="${PN}"
EGIT_REPO_URI="git://dummyunit.homeftp.net/scripts"

DESCRIPTION="Collection of useful scripts"
HOMEPAGE="http://dummyunit.homeftp.net/git/?p=scripts.git;a=summary"

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
