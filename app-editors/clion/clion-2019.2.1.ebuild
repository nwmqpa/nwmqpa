# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit eutils

DESCRIPTION="A cross-platform IDE for C and C++"
HOMEPAGE="https://www.jetbrains.com/clion"
SRC_URI="
	amd64? ( https://download-cf.jetbrains.com/cpp/CLion-${PV}.tar.gz -> ${P}-amd64.tar.gz )
	"
RESTRICT="mirror"

LICENSE="IDEA"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	app-crypt/libsecret
	>=media-libs/libpng-1.2.46
	>=x11-libs/gtk+-2.24.8-r1:2
	x11-libs/cairo
	gnome-base/gconf
"

RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_install(){
	cd clion-${PV}
	insinto "/opt/${PN}"
	doins -r *
	dosym "/opt/${PN}/bin/clion.sh" "/usr/bin/clion.sh"
	insinto "/usr/share/applications"
	doins ${FILESDIR}/jetbrains-${PN}.desktop
	insinto "/usr/share/pixmaps"
	doins ${FILESDIR}/${PN}.png
	fperms +x "/opt/${PN}/bin/clion.sh"
}

