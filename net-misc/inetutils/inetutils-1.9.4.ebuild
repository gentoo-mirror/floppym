# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit systemd

DESCRIPTION="Collection of common network programs"
HOMEPAGE="https://www.gnu.org/software/inetutils/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="idn ipv6 kerberos pam tcpd"

DEPEND="
	sys-libs/readline:0=
	idn? ( net-dns/libidn )
	kerberos? ( virtual/krb5 )
	pam? ( virtual/pam )
	tcpd? ( sys-apps/tcp-wrappers )
"
RDEPEND="${DEPEND}
	ftp? ( !net-ftp/ftp )
	dnsdomainname? ( !sys-apps/net-tools )
	hostname? ( !sys-apps/coreutils[hostname(-)] !sys-apps/net-tools[hostname(+)] )
	ping? ( !net-misc/iputils )
	ping6? ( !net-misc/iputils[ipv6(+)] )
	rcp? ( !net-misc/netkit-rsh )
	rexec? ( !net-misc/netkit-rsh )
	rlogin? ( !net-misc/netkit-rsh )
	rsh? ( !net-misc/netkit-rsh )
	logger? ( !sys-apps/util-linux )
	telnet? ( !net-misc/telnet-bsd !net-misc/netkit-telnetd )
	tftp? ( !net-ftp/tftp-hpa )
	whois? ( !net-misc/whois )
	ifconfig? ( !sys-apps/net-tools )
	traceroute? ( !net-analyzer/traceroute !net-misc/iputils[traceroute(+)] )
"

PROGRAMS=(
	ftpd inetd rexecd rlogind rshd syslogd talkd telnetd tftpd uucpd
	ftp dnsdomainname hostname ping ping6 rcp rexec rlogin rsh logger
	telnet tftp whois ifconfig traceroute
)
IUSE+=" ${PROGRAMS[@]}"
REQUIRED_USE="|| ( ${PROGRAMS[@]} )"

src_configure() {
	local myconf=(
		--disable-talk
		$(use_enable ipv6)
		$(use_with idn)
		--without-krb4
		$(use_with kerberos krb5)
		--without-shishi
		$(use_with pam)
		$(use_with tcpd wrap)
	)
	local prog
	for prog in "${PROGRAMS[@]}"; do
		myconf+=( $(use_enable "${prog}") )
	done
	econf "${myconf[@]}"
}

socket_tcp() {
	local port=$1
	local daemon=$2
	shift 2

	use "${daemon}" || return

	cat >"${T}/${daemon}@.service" <<-EOF
	[Service]
	ExecStart="${EPREFIX}/usr/libexec/${daemon}" $*
	StandardInput=socket

	[Install]
	Also=${daemon}.socket
	EOF
	systemd_dounit "${T}/${daemon}@.service"

	cat >"${T}/${daemon}.socket" <<-EOF
	[Socket]
	ListenStream=${port}
	Accept=yes

	[Install]
	WantedBy=sockets.target
	EOF
	systemd_dounit "${T}/${daemon}.socket"
}

socket_udp() {
	local port=$1
	local daemon=$2
	shift 2

	use "${daemon}" || return

	cat >"${T}/${daemon}.service" <<-EOF
	[Service]
	ExecStart="${EPREFIX}/usr/libexec/${daemon}" $*
	StandardInput=socket

	[Install]
	Also=${daemon}.socket
	EOF
	systemd_dounit "${T}/${daemon}.service"

	cat >"${T}/${daemon}.socket" <<-EOF
	[Socket]
	ListenDatagram=${port}

	[Install]
	WantedBy=sockets.target
	EOF
	systemd_dounit "${T}/${daemon}.socket"
}

src_install() {
	default
	socket_tcp  21 ftpd
	socket_tcp 512 rexecd
	socket_tcp 513 rlogind
	socket_tcp 514 rshd
	socket_tcp  23 telnetd
	socket_udp  69 tftpd /tftproot
	socket_tcp 540 uucpd
}
