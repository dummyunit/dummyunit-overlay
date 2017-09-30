# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs bash-completion-r1

if [ "${PV}" = "9999" ]; then
	EGIT_REPO_URI="https://github.com/fastbuild/fastbuild.git"
	EGIT_BRANCH="dev"
	inherit git-r3
else
	SRC_URI="https://github.com/fastbuild/fastbuild/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="High performance build system supporting caching and network distribution"
HOMEPAGE="http://fastbuild.org/"
SLOT="0"
LICENSE="ZLIB BSD-2"

S="${WORKDIR}/${P}"/Code

src_prepare() {
	cp "${FILESDIR}"/Makefile-0.82 "${S}"/Makefile || die
	rm Tools/FBuild/Documentation/favicon.ico || die
	if [ -f Tools/FBuild/Integration/fbuild.bash-completion ]; then
		sed -i -e '/^complete.*FBuild/d' Tools/FBuild/Integration/fbuild.bash-completion || die
	fi
	default
}

src_compile() {
	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)" all
}

src_test() {
	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)" tests
	./coretest || die "CoreTest failed"
	./fbuildtest || die "FBuildTest failed"
}

src_install() {
	dobin fbuild fbuildworker
	dodoc -r Tools/FBuild/Documentation/*
	if [ -f Tools/FBuild/Integration/fbuild.bash-completion ]; then
		newbashcomp Tools/FBuild/Integration/fbuild.bash-completion fbuild
	fi
}
