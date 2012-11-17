# Copyright 2008-2011 Stanislav Cymbalov
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

LANGS="af ar ca cs de es fa fo fr it ja ko nl pl pt_BR ru sl tr zh_CN"
inherit qt4-r2

DESCRIPTION="A simple interface for working with TeX documents"
HOMEPAGE="http://tug.org/texworks/"
SRC_URI="http://${PN}.googlecode.com/files/${P}-r1004.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+latex lua python"

RDEPEND=">=x11-libs/qt-core-4.5.2
	>=x11-libs/qt-gui-4.5.2
	>=app-text/poppler-0.10.5[qt4]
	>=app-text/hunspell-1.2.8
	lua? ( dev-lang/lua )
	python? ( dev-lang/python )"
DEPEND="${RDEPEND}
	app-admin/eselect-python"
PDEPEND="latex? ( dev-texlive/texlive-latex ) !latex? ( app-text/texlive-core )"

src_prepare() {
	qt4-r2_src_prepare

	# disable guessing path to tex binary, we already know it
	sed -i -e "\:system(./getDefaultBinPaths.sh): d" TeXworks.pro || die
	echo '#define DEFAULT_BIN_PATHS "/usr/bin"' > src/DefaultBinaryPaths.h || die

	# fix plugin's build system
	sed -i -e "/PKGCONFIG/ s/lua5.1/lua/" plugins-src/TWLuaPlugin/TWLuaPlugin.pro || die
	local python_ver=$(eselect python show --python2)
	sed -i \
		-e "/LIBS/ s/python2.6/${python_ver}/" \
		-e "/INCLUDEPATH/ s/python2.6/${python_ver}/" \
		plugins-src/TWPythonPlugin/TWPythonPlugin.pro || die
}

_each_dir()
{
	"$@"
	if use lua; then
		pushd plugins-src/TWLuaPlugin > /dev/null
		"$@"
		popd > /dev/null
	fi
	if use python; then
		pushd plugins-src/TWPythonPlugin > /dev/null
		"$@"
		popd > /dev/null
	fi
}

src_configure() {
	_each_dir qt4-r2_src_configure
}

src_compile() {
	_each_dir qt4-r2_src_compile
}

src_install() {
	_each_dir qt4-r2_src_install

	# install translations
	insinto /usr/share/${PN}/
	for LNG in ${LANGS}; do
		if use linguas_${LNG}; then
			doins trans/TeXworks_${LNG}.qm
		fi
	done
}
