# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/chromium/chromium-9999.ebuild,v 1.90 2010/10/05 14:51:39 phajdan.jr Exp $

EAPI="2"

inherit eutils flag-o-matic multilib pax-utils subversion toolchain-funcs

DESCRIPTION="Open-source version of Google Chrome web browser"
HOMEPAGE="http://chromium.org/"
# subversion eclass fetches gclient, which will then fetch chromium itself
ESVN_REPO_URI="http://src.chromium.org/svn/trunk/tools/depot_tools"
EGCLIENT_REPO_URI="http://src.chromium.org/svn/trunk/src/"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="cups gnome gnome-keyring system-sqlite"

RDEPEND="app-arch/bzip2
	system-sqlite? (
		>=dev-db/sqlite-3.6.23.1[fts3,icu,secure-delete,threadsafe]
	)
	>=dev-libs/icu-4.4.1
	>=dev-libs/libevent-1.4.13
	dev-libs/libxml2
	dev-libs/libxslt
	>=dev-libs/nss-3.12.8
	>=gnome-base/gconf-2.24.0
	gnome-keyring? ( >=gnome-base/gnome-keyring-2.28.2 )
	>=media-libs/alsa-lib-1.0.19
	media-libs/jpeg:0
	media-libs/libpng
	>=media-video/ffmpeg-9999[threads]
	cups? ( >=net-print/cups-1.4.4 )
	sys-libs/zlib
	>=x11-libs/gtk+-2.14.7
	x11-libs/libXScrnSaver"
DEPEND="${RDEPEND}
	dev-lang/perl
	>=dev-util/gperf-3.0.3
	>=dev-util/pkgconfig-0.23
	sys-devel/flex"
RDEPEND+="
	|| (
		x11-themes/gnome-icon-theme
		x11-themes/oxygen-molecule
		x11-themes/tango-icon-theme
		x11-themes/xfce4-icon-theme
	)
	x11-apps/xmessage
	x11-misc/xdg-utils
	virtual/ttf-fonts"

S=${ESVN_STORE_DIR}/${PN}/src

src_unpack() {
	ESVN_RESTRICT="export" subversion_fetch

	# Most subversion checks and configurations were already run
	EGCLIENT="${ESVN_STORE_DIR}"/${PN}/depot_tools/gclient
	cd "${ESVN_STORE_DIR}"/${PN} || die

	if [[ ! -f .gclient ]]; then
		einfo "gclient config -->"
		${EGCLIENT} config ${EGCLIENT_REPO_URI} || die "gclient: error creating config"
	fi

	einfo "Reverting patches"
	svn revert src/net/socket/ssl_client_socket_nss.cc

	einfo "gclient sync start -->"
	einfo "     repository: ${EGCLIENT_REPO_URI}"
	${EGCLIENT} sync --nohooks || die
	einfo "   working copy: ${ESVN_STORE_DIR}/${PN}"

	# Display correct svn revision in about box, and log new version
	CREV=$(subversion__svn_info "src" "Revision")
	echo ${CREV} > "${S}"/build/LASTCHANGE.in || die "setting revision failed"
	. src/chrome/VERSION
	elog "Installing/updating to version ${MAJOR}.${MINOR}.${BUILD}.${PATCH}_p${CREV} "
}

remove_bundled_lib() {
	einfo "Removing bundled library $1 ..."
	local out
	out="$(find $1 -mindepth 1 \! -iname '*.gyp' -print -delete)" \
		|| ewarn "failed to remove bundled library $1"
	if [[ -z $out ]]; then
		ewarn "no files matched when removing bundled library $1"
	fi
}

pkg_setup() {
	CHROMIUM_HOME="/usr/$(get_libdir)/chromium-browser"
}

src_prepare() {
	# Allow us to build with system SSL support,
	# see http://crbug.com/57275.
	epatch "${FILESDIR}"/${PN}-system-ssl-r0.patch
}

