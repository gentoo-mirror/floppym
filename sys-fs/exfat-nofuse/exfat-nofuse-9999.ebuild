# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-r3 linux-mod

DESCRIPTION="Non-fuse read/write kernel driver for exFat and VFat"
HOMEPAGE="https://github.com/dorimanx/exfat-nofuse"
EGIT_REPO_URI="https://github.com/dorimanx/exfat-nofuse.git"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE=""

BUILD_PARAMS='-C "${KV_OUT_DIR}"'
BUILD_TARGETS="modules"
MODULE_NAMES="exfat()"
export KBUILD_EXTMOD="${S}"
export CONFIG_EXFAT_FS=m
