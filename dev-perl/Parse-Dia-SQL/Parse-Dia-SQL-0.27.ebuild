# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR="AFF"
inherit perl-module

DESCRIPTION="Convert Dia class diagrams into SQL"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-perl/Text-Table
	dev-perl/HTML-Lint
	dev-perl/XML-DOM
	virtual/perl-CPAN-Meta
	virtual/perl-Getopt-Long
	dev-perl/Test-Exception
	virtual/perl-autodie
	virtual/perl-Data-Dumper
	dev-perl/Log-Log4perl
"
DEPEND="${RDEPEND}"

SRC_TEST=do
