# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
PYTHON_USE_WITH="tk"
inherit distutils bzr eutils

EBZR_REPO_URI="lp:pithos"
DESCRIPTION="A Pandora Radio (pandora.com) player for the GNOME Desktop"
HOMEPAGE="http://kevinmehall.net/p/pithos/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-python/python-distutils-extra
	dev-python/pyxdg
	dev-python/pygobject
	dev-python/notify-python
	dev-python/pygtk
	dev-python/gst-python
	dev-python/dbus-python
	media-libs/gst-plugins-good
	media-libs/gst-plugins-bad
	media-plugins/gst-plugins-faad
	media-plugins/gst-plugins-soup
	|| ( dev-libs/keybinder gnome-base/gnome-settings-daemon )"

DEPEND="${RDEPEND}"
RESTRICT_PYTHON_ABIS="3.*"

src_compile() {
	# Make a gstreamer registry place holder so it does not fail to access the /root gstreamer registry
	mkdir -p "${T}/home"
	export HOME="${T}/home"
	export GST_REGISTRY=${T}/home/registry.cache.xml
}

src_install() {
	distutils_src_install
	dodoc CHANGELOG
}
