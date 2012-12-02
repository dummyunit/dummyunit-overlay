# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
inherit flag-o-matic multilib toolchain-funcs versionator

if [[ ${PV} == "9999" ]]; then
	ESVN_REPO_URI="https://boost-log.svn.sourceforge.net/svnroot/boost-log/trunk/boost-log"
	inherit subversion
	S="${WORKDIR}/${PN}"
elif [[ ${PV} == *_p* ]]; then
	ESVN_REPO_URI="https://boost-log.svn.sourceforge.net/svnroot/boost-log/trunk/boost-log@${PV##*_p}"
	inherit subversion
	S="${WORKDIR}/${PN}"
else
	SRC_URI="mirror://sourceforge/${PN}/${P}.zip"
	S="${WORKDIR}/${P}"
fi

DESCRIPTION="Boost.Log"
HOMEPAGE="http://sourceforge.net/projects/boost-log/"

LICENSE="Boost-1.0"
SLOT=0
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="debug static-libs"

RDEPEND="dev-libs/boost[debug?,static-libs?]"
DEPEND="${RDEPEND}
	dev-util/boost-build
	dev-util/boost-jamfiles"

get_boost_major_v() {
	local boost_pkg="$(best_version 'dev-libs/boost')"
	replace_all_version_separators _ $(get_version_component_range 1-2 "${boost_pkg#dev-libs/boost-}")
}

create_user-config.jam() {
	local compiler compiler_version compiler_executable

	if [[ ${CHOST} == *-darwin* ]]; then
		compiler="darwin"
		compiler_version="$(gcc-fullversion)"
		compiler_executable="$(tc-getCXX)"
	else
		compiler="gcc"
		compiler_version="$(gcc-version)"
		compiler_executable="$(tc-getCXX)"
	fi

	# The debug-symbols=none and optimization=none are not official upstream flags but a Gentoo
	# specific patch to make sure that all our CFLAGS/CXXFLAGS/LDFLAGS are being respected.
	# Using optimization=off would for example add "-O0" and override "-O2" set by the user.
	# Please take a look at the boost-build ebuild for more information.
	cat > user-config.jam << __EOF__
variant gentoorelease : release : <optimization>none <debug-symbols>none ;
variant gentoodebug : debug : <optimization>none ;

using ${compiler} : ${compiler_version} : ${compiler_executable} : <cflags>"${CFLAGS}" <cxxflags>"${CXXFLAGS}" <linkflags>"${LDFLAGS}" ;
__EOF__
}

src_unpack() {
	if [[ ${PV} == "9999" ]] || [[ ${PV} == *_p* ]]; then
		subversion_src_unpack
	else
		unpack ${A}
	fi
	cp /usr/share/boost-jamfiles/{Jamroot,boostcpp.jam} "${S}" || die
}

src_prepare() {
	epatch "${FILESDIR}/${P}-dependencies.patch"
}

ejam() {
	echo b2-$(get_boost_major_v) "$@"
	b2-$(get_boost_major_v) "$@"
}

src_configure() {
	OPTIONS=""

	if [[ ${CHOST} == *-darwin* ]]; then
		# We need to add the prefix, and in two cases this exceeds, so prepare
		# for the largest possible space allocation.
		append-ldflags -Wl,-headerpad_max_install_names
	fi

	# bug 298489
	if use ppc || use ppc64; then
		[[ $(gcc-version) > 4.3 ]] && append-flags -mno-altivec
	fi

	# https://svn.boost.org/trac/boost/attachment/ticket/2597/add-disable-long-double.patch
	if use sparc || { use mips && [[ ${ABI} = "o32" ]]; } || use hppa || use arm || use x86-fbsd || use sh; then
		OPTIONS+=" --disable-long-double"
	fi

	OPTIONS+=" pch=off --boost-build=/usr/share/boost-build-$(get_boost_major_v) --prefix=\"${D}usr\" --layout=versioned"

	if use static-libs; then
		LINK_OPTS="link=shared,static"
		LIBRARY_TARGETS="*.a *$(get_libname)"
	else
		LINK_OPTS="link=shared"
		LIBRARY_TARGETS="*$(get_libname)"
	fi
}

