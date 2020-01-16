# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit eutils meson readme.gentoo-r1

DESCRIPTION="A lightweight Wayland notification daemon"
HOMEPAGE="https://wayland.emersion.fr/mako"
SRC_URI="https://github.com/emersion/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-libs/wayland
	x11-libs/pango
	x11-libs/cairo
"

DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/meson
"

S="${WORKDIR}"

src_configure() {
	meson_src_configure
}

src_install() {
	meson_src_install
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
