# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit cmake-utils git

DESCRIPTION="Oxygen-Gtk is a port of the default KDE widget theme (Oxygen), to gtk"
HOMEPAGE="https://projects.kde.org/projects/playground/artwork/oxygen-gtk"
EGIT_REPO_URI="git://git.kde.org/oxygen-gtk"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	x11-libs/cairo
	x11-libs/gtk+:2
	x11-libs/libX11"
RDEPEND="${DEPEND}"
