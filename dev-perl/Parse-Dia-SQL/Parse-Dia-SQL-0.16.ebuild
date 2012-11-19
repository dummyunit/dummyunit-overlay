# Copyright 2008-2010 Stanislav Cymbalov
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MODULE_AUTHOR="AFF"
inherit perl-module

DESCRIPTION="Convert Dia class diagrams into SQL"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="perl-core/Data-Dumper
	virtual/perl-Digest-MD5
	dev-perl/autodie
	virtual/perl-File-Spec
	virtual/perl-File-Temp
	virtual/perl-Getopt-Long
	virtual/perl-IO-Compress
	dev-perl/Log-Dispatch-FileRotate
	dev-perl/Log-Log4perl
	dev-perl/Test-Exception
	virtual/perl-Test-Simple
	dev-perl/Text-Table
	dev-perl/XML-DOM
	"
DEPEND="${RDEPEND}"

SRC_TEST="do"
