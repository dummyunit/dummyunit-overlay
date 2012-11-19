# Copyright 2008-2010 Stanislav Cymbalov
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MODULE_AUTHOR="MARKPF"
inherit perl-module

DESCRIPTION="Log to files that archive/rotate themselves"

SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="dev-perl/Log-Log4perl
	dev-perl/log-dispatch
	dev-perl/DateManip
	dev-perl/Params-Validate"
DEPEND="${RDEPEND}"