src_configure() {
	local myconf=""

	# Never tell the build system to "enable" SSE2, it has a few unexpected
	# additions, bug #336871.
	myconf+=" -Ddisable_sse2=1"

	# Use system-provided libraries.
	# TODO: use_system_hunspell (upstream changes needed).
	myconf+="
		-Duse_system_bzip2=1
		-Duse_system_ffmpeg=1
		-Duse_system_icu=1
		-Duse_system_libevent=1
		-Duse_system_libjpeg=1
		-Duse_system_libpng=1
		-Duse_system_libxml=1
		-Duse_system_ssl=1
		-Duse_system_zlib=1"

	# The system-provided ffmpeg supports more codecs. Enable them in chromium.
	myconf="${myconf} -Dproprietary_codecs=1"

	if use system-sqlite; then
		myconf+=" -Duse_system_sqlite=1"
	fi

	# The dependency on cups is optional, see bug #324105.
	if use cups; then
		myconf+=" -Duse_cups=1"
	else
		myconf+=" -Duse_cups=0"
	fi

	if use "gnome-keyring"; then
		myconf+=" -Duse_gnome_keyring=1 -Dlinux_link_gnome_keyring=1"
	else
		# TODO: we should also disable code trying to dlopen
		# gnome-keyring in that case.
		myconf+=" -Duse_gnome_keyring=0 -Dlinux_link_gnome_keyring=0"
	fi

	# Enable sandbox.
	myconf+="
		-Dlinux_sandbox_path=${CHROMIUM_HOME}/chrome_sandbox
		-Dlinux_sandbox_chrome_path=${CHROMIUM_HOME}/chrome"

	if host-is-pax; then
		# Prevent the build from failing (bug #301880). The performance
		# difference is very small.
		myconf+=" -Dv8_use_snapshot=0"
	fi

	# Use target arch detection logic from bug #296917.
	local myarch="$ABI"
	[[ $myarch = "" ]] && myarch="$ARCH"

	if [[ $myarch = amd64 ]] ; then
		myconf+=" -Dtarget_arch=x64"
	elif [[ $myarch = x86 ]] ; then
		myconf+=" -Dtarget_arch=ia32"
	elif [[ $myarch = arm ]] ; then
		# TODO: check this again after
		# http://gcc.gnu.org/bugzilla/show_bug.cgi?id=39509 is fixed.
		append-flags -fno-tree-sink

		myconf+=" -Dtarget_arch=arm -Ddisable_nacl=1 -Dlinux_use_tcmalloc=0"
	else
		die "Failed to determine target arch, got '$myarch'."
	fi

	if [[ "$(gcc-major-version)$(gcc-minor-version)" == "44" ]]; then
		myconf+=" -Dno_strict_aliasing=1 -Dgcc_version=44"
	fi

	# Work around a likely GCC bug, see bug #331945.
	if [[ "$(gcc-major-version)$(gcc-minor-version)" == "45" ]]; then
		append-flags -fno-ipa-cp
	fi

	# Make sure that -Werror doesn't get added to CFLAGS by the build system.
	# Depending on GCC version the warnings are different and we don't want
	# the build to fail because of that.
	myconf+=" -Dwerror="

	build/gyp_chromium --depth=. ${myconf} || die
}

src_compile() {
	emake chrome chrome_sandbox BUILDTYPE=Release V=1 || die
}

src_install() {
	exeinto "${CHROMIUM_HOME}"
	pax-mark m out/Release/chrome
	doexe out/Release/chrome
	doexe out/Release/chrome_sandbox || die
	fperms 4755 "${CHROMIUM_HOME}/chrome_sandbox"
	doexe out/Release/xdg-settings || die
	doexe "${FILESDIR}"/chromium-launcher.sh || die

	insinto "${CHROMIUM_HOME}"
	doins out/Release/chrome.pak || die
	doins out/Release/resources.pak || die

	doins -r out/Release/locales || die
	doins -r out/Release/resources || die

	# chrome.1 is for chromium --help
	newman out/Release/chrome.1 chrome.1 || die
	newman out/Release/chrome.1 chromium.1 || die

	# Chromium looks for these in its folder
	# See media_posix.cc and base_paths_linux.cc
	dosym /usr/$(get_libdir)/libavcodec.so.52 "${CHROMIUM_HOME}" || die
	dosym /usr/$(get_libdir)/libavformat.so.52 "${CHROMIUM_HOME}" || die
	dosym /usr/$(get_libdir)/libavutil.so.50 "${CHROMIUM_HOME}" || die

	# Install icon and desktop entry.
	newicon out/Release/product_logo_48.png ${PN}-browser.png || die
	dosym "${CHROMIUM_HOME}/chromium-launcher.sh" /usr/bin/chromium || die
	make_desktop_entry chromium "Chromium" ${PN}-browser "Network;WebBrowser" \
		"MimeType=text/html;text/xml;application/xhtml+xml;"
	sed -e "/^Exec/s/$/ %U/" -i "${D}"/usr/share/applications/*.desktop || die

	# Install GNOME default application entry (bug #303100).
	if use gnome; then
		dodir /usr/share/gnome-control-center/default-apps || die
		insinto /usr/share/gnome-control-center/default-apps
		doins "${FILESDIR}"/chromium.xml || die
	fi
}
