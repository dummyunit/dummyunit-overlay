# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit cmake-multilib

if [ "${PV}" = "9999" ]; then
	EGIT_REPO_URI="https://github.com/google/benchmark"
	inherit git-r3
else
	SRC_URI="https://github.com/google/benchmark/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A microbenchmark support library"
HOMEPAGE="https://github.com/google/benchmark"
LICENSE="Apache-2.0"
SLOT="0"
IUSE="static-libs test"

DEPEND=""
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-1.0.0-install-dirs.patch" )

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DBENCHMARK_ENABLE_TESTING=$(usex test)
	)
	cmake-utils_src_configure

	if use static-libs; then
		mycmakeargs=(
			-DBUILD_SHARED_LIBS=OFF
			-DBENCHMARK_ENABLE_TESTING=OFF
		)
		BUILD_DIR=${BUILD_DIR}_static cmake-utils_src_configure
	fi
}

multilib_src_compile() {
	cmake-utils_src_compile

	if use static-libs; then
		BUILD_DIR=${BUILD_DIR}_static cmake-utils_src_compile
	fi
}

multilib_src_install() {
	cmake-utils_src_install

	if use static-libs; then
		BUILD_DIR=${BUILD_DIR}_static cmake-utils_src_install
	fi
}
