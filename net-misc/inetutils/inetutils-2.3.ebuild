# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit pam

DESCRIPTION="Collection of common network programs"
HOMEPAGE="https://www.gnu.org/software/inetutils/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="idn ipv6 kerberos pam tcpd"

DEPEND="
	sys-libs/readline:0=
	ftpd? ( virtual/libcrypt:0= )
	idn? ( net-dns/libidn2:= )
	kerberos? ( virtual/krb5 )
	pam? ( sys-libs/pam )
	tcpd? ( sys-apps/tcp-wrappers )
	uucpd? ( virtual/libcrypt:0= )
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
	logger? ( !sys-apps/util-linux[logger(+)] )
	telnet? ( !net-misc/telnet-bsd !net-misc/netkit-telnetd )
	tftp? ( !net-ftp/tftp-hpa )
	whois? ( !net-misc/whois )
	ifconfig? ( !sys-apps/net-tools )
	traceroute? ( !net-analyzer/traceroute )
"

PROGRAMS=(
	ftpd inetd rexecd rlogind rshd syslogd talkd telnetd tftpd uucpd
	ftp dnsdomainname hostname ping ping6 rcp rexec rlogin rsh logger
	telnet tftp whois ifconfig traceroute
)
IUSE+=" ${PROGRAMS[*]}"

src_configure() {
	local myconf=(
		--disable-clients
		--disable-servers
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

src_install() {
	default
	if use pam; then
		use rexecd && newpamd "${FILESDIR}/rsh.pam" rexec
		use rlogind && newpamd "${FILESDIR}/rlogin.pam" rlogin
		use rshd && newpamd "${FILESDIR}/rsh.pam" rsh
	fi
}