src_compile() {
	local jobs
	jobs=$( echo " ${MAKEOPTS} " | \
		sed -e 's/ --jobs[= ]/ -j /g' \
			-e 's/ -j \([1-9][0-9]*\)/ -j\1/g' \
			-e 's/ -j\>/ -j1/g' | \
			( while read -d ' ' j; do if [[ "${j#-j}" = "$j" ]]; then continue; fi; jobs="${j#-j}"; done; echo ${jobs} ) )
	if [[ "${jobs}" != "" ]]; then NUMJOBS="-j"${jobs}; fi

	export BOOST_ROOT="${S}"

	create_user-config.jam

	ejam ${NUMJOBS} -q -d+2 \
		gentoorelease \
		--user-config=user-config.jam \
		${OPTIONS} \
		threading=single,multi ${LINK_OPTS} runtime-link=shared \
		--with-log \
		|| die "Building of Boost libraries failed"

	# ... and do the whole thing one more time to get the debug libs
	if use debug; then
		ejam ${NUMJOBS} -q -d+2 \
			gentoodebug \
			--user-config=user-config.jam \
			${OPTIONS} \
			threading=single,multi ${LINK_OPTS} runtime-link=shared \
			--buildid=debug \
			--with-log \
			|| die "Building of Boost debug libraries failed"
	fi
}

src_install () {
	create_user-config.jam

	ejam -q -d+2 \
		gentoorelease \
		--user-config=user-config.jam \
		${OPTIONS} \
		threading=single,multi ${LINK_OPTS} runtime-link=shared \
		--includedir="${D}usr/include" \
		--libdir="${D}usr/$(get_libdir)" \
		install || die "Installation of Boost libraries failed"

	if use debug; then
		ejam -q -d+2 \
			gentoodebug \
			--user-config=user-config.jam \
			${OPTIONS} \
			threading=single,multi ${LINK_OPTS} runtime-link=shared \
			--includedir="${D}usr/include" \
			--libdir="${D}usr/$(get_libdir)" \
			--buildid=debug \
			install || die "Installation of Boost debug libraries failed"
	fi

	pushd "${D}usr/$(get_libdir)" > /dev/null || die

	local f
	for f in $(ls -1 ${LIBRARY_TARGETS} | grep -v debug); do
		dosym ${f} /usr/$(get_libdir)/${f/-$(get_boost_major_v)}
	done

	if use debug; then
		dodir /usr/$(get_libdir)/boost-debug
		local f
		for f in $(ls -1 ${LIBRARY_TARGETS} | grep debug); do
			dosym ../${f} /usr/$(get_libdir)/boost-debug/${f/-$(get_boost_major_v)-debug}
		done
	fi

	popd > /dev/null || die

	# boost's build system truely sucks for not having a destdir.  Because for
	# this reason we are forced to build with a prefix that includes the
	# DESTROOT, dynamic libraries on Darwin end messed up, referencing the
	# DESTROOT instread of the actual EPREFIX.  There is no way out of here
	# but to do it the dirty way of manually setting the right install_names.
	if [[ ${CHOST} == *-darwin* ]]; then
		einfo "Working around completely broken build-system(tm)"
		local d
		for d in "${ED}"usr/lib/*.dylib; do
			if [[ -f ${d} ]]; then
				# fix the "soname"
				ebegin "  correcting install_name of ${d#${ED}}"
				install_name_tool -id "/${d#${D}}" "${d}"
				eend $?
				# fix references to other libs
				refs=$(otool -XL "${d}" | \
					sed -e '1d' -e 's/^\t//' | \
					grep "^libboost_" | \
					cut -f1 -d' ')
				local r
				for r in ${refs}; do
					ebegin "    correcting reference to ${r}"
					install_name_tool -change \
						"${r}" \
						"${EPREFIX}/usr/lib/${r}" \
						"${d}"
					eend $?
				done
			fi
		done
	fi
}
