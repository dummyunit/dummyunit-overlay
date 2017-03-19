# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=3

PYTHON_DEPEND=2
inherit python eutils bash-completion-r1

DESCRIPTION="Tool for checking common errors in RPM packages"
HOMEPAGE="http://rpmlint.zarb.org/"
SRC_URI="http://rpmlint.zarb.org/download/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="minimal"

# Upstream claims that it works with >=rpm-4.4.2.2
# but it fails for me with rpm-4.4.6-r7 and 4.4.7-r6
RDEPEND="
	>=app-arch/rpm-4.8.1-r2[python]
	app-arch/cpio
	dev-util/desktop-file-utils
	!minimal? (
		dev-python/pyenchant
		sys-apps/file[python]
	)
"
DEPEND="${RDEPEND}"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare()
{
	epatch "${FILESDIR}/rpmlint-1.3-svn1886-ghost-fix.patch"
	sed -i -e '/MenuCheck/d' Config.py
}

src_compile()
{
	:
}

src_install() {
	insinto "/usr/share/${PN}"
	doins *.py
	newins "${FILESDIR}/${PN}.config" config
	newins "${FILESDIR}/${PN}.config.el4" config.el4
	newins "${FILESDIR}/${PN}.config.el5" config.el5

	insinto "/etc/${PN}"
	newins config config.example
	newins "${FILESDIR}/${PN}-etc.config" config

	doman rpmlint.1
	dobin rpmlint rpmdiff
	dosym rpmlint /usr/bin/el4-rpmlint
	dosym rpmlint /usr/bin/el5-rpmlint
	newbashcomp rpmlint.bash-completion "${PN}"
	dodoc AUTHORS README ChangeLog
}

pkg_postinst() {
	python_mod_optimize "/usr/share/${PN}"
}

pkg_postrm() {
	python_mod_cleanup "/usr/share/${PN}"
}
