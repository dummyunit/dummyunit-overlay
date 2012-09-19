# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
inherit flag-o-matic multilib toolchain-funcs versionator

BOOST_PV=$(get_version_component_range 1-3)
BOOST_P=boost_$(replace_all_version_separators _ ${BOOST_PV})
MY_PV=$(get_version_component_range 4-)
MY_P=${PN}-${MY_PV}

DESCRIPTION="Boost.Log"
HOMEPAGE="http://sourceforge.net/projects/boost-log/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip
	mirror://sourceforge/boost/${BOOST_P}.tar.bz2"

LICENSE="Boost-1.0"
SLOT="$(get_version_component_range 1-2 ${BOOST_PV})"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="debug doc +eselect static-libs"

RDEPEND="dev-libs/boost:${SLOT}"
DEPEND="${RDEPEND}
	dev-util/boost-build:${SLOT}"

S=${WORKDIR}/${BOOST_P}

BOOST_MAJOR_PV=$(replace_all_version_separators _ ${SLOT})
BJAM="bjam-${BOOST_MAJOR_PV}"

# Usage:
# _add_line <line-to-add> <profile>
# ... to add to specific profile
# or
# _add_line <line-to-add>
# ... to add to all profiles for which the use flag set

_add_line() {
	if [[ -z "$2" ]]; then
		echo "${1}" >> "${D}usr/share/boost-eselect/profiles/${SLOT}/default-with-log"
		if use debug; then
			echo "${1}" >> "${D}usr/share/boost-eselect/profiles/${SLOT}/debug-with-log"
		fi
	else
		echo "${1}" >> "${D}usr/share/boost-eselect/profiles/${SLOT}/${2}"
	fi
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

using ${compiler} : ${compiler_version} : ${compiler_executable} : <cflags>"${CFLAGS}" <cxxflags>"${CXXFLAGS} -I/usr/include/boost-${BOOST_MAJOR_PV}" <linkflags>"${LDFLAGS}" ;
__EOF__
}

pkg_setup() {
	if use debug; then
		ewarn "The debug USE flag means that a second set of the boost libraries"
		ewarn "will be built containing debug symbols. You'll be able to select them"
		ewarn "using the boost-eselect module. But even though the optimization flags"
		ewarn "you might have set are not stripped, there will be a performance"
		ewarn "penalty and linking other packages against the debug version"
		ewarn "of boost is _not_ recommended."
	fi
}

src_unpack() {
	unpack ${A}
	rm -r "${BOOST_P}"/{boost,libs} || die
	cp -r "${MY_P}"/{boost,libs} "${BOOST_P}" || die
}

