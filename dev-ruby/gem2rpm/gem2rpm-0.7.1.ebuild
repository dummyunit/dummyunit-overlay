# Copyright 2011 Stanislav Cymbalov
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

USE_RUBY="ruby18 ree18"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="AUTHORS README"
RUBY_FAKEGEM_EXTRAINSTALL="templates"

inherit ruby-fakegem

DESCRIPTION="Generate source rpms and rpm spec files from a Ruby Gem."
HOMEPAGE="https://github.com/lutter/gem2rpm/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
