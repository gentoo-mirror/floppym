# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# @ECLASS: chromium.eclass
# @MAINTAINER:
# Chromium Herd <chromium@gentoo.org>
# @AUTHOR:
# Mike Gilbert <floppym@gentoo.org
# @BLURB: Shared functions for chromium and google-chrome

inherit eutils fdo-mime gnome2-utils linux-info

EXPORT_FUNCTIONS pkg_preinst pkg_postinst pkg_postrm

# @FUNCTION: chromium_check_kernel_config
# @USAGE:
# @DESCRIPTION:
# Ensures the system kernel is configured for full Chromium functionality.
chromium_check_kernel_config() {
	if [[ "${MERGE_TYPE}" == "source" || "${MERGE_TYPE}" == "binary" ]]; then
		# Warn if the kernel does not support features needed for sandboxing.
		# Bug #363987.
		ERROR_PID_NS="PID_NS is required for sandbox to work"
		ERROR_NET_NS="NET_NS is required for sandbox to work"
		CONFIG_CHECK="~PID_NS ~NET_NS"
		check_extra_config
	fi
}

_chromium_crlang() {
	local x
	for x in "$@"; do
		case $x in
			es_LA) echo es-419 ;;
			*) echo "${x/_/-}" ;;
		esac
	done
}

_chromium_syslang() {
	local x
	for x in "$@"; do
		case $x in
			es-419) echo es_LA ;;
			*) echo "${x/-/_}" ;;
		esac
	done
}

_chromium_strip_pak() {
	local x
	for x in "$@"; do
		echo "${x%.pak}"
	done
}

# @FUNCTION: chromium_remove_language_paks
# @USAGE:
# @DESCRIPTION:
# Remove pak files from the current directory for languages that the user has
# not selected via the LINGUAS variable.
chromium_remove_language_paks() {
	local crlangs=$(_chromium_crlang ${LANGS})
	local present_crlangs=$(_chromium_strip_pak *.pak)
	local present_langs=$(_chromium_syslang ${present_crlangs})
	local lang

	# Look for missing pak files.
	for lang in ${crlangs}; do
		if ! has ${lang} ${present_crlangs}; then
			eqawarn "LINGUAS warning: no .pak file for ${lang} (${lang}.pak not found)"
		fi
	done

	# Look for extra pak files.
	# Remove pak files that the user does not want.
	for lang in ${present_langs}; do
		if [[ ${lang} == en_US ]]; then
			continue
		fi
		if ! has ${lang} ${LANGS}; then
			eqawarn "LINGUAS warning: no ${lang} in LANGS"
			continue
		fi
		if ! use linguas_${lang}; then
			rm -v "$(_chromium_crlang ${lang}).pak" || die
		fi
	done
}

chromium_pkg_preinst() {
	gnome2_icon_savelist
}

chromium_pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update

	# For more info see bug #292201, bug #352263, bug #361859.
	elog
	elog "Depending on your desktop environment, you may need"
	elog "to install additional packages to get icons on the Downloads page."
	elog
	elog "For KDE, the required package is kde-base/oxygen-icons."
	elog
	elog "For other desktop environments, try one of the following:"
	elog " - x11-themes/gnome-icon-theme"
	elog " - x11-themes/tango-icon-theme"

	# For more info see bug #359153.
	elog
	elog "Some web pages may require additional fonts to display properly."
	elog "Try installing some of the following packages if some characters"
	elog "are not displayed properly:"
	elog " - media-fonts/arphicfonts"
	elog " - media-fonts/bitstream-cyberbit"
	elog " - media-fonts/droid"
	elog " - media-fonts/ipamonafont"
	elog " - media-fonts/ja-ipafonts"
	elog " - media-fonts/takao-fonts"
	elog " - media-fonts/wqy-microhei"
	elog " - media-fonts/wqy-zenhei"
}

chromium_pkg_postrm() {
	gnome2_icon_cache_update
}
