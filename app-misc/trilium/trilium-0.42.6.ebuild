# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit eutils

DESCRIPTION="Personal knowledge base"
HOMEPAGE="https://github.com/zadam/trilium"
SRC_URI="
	amd64? ( ${HOMEPAGE}/releases/download/v${PV}/trilium-linux-x64-${PV}.tar.xz -> ${P}-amd64.tar.xz )
	"
RESTRICT="mirror"

LICENSE="AGPL-3.0"
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
	ARCH="$(uname -m)"
	if [[ $ARCH == "x86_64" ]];then
		cd trilium-linux-x64
	else
		cd trilium-linux-ia32
	fi


	insinto "/opt/${PN}"
	doins -r *
	dosym "/opt/${PN}/trilium" "/usr/bin/trilium"
	fperms +x "/opt/${PN}/trilium"
	fperms +x "/opt/${PN}/chrome-sandbox"
	fperms +x "/opt/${PN}/libffmpeg.so"
	fperms +x "/opt/${PN}/libEGL.so"
	fperms +x "/opt/${PN}/libGLESv2.so"
	insinto "/usr/share/licenses/${PN}"
	newins "LICENSE" "LICENSE"
}

