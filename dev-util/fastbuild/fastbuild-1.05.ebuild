# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit flag-o-matic toolchain-funcs bash-completion-r1

if [[ ${PV} = *9999 ]]; then
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

DEPEND="
	app-arch/lz4:=
	dev-libs/xxhash
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}"/Code
PATCHES=(
	"${FILESDIR}/${PN}-1.03-fix-IntellisenseAndCodeSense-test.patch"
	"${FILESDIR}/${PN}-1.03-remove-system-specific-paths.patch"
)

src_prepare() {
	# Apply patches on top of the repo/tarball root.
	# This allows users (and us) to use unmodified upstream commits as patches.
	pushd "${WORKDIR}/${P}" > /dev/null || die
	default
	popd > /dev/null || die

	cp "${FILESDIR}"/Makefile-0.82 Makefile || die
	sed -i -e '/^complete.*FBuild/d' Tools/FBuild/Integration/fbuild.bash-completion || die
}

src_configure() {
	use amd64 && append-cppflags -D__X64__
}

src_compile() {
	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)" all
}

src_test() {
	# Disable tests that fail under sandbox
	sed -i -e '/REGISTER_TEST.*ConsistentCacheKeysWithDist/d' Tools/FBuild/FBuildTest/Tests/TestCache.cpp || die
	sed -i -e '/REGISTER_TESTGROUP.*TestDistributed/d' Tools/FBuild/FBuildTest/TestMain.cpp || die
	# Disable tests that require clang to run
	sed -i -e '/All-x64ClangLinux/d' Tools/FBuild/FBuildTest/Tests/TestBuildFBuild.cpp || die
	sed -i -e '/REGISTER_TEST.*CacheUsingRelativePaths/d' Tools/FBuild/FBuildTest/Tests/Test{Object,Unity}.cpp || die
	sed -i -e '/REGISTER_TEST.*ClangDependencyArgs/d' Tools/FBuild/FBuildTest/Tests/TestObject.cpp || die
	sed -i -e '/REGISTER_TEST.*ClangExplicitLanguageType/d' Tools/FBuild/FBuildTest/Tests/TestObject.cpp || die
	sed -i -e '/REGISTER_TEST.*ClangStaticAnalysis/d' Tools/FBuild/FBuildTest/Tests/TestUnity.cpp || die
	sed -i -e '/REGISTER_TEST.*SourceMapping/d' Tools/FBuild/FBuildTest/Tests/TestObject.cpp || die

	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)" tests
	./coretest || die "CoreTest failed"
	# XCode project generation requires "USER" environment variable to work
	USER= ./fbuildtest || die "FBuildTest failed"
}

src_install() {
	dobin fbuild fbuildworker
	docinto html
	dodoc -r Tools/FBuild/Documentation/.
	newbashcomp Tools/FBuild/Integration/fbuild.bash-completion fbuild
}
