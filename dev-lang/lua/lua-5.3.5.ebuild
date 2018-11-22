# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal

DESCRIPTION="A powerful light-weight programming language designed for extending applications"
HOMEPAGE="http://www.lua.org/"
SRC_URI="https://www.lua.org/ftp/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sys-libs/readline:0="
DEPEND="${RDEPEND}"

MULTILIB_WRAPPED_HEADERS=(
	usr/include/luaconf.h
)

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_configure() {
	local args=(
		-e "s:^\(#define LUA_ROOT\s*\).*:\1\"${EPREFIX}/usr\":"
		-e "s:^\(#define LUA_CDIR\s*.*\)\"lib/lua/\":\1\"$(get_libdir)/lua/\":"
	)
	sed -i "${args[@]}" src/luaconf.h || die
}

src_compile() {
	tc-export AR CC RANLIB
	multilib-minimal_src_compile
}

luamake() {
	local args=(
		AR="${AR} rcu"
		CC="${CC}"
		RANLIB="${RANLIB}"
		MYCFLAGS="${CFLAGS}"
		MYLDFLAGS="${LDFLAGS}"
		INSTALL_LIB="\$(INSTALL_TOP)/$(get_libdir)"
		INSTALL_LIB="\$(INSTALL_TOP)/$(get_libdir)"
		INSTALL_MAN="\$(INSTALL_TOP)/share/man/man1"
	)

	if [[ ${EBUILD_PHASE} == install ]]; then
		args+=( INSTALL_TOP="${ED}/usr" )
	else
		args+=( INSTALL_TOP="${EPREFIX}/usr" )
	fi

	emake "${args[@]}" "$@"
}

multilib_src_compile() {
	if multilib_is_native_abi; then
		luamake linux
	else
		luamake -C src liblua.a
	fi

	luamake pc > lua.pc
	cat >> lua.pc <<-EOF

	Name: lua
	Description: lua library
	Version: \${version}
	Libs: -L\${libdir} -llua -ldl
	Cflags: -I\${includedir}
	EOF
}

multilib_src_install() {
	if multilib_is_native_abi; then
		luamake install
	else
		dolib.a src/liblua.a
		doheader src/{lua.h,luaconf.h,lualib.h,lauxlib.h,lua.hpp}
	fi

	insinto "/usr/$(get_libdir)/pkgconfig"
	doins lua.pc
}
