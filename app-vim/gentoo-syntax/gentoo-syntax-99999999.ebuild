# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils subversion vim-plugin

DESCRIPTION="vim plugin: Gentoo Ebuild, Eclass, GLEP, ChangeLog and Portage Files syntax highlighting, filetype and indent settings"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI=""
ESVN_REPO_URI="svn://anonsvn.gentoo.org/gentoo-syntax/trunk/gentoo-syntax"

LICENSE="vim"
KEYWORDS=""
IUSE="ignore-glep31"

VIM_PLUGIN_HELPFILES="gentoo-syntax"
VIM_PLUGIN_MESSAGES="filetype"

src_unpack() {
	subversion_src_unpack

	if use ignore-glep31 ; then
		for f in ftplugin/*.vim ; do
			ebegin "Removing UTF-8 rules from ${f} ..."
			sed -i -e 's~\(setlocal fileencoding=utf-8\)~" \1~' ${f} \
				|| die "waah! bad sed voodoo. need more goats."
			eend $?
		done
	fi

	rm Makefile || die
}

pkg_postinst() {
	vim-plugin_pkg_postinst
	if use ignore-glep31 1>/dev/null ; then
		ewarn "You have chosen to disable the rules which ensure GLEP 31"
		ewarn "compliance. When editing ebuilds, please make sure you get"
		ewarn "the character set correct."
	else
		elog "Note for developers and anyone else who edits ebuilds:"
		elog "    This release of gentoo-syntax now contains filetype rules to set"
		elog "    fileencoding for ebuilds and ChangeLogs to utf-8 as per GLEP 31."
		elog "    If you find this feature breaks things, please submit a bug and"
		elog "    assign it to vim@gentoo.org. You can use the 'ignore-glep31' USE"
		elog "    flag to remove these rules."
	fi
	echo
}