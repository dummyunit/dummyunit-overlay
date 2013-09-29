# Copyright 2011 Stanislav Cymbalov
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

USE_RUBY="ruby18"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.rdoc"

inherit ruby-fakegem

DESCRIPTION="Whitelist-based HTML sanitizer."
HOMEPAGE="https://github.com/rgrove/sanitize/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_bdepend "
	test? ( >=dev-ruby/minitest-2.0.0 )
"
ruby_add_rdepend "
	>=dev-ruby/nokogiri-1.4.4
	 <dev-ruby/nokogiri-1.6
"
