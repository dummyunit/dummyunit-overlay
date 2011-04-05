# Copyright 2008-2011 Stanislav Cymbalov
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4

DESCRIPTION="A simple interface for working with TeX documents"
HOMEPAGE="http://tug.org/texworks/"
SRC_URI="http://${PN}.googlecode.com/files/${P}-r759.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+latex"

LANGS="af ar ca cs de es fa fo fr it ja ko nl pl pt_BR ru sl tr zh_CN"
for LNG in ${LANGS}; do
	IUSE="${IUSE} linguas_${LNG}"
done

RDEPEND=">=x11-libs/qt-core-4.5.2
	>=x11-libs/qt-gui-4.5.2
	>=app-text/poppler-0.10.5[qt4]
	>=app-text/hunspell-1.2.8"
DEPEND="${RDEPEND}"
PDEPEND="latex? ( dev-texlive/texlive-latex ) !latex? ( app-text/texlive-core )"

src_prepare() {
	# disable guessing path to tex binary, we already know it
	sed -i '\:system(./getDefaultBinPaths.sh): d' TeXworks.pro || die
	echo '#define DEFAULT_BIN_PATHS "/usr/bin"' > src/DefaultBinaryPaths.h || die

	sed -i '/TW_\(HELP\|PLUGIN\|DIC\)PATH/ s:/usr/local:/usr:' TeXworks.pro || die
	sed -i '/target.path/ s:/usr/local:/usr:' \
		plugins-src/TWLuaPlugin/TWLuaPlugin.pro \
		plugins-src/TWPythonPlugin/TWPythonPlugin.pro || die
}

src_compile() {
	eqmake4 TeXworks.pro
	emake || die "emake failed"
}

src_install() {
	dobin ${PN} || die

	# install translations
	insinto /usr/share/${PN}/
	for LNG in ${LANGS}; do
		if use linguas_${LNG}; then
			doins trans/TeXworks_${LNG}.qm || die
		fi
	done

	insinto /usr/share/pixmaps/
	doins res/images/TeXworks.png || die
	insinto /usr/share/applications/
	doins texworks.desktop || die

	doman man/texworks.1 || die
}
