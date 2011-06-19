#!/usr/bin/python2 -O

import debian.deb822
import gzip
import StringIO
import urllib2
import os.path
import portage
import portage.dbapi
import portage.manifest
from portage.versions import catpkgsplit, cpv_getversion, vercmp

PKGTREE = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
CATEGORY = "www-plugins"
PACKAGE = "chromium-pdf"
CATPKG = CATEGORY + "/" + PACKAGE
PKGDIR = "%s/%s/%s" % (PKGTREE, CATEGORY, PACKAGE)
URI_BASE = "http://dl.google.com/linux/chrome/deb/"
URI_AMD64 = URI_BASE + "dists/stable/main/binary-amd64/Packages.gz"
URI_I386 = URI_BASE + "dists/stable/main/binary-i386/Packages.gz"

portage_settings = portage.config()
portdb = portage.dbapi.porttree.portdbapi(mysettings = portage_settings)
manifest = portage.manifest.Manifest(PKGDIR, portage_settings["DISTDIR"])

def get_package_list(pkgurl):
    urlfile = urllib2.urlopen(pkgurl)
    sfile = StringIO.StringIO(urlfile.read())
    urlfile.close()
    gzfile = gzip.GzipFile(fileobj = sfile)
    return gzfile.read()

def convert_version_components(debpkg, debver):
    chanmap = { "beta": "_beta", "stable": "_p", "unstable": "_alpha" }
    channel = chanmap[debpkg.split("-")[2]]
    version, revision = debver.split("-r")
    return version + channel + revision

def parse_pkgfile(pkgfile):
    versions = dict()
    for pkg in debian.deb822.Packages.iter_paragraphs(pkgfile):
        vcr = convert_version_components(pkg["Package"], pkg["Version"])
        if not vcr in versions:
            versions[vcr] = dict()
        filename = os.path.basename(pkg["Filename"])
        hashes = { "size": pkg["Size"], "SHA1": pkg["SHA1"] }
        versions[vcr][filename] = hashes
    return versions

def fetch_versions_and_files():
    pkglist = get_package_list(URI_AMD64) + get_package_list(URI_I386)
    pkgfile = StringIO.StringIO(pkglist)
    return parse_pkgfile(pkgfile)
    
def get_versions_dict():
    cplist = portdb.cp_list(CATPKG)
    versions = dict()
    for cpv in cplist:
        cat, pn, ver, rev = catpkgsplit(cpv)
        if not ver in versions:
            versions[ver] = list()
        versions[ver].append(cpv)
    return versions

def get_channel_cpv_list(channel):
    cplist = portdb.cp_list(CATPKG)
    chanlist = list()
    for cpv in cplist:
        cat, pn, ver, rev = catpkgsplit(cpv)
        if ver.find(channel) != -1:
            chanlist.append(cpv)
    return chanlist

def get_best_for_channel(channel):
    cplist = get_channel_cpv_list(channel)
    return portage.versions.best(cplist)

def iif(a, b, c):
    if a:
        return b
    return c

def ebuild_copy(oldcpv, newcpv):
    oldcat, oldpkg, oldver, oldrev = catpkgsplit(oldcpv)
    newcat, newpkg, newver, newrev = catpkgsplit(newcpv)

    oldrev = iif(oldrev == "r0", "", "-" + oldrev)
    newrev = iif(newrev == "r0", "", "-" + newrev)

    oldebuild = "%s-%s%s.ebuild" % (oldpkg, oldver, oldrev)
    oldpath = "%s/%s/%s/%s" % (PKGTREE, oldcat, oldpkg, oldebuild)
    newebuild = "%s-%s%s.ebuild" % (newpkg, newver, newrev)
    newpath = "%s/%s/%s/%s" % (PKGTREE, newcat, newpkg, newebuild)

    print "Copying %s to %s" % (oldebuild, newebuild)
    os.spawnlp(os.P_WAIT, "hg", "hg", "cp", oldpath, newpath)

def get_channel(version):
    if version.find("_alpha") != -1:
        return "_alpha"
    if version.find("_beta") != -1:
        return "_beta"
    return "_p"

def add_ebuild(version):
    channel = get_channel(version)
    bestcpv = get_best_for_channel(channel)
    bestver = cpv_getversion(bestcpv)
    mycpv = "%s/%s-%s" % (CATEGORY, PACKAGE, version)
    ebuild_copy(bestcpv, mycpv)

def remove_ebuilds(cpv_list):
    for cpv in cpv_list:
        cat, pkg = cpv.split("/")
        pn = catpkgsplit(cpv)[1]
        ebuild = pkg + ".ebuild"
        ebuildpath = "%s/%s/%s/%s" % (PKGTREE, cat, pn, ebuild)
        print "Removing %s" % ebuild
        os.spawnlp(os.P_WAIT, "hg", "hg", "rm", ebuildpath)

def add_distfiles(files):
    for filename in files:
        if not manifest.hasFile("DIST", filename):
            print "Adding %s to Manifest" % filename
            manifest.addFile("DIST", filename, hashdict=files[filename], ignoreMissing=True)

def do_updates():
    myversions = get_versions_dict()
    debpkgs = fetch_versions_and_files()
    for debver in debpkgs:
        if not debver in myversions:
            add_ebuild(debver)
            add_distfiles(debpkgs[debver])
    for myver in myversions:
        if not myver in debpkgs:
            remove_ebuilds(myversions[myver])
    manifest.write()

do_updates()

# vim: sw=4 et ts=4
