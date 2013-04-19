# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit cmake-utils vcs-snapshot

MY_PN="SmartDeblur"
EGIT_COMMIT="931b50a9c762338b2695a2bcb65867f6228bb544"

DESCRIPTION="SmartDeblur is a tool for restoring defocused and blurred images"
HOMEPAGE="https://github.com/Y-Vladimir/${MY_PN}/"
SRC_URI="https://github.com/Y-Vladimir/${MY_PN}/tarball/${EGIT_COMMIT} -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="dev-qt/qtcore:4
	dev-qt/qtgui:4
	sci-libs/fftw:3.0"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-1.27-fix-qt-deps.patch" )
CMAKE_USE_DIR="${S}/src"

src_configure() {
	local mycmakeargs
	mycmakeargs=(
		-DUSE_SYSTEM_FFTW=ON
	)

	cmake-utils_src_configure
}
