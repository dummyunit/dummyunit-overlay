# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="2"
inherit eutils multilib

DESCRIPTION="Samsung binary unified driver"
HOMEPAGE="http://www.samsung.com"
SRC_URI="http://org.downloadcenter.samsung.com/downloadfile/ContentsFile.aspx?VPath=DR/200911/20091118140019125/UnifiedLinuxDriver_1.00.tar.gz -> ${P}.tar.gz"

LICENSE="samsung"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
# Parallel support looks ugly, not supported in this ebuild
IUSE="scanner qt4"
RESTRICT="strip"

DEPEND=""
RDEPEND="net-print/cups
	!net-print/splix
	scanner? ( media-gfx/sane-backends )
	qt4? ( dev-qt/qtcore:4 )"

S=${WORKDIR}/cdroot/Linux

src_prepare() {
	# Fix permissions
	find . -type d -exec chmod 755 '{}' \;
	find . -type f -exec chmod 644 '{}' \;
	find . -type f -name \*.sh -exec chmod 755 '{}' \;
	chmod 755 ./i386/at_root/usr/sbin/*
	chmod 755 ./i386/qt4apps/at_opt/bin/*
	chmod 755 ./i386/qt4apps/at_opt/lib/*
	chmod 755 ./x86_64/at_root/usr/sbin/*
	chmod 755 ./x86_64/qt4apps/at_opt/bin/*
	chmod 755 ./x86_64/qt4apps/at_opt/lib/*
}

src_install() {
	SOPT="/opt/Samsung/mfp"
	if [ "${ABI}" == "amd64" ]; then
		SARCH="x86_64"
		SLIBDIR="lib64"
	else
		SARCH="i386"
		SLIBDIR="lib"
	fi

	# Printer files
	exeinto /usr/libexec/cups/backend
	doexe ${SARCH}/at_root/usr/${SLIBDIR}/cups/backend/mfp
	exeinto /usr/libexec/cups/filter
	doexe ${SARCH}/at_root/usr/${SLIBDIR}/cups/filter/{pscms,rasterto*}
	insinto /usr/share/cups/model/samsung
	doins -r noarch/at_opt/share/ppd/*
	gzip "${D}"/usr/share/cups/model/samsung/*.ppd
	dolib.so ${SARCH}/at_root/usr/${SLIBDIR}/libmfp.so.1.0.1

	if use scanner; then
		insinto /etc/sane.d
		doins noarch/at_root/etc/sane.d/smfp.conf

		exeinto /usr/$(get_libdir)/sane/
		doexe ${SARCH}/at_root/usr/${SLIBDIR}/sane/*
	fi

	if use qt4; then
		insinto ${SOPT}/share
		doins OEM.ini
		cp -r noarch/at_opt/share/V* noarch/at_opt/share/help \
			noarch/at_opt/share/images noarch/at_opt/share/ui \
			noarch/at_opt/share/utils "${D}"/${SOPT}/share

		exeinto ${SOPT}/lib
		doexe ${SARCH}/qt4apps/at_opt/lib/*
		exeinto ${SOPT}/libexec
		doexe ${SARCH}/qt4apps/at_opt/bin/*
		for i in ${SARCH}/qt4apps/at_opt/bin/*; do
			make_wrapper $(basename ${i}) ${SOPT}/libexec/$(basename ${i}) ${SOPT}/libexec ${SOPT}/lib ${SOPT}/bin
		done
	fi
}

pkg_postinst() {
	if use scanner; then
		elog "You need to add smfp to /etc/sane.d/dll.conf:"
		elog " # echo smfp >> /etc/sane.d/dll.conf"
	fi
}
