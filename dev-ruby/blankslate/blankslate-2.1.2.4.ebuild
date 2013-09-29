# Copyright 2011 Stanislav Cymbalov
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

USE_RUBY="ruby18"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README"

inherit ruby-fakegem

DESCRIPTION="BlankSlate provides an abstract base class with no predefined methods."
HOMEPAGE="http://github.com/masover/blankslate"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_bdepend "
	dev-ruby/bundler
	test? ( dev-ruby/rspec:2 )
"
