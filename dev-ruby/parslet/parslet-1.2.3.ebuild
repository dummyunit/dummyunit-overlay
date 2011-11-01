# Copyright 2011 Stanislav Cymbalov
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

USE_RUBY="ruby18 ree18"

RUBY_FAKEGEM_TASK_DOC="" # docs building broken
RUBY_FAKEGEM_EXTRADOC="README HISTORY.txt"

inherit ruby-fakegem

DESCRIPTION="A small Ruby library for constructing parsers in the PEG (Parsing Expression Grammar) fashion."
HOMEPAGE="http://kschiess.github.com/parslet/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

ruby_add_bdepend "
	test? ( dev-ruby/flexmock dev-ruby/rspec:2 )
"
#	doc? (  dev-ruby/sdoc dev-ruby/rspec:2 )
ruby_add_rdepend "
	dev-ruby/blankslate
"

all_ruby_install() {
	all_fakegem_install

	if use examples; then
		insinto "/usr/share/doc/${PF}/examples"
		doins -r example/*
	fi
}
