# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR="PETDANCE"
inherit perl-module

DESCRIPTION="A pure-Perl HTML parser and checker for syntactic legitmacy"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="virtual/perl-ExtUtils-MakeMaker
	virtual/perl-Exporter
	virtual/perl-Test-Simple
	dev-perl/HTML-Tagset
	dev-perl/HTML-Parser
"
DEPEND="${RDEPEND}"

SRC_TEST=do
