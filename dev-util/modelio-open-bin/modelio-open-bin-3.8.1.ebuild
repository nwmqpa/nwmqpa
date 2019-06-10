# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

inherit eutils

MYPNMAIN="${PN%%-bin}"
MYVERMAJ="${PV%%_p*}"
MYVERBAS="${MYVERMAJ%.*}"

DESCRIPTION="An open source modeling environment"
HOMEPAGE="http://www.modelio.org/"
SRC_URI_PREFIX="mirror://sourceforge/modeliouml/${MYVERMAJ}/${MYPNMAIN}-source${MYVERBAS}_${MYVERMAJ}"
SRC_URI="\
	x86?	( ${SRC_URI_PREFIX}_i386.deb )
	amd64?	( ${SRC_URI_PREFIX}_amd64.deb )"
LICENSE="GPL-3 APL-1.0"
SLOT="0"
RESTRICT="mirror"
KEYWORDS="x86 amd64"

# https://www.modelio.org/documentation/installation/12-installation.html
RDEPEND=">=virtual/jre-1.8"

# org.eclipse.swt.SWTError: No more handles [Unknown Mozilla path (MOZILLA_FIVE_HOME not set)]
# FIXED: 1.9.2.x XULRunner releases provide require API (not available in later versions of XULRunner)
RDEPEND="${RDEPEND}
    net-libs/xulrunner-bin:1.9.2"

S="${WORKDIR}/usr/lib/modelio-open-source${MYVERBAS}"
INSTALLDIR="/opt/${PN}"

src_unpack() {
	ar xf ${DISTDIR}/${A}
	rm -f ${WORKDIR}/control.tar.gz ${WORKDIR}/debian-binary
	tar xvf data.tar.xz
}

src_prepare() {
	# remove bundled Java
	rm -rf "${S}/jre" "${S}/lib"
	ln -s /etc/java-config-2/current-system-vm/jre "${S}/jre"
	# remove executable bit
	chmod a-x "${S}/icon.xpm"
}

src_install() {
	dodir "${INSTALLDIR}"
	mv "${S}"/* "${D}/${INSTALLDIR}" || die "Unable to move file for instalation!"
	## we will provide our own wrapper
	dodir /usr/bin
	cat <<END >"${D}/usr/bin/${MYPNMAIN}"
#!/bin/sh
exec ${INSTALLDIR}/modelio -data ~/.modelio \$@
END
	fperms 755 "/usr/bin/${MYPNMAIN}"
	make_desktop_entry "${MYPNMAIN}" "Modelio Open ${MYVERMAJ}" "${INSTALLDIR}/icon.xpm" "Development;IDE"
}

