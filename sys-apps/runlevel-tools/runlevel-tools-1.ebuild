# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

DESCRIPTION="Init script that changes config files according to runlevel changes"
HOMEPAGE="http://dummyunit.dtdns.net/git/?p=dummyunit-overlay.git;a=tree;f=sys-apps/runlevel-tools"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND="
	dev-vcs/git
	>=sys-apps/baselayout-2
	"

src_install() {
	newinitd "${FILESDIR}/init" "runlevel-default"
}

pkg_postinst() {
	elog "Now you must:"
	elog "  1. Add symlinks /etc/init.d/runlevel-\${runlevel} -> runlevel-default"
	elog "     for all your runlevels and add this new init scripts to their runlevels."
	elog "  2. Create a git repo in /etc and add branches '`hostname`-\${runlevel}'."
}
