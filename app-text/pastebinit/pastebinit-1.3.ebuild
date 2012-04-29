# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
PYTHON_DEPEND="2:2.6"

inherit python

DESCRIPTION="Send anything you want directly to a pastebin from the command line"
HOMEPAGE="http://www.stgraber.org/category/pastebinit/"
SRC_URI="http://launchpad.net/pastebinit/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	app-text/docbook-xml-dtd:4.2
	dev-libs/libxslt
	sys-devel/gettext
"

echoit() {
	echo "$@"
	"$@"
}

src_prepare() {
	if [[ -n ${LINGUAS+set} ]]; then
		cd po || die
		local x y keep
		for x in *.po; do
			keep=
			for y in ${LINGUAS}; do
				[[ ${y} == ${x%.po}* ]] && keep=1
			done
			[[ -n ${keep} ]] || rm "${x}" || die
		done
	fi
}

src_compile() {
	emake -C po
	echoit xsltproc --nonet \
		/usr/share/sgml/docbook/xsl-stylesheets/manpages/docbook.xsl \
		pastebinit.xml || die
}

src_install() {
	python_convert_shebangs 2 pastebinit
	dobin pastebinit
	doman pastebinit.1
	dodoc README
	insinto /usr/share
	doins -r pastebin.d
	if [[ -d po/mo ]]; then
		insinto /usr/share/locale
		doins -r po/mo/*
	fi
}