src_prepare() {
	epatch \
		"${FILESDIR}/remove-toolset-${BOOST_PV}.patch" \
		"${FILESDIR}/${MY_P}-dependencies-${SLOT}.patch"
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

	OPTIONS+=" pch=off --boost-build=/usr/share/boost-build-${BOOST_MAJOR_PV} --prefix=\"${D}usr\" --layout=versioned"

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

	einfo "Using the following command to build:"
	einfo "${BJAM} ${NUMJOBS} -q -d+2 gentoorelease --user-config=user-config.jam ${OPTIONS} threading=single,multi ${LINK_OPTS} runtime-link=shared --with-log"

	${BJAM} ${NUMJOBS} -q -d+2 \
		gentoorelease \
		--user-config=user-config.jam \
		${OPTIONS} \
		threading=single,multi ${LINK_OPTS} runtime-link=shared \
		--with-log \
		|| die "Building of Boost libraries failed"

	# ... and do the whole thing one more time to get the debug libs
	if use debug; then
		einfo "Using the following command to build:"
		einfo "${BJAM} ${NUMJOBS} -q -d+2 gentoodebug --user-config=user-config.jam ${OPTIONS} threading=single,multi ${LINK_OPTS} runtime-link=shared --buildid=debug --with-log"

		${BJAM} ${NUMJOBS} -q -d+2 \
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
	dodir /usr/share/boost-eselect/profiles/${SLOT}
	touch "${D}usr/share/boost-eselect/profiles/${SLOT}/default-with-log" || die
	if use debug; then
		touch "${D}usr/share/boost-eselect/profiles/${SLOT}/debug-with-log" || die
	fi

	create_user-config.jam

	einfo "Using the following command to install:"
	einfo "${BJAM} -q -d+2 gentoorelease --user-config=user-config.jam ${OPTIONS} threading=single,multi ${LINK_OPTS} runtime-link=shared --includedir=\"${D}usr/include\" --libdir=\"${D}usr/$(get_libdir)\" install"

	${BJAM} -q -d+2 \
		gentoorelease \
		--user-config=user-config.jam \
		${OPTIONS} \
		threading=single,multi ${LINK_OPTS} runtime-link=shared \
		--includedir="${D}usr/include" \
		--libdir="${D}usr/$(get_libdir)" \
		install || die "Installation of Boost libraries failed"

	if use debug; then
		einfo "Using the following command to install:"
		einfo "${BJAM} -q -d+2 gentoodebug --user-config=user-config.jam ${OPTIONS} threading=single,multi ${LINK_OPTS} runtime-link=shared --includedir=\"${D}usr/include\" --libdir=\"${D}usr/$(get_libdir)\" --buildid=debug install"

		${BJAM} -q -d+2 \
			gentoodebug \
			--user-config=user-config.jam \
			${OPTIONS} \
			threading=single,multi ${LINK_OPTS} runtime-link=shared \
			--includedir="${D}usr/include" \
			--libdir="${D}usr/$(get_libdir)" \
			--buildid=debug \
			install || die "Installation of Boost debug libraries failed"
	fi

	if use doc; then
		find libs/*/* -iname "test" -or -iname "src" | xargs rm -rf
		dohtml \
			-A pdf,txt,cpp,hpp \
			*.{htm,html,png,css} \
			-r doc
		dohtml \
			-A pdf,txt \
			-r tools
		insinto /usr/share/doc/${PF}/html
		doins -r libs
		doins -r more

		# To avoid broken links
		insinto /usr/share/doc/${PF}/html
		doins LICENSE_1_0.txt

		dosym /usr/include/boost-${BOOST_MAJOR_PV}/boost /usr/share/doc/${PF}/html/boost
	fi

	pushd "${D}usr/$(get_libdir)" > /dev/null || die

	# Remove (unversioned) symlinks
	# And check for what we remove to catch bugs
	# got a better idea how to do it? tell me!
	local f
	for f in $(ls -1 ${LIBRARY_TARGETS} | grep -v "${BOOST_MAJOR_PV}"); do
		if [[ ! -h "${f}" ]]; then
			eerror "Tried to remove '${f}' which is a regular file instead of a symlink"
			die "Slotting/naming of the libraries broken!"
		fi
		rm "${f}" || die
	done

	# Create a subdirectory with completely unversioned symlinks
	# and store the names in the profiles-file for eselect
	dodir /usr/$(get_libdir)/boost-${BOOST_MAJOR_PV}
	_add_line ". /usr/share/boost-eselect/profiles/${SLOT}/default" default-with-log
	_add_line "libs=\"" default-with-log
	_add_line "\$libs" default-with-log
	local f
	for f in $(ls -1 ${LIBRARY_TARGETS} | grep -v debug); do
		dosym ../${f} /usr/$(get_libdir)/boost-${BOOST_MAJOR_PV}/${f/-${BOOST_MAJOR_PV}}
		_add_line "/usr/$(get_libdir)/${f}" default-with-log
	done
	_add_line "\"" default-with-log

	if use debug; then
		dodir /usr/$(get_libdir)/boost-${BOOST_MAJOR_PV}-debug
		_add_line ". /usr/share/boost-eselect/profiles/${SLOT}/debug" debug-with-log
		_add_line "libs=\"" debug-with-log
		_add_line "\$libs" debug-with-log
		local f
		for f in $(ls -1 ${LIBRARY_TARGETS} | grep debug); do
			dosym ../${f} /usr/$(get_libdir)/boost-${BOOST_MAJOR_PV}-debug/${f/-${BOOST_MAJOR_PV}-debug}
			_add_line "/usr/$(get_libdir)/${f}" debug-with-log
		done
		_add_line "\"" debug-with-log
	fi

	popd > /dev/null || die

	pushd status > /dev/null || die
	if [[ -f regress.log ]]; then
		docinto status
		dohtml *.html ../boost.png
		dodoc regress.log
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

pkg_postinst() {
	if use eselect; then
		eselect boost update || ewarn "eselect boost update failed."
	fi

	if [[ ! -h "${ROOT}etc/eselect/boost/active" ]]; then
		elog "No active boost version found. Calling eselect to select one..."
		eselect boost update || ewarn "eselect boost update failed."
	fi
}
