# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

EAPI="3"

inherit eutils flag-o-matic multilib pax-utils toolchain-funcs

DESCRIPTION="Google's open source JavaScript engine"
HOMEPAGE="http://code.google.com/p/v8"
SRC_URI="mirror://gentoo/${P}.tar.xz
	http://dev.gentoo.org/~floppym/distfiles/${P}.tar.xz"
LICENSE="BSD"

SLOT="0"
KEYWORDS="~amd64 ~arm ~x86 ~x64-macos ~x86-macos"
IUSE=""

src_prepare() {
	sed -i -e "s/-Werror//" build/standalone.gypi || die

	mkdir build/gyp || die
	cat > build/gyp/gyp <<-EOF
	#!/bin/sh
	exec gyp "\$@"
	EOF
	chmod +x build/gyp/gyp || die
}

#src_configure() {
	# GCC issues multiple warnings about strict-aliasing issues in v8 code.
#	append-flags -fno-strict-aliasing
#}

src_compile() {
	#local myconf="library=shared soname=on importenv=LINKFLAGS,PATH"

	tc-export AR CC CXX RANLIB
	export LINK="${CXX}"
	# Make the build respect LDFLAGS.
	export LINKFLAGS="${LDFLAGS}"

	# Use target arch detection logic from bug #354601.
	case ${CHOST} in
		i?86-*) myarch=ia32 ;;
		x86_64-*)
			if [[ $ABI = x86 ]] ; then
				myarch=ia32
			else
				myarch=x64
			fi ;;
		arm*-*) myarch=arm ;;
		*) die "Unrecognized CHOST: ${CHOST}"
	esac
	mytarget=$myarch.release

	emake V=1 library=shared soname_version=${PV} $mytarget || die
}

src_test() {
	# Make sure we use the libv8.so from our build directory,
	# and not the /usr/lib one (it may be missing if we are
	# installing for the first time or upgrading), see bug #352374.
	#LD_LIBRARY_PATH="${S}/out/$mytarget/lib.target" tools/test.py --no-build -p dots || die
	#emake V=1 library=shared soname_version=${PV} $mytarget.check || die
	tools/test-wrapper-gypbuild.py -j16 \
		--arch-and-mode=$mytarget \
		--no-presubmit \
		--progress=dots || die
}


src_install() {
	insinto /usr
	doins -r include || die

	dobin out/d8 out/shell || die

	if [[ ${CHOST} == *-darwin* ]] ; then
		install_name_tool \
			-id "${EPREFIX}"/usr/$(get_libdir)/libv8-${PV}$(get_libname) \
			out/$mytarget/lib.target/libv8-${PV}$(get_libname) || die
	fi

	dolib out/$mytarget/lib.target/libv8-${PV}$(get_libname) || die
	dosym libv8-${PV}$(get_libname) /usr/$(get_libdir)/libv8$(get_libname) || die

	dodoc AUTHORS ChangeLog || die
}
