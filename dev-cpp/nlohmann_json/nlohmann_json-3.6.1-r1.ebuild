# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="JSON for Modern C++"
HOMEPAGE="https://github.com/nlohmann/json https://nlohmann.github.io/json/"
SRC_URI="https://github.com/nlohmann/json/releases/download/v${PV}/include.zip -> ${P}.include.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86"
IUSE=""

S=${WORKDIR}/include

src_install() {
	doheader -r nlohmann
}