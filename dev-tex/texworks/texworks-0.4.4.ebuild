# Copyright 2008-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7,3_2,3_3} )
inherit base multilib python-single-r1 cmake-utils

DESCRIPTION="A simple interface for working with TeX documents"
HOMEPAGE="http://tug.org/texworks/"
SRC_URI="http://${PN}.googlecode.com/files/${P}-r1004.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+latex lua python"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND=">=dev-qt/qtcore-4.5.2:4
	>=dev-qt/qtgui-4.5.2:4
	>=dev-qt/qtscript-4.5.2:4
	>=app-text/poppler-0.10.5[qt4]
	>=app-text/hunspell-1.2.8
	lua? ( dev-lang/lua )
	python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}"
PDEPEND="latex? ( dev-texlive/texlive-latex ) !latex? ( app-text/texlive-core )"

PATCHES=(
	"${FILESDIR}/${PN}-r1293.patch"
	"${FILESDIR}/${PN}-cmake-variable-cache-type-fix.patch"
	"${FILESDIR}/${P}-build-fix.patch"
	)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	base_src_prepare

	# disable guessing path to tex binary, we already know it
	echo '#define DEFAULT_BIN_PATHS "/usr/bin"' > src/DefaultBinaryPaths.h || die
}

src_configure() {
	local mycmakeargs=(
		-DTeXworks_HELP_DIR="share/${PN}/help"
		-DTeXworks_PLUGIN_DIR="$(get_libdir)/${PN}"
		-DTeXworks_DOCS_DIR="share/doc/${P}"
		-DTeXworks_DIC_DIR="share/myspell"
		$(cmake-utils_use_with lua)
		$(cmake-utils_use_with python)
	)

	cmake-utils_src_configure
}
