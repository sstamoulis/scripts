#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# muflax <muflax@gmail.com>, 2009

"""
Small script to manage a local Arch repository with newer and/or customized 
builds of existing packages. 
It will display all outdated packages and those that have not yet been build.
Start with --build to build a new repository database.
The script assumes that pkgrel is always an integer for official builds, but
of the form "official_pkgrel.interal_pkgrel" for customized builds. 
"""

# Global variables. Change according to your system.
REPO="/usr/local/src/abs/local/repo"    # location of the local repo
PKGBUILDS="/usr/local/src/abs/local"    # location of the local PKGBUILDs
REPONAME="local"                        # name of the local repo
ARCH="x86_64"                           # architecture of the repo
SYNC="/var/lib/pacman/sync"             # location of pacman's sync directory
IGNORE="custom"                         # directories in PKGBUILDS to ignore

import glob, os, os.path, re, subprocess, sys

def make_repo(packages):
    # remove all packages in REPO
    g = glob.glob("%s/*.pkg.tar.gz" % REPO)
    for pkg in g:
        os.unlink(pkg)

    # remove old db
    db = "%s/%s.db.tar.gz" % (REPO, REPONAME)
    if os.path.isfile(db):
        os.unlink(db)

    # link all packages into REPO, adding them to a new db
    new_packages = []
    for pkg in packages:
        new_pkg = "%s/%s" % (REPO, os.path.basename(pkg))
        # unison doesn't understand hard links, so we use symbolic links for now
        #os.link(pkg, new_pkg) 
        os.symlink(pkg, new_pkg)
        new_packages.append(new_pkg)
        
    # build new db
    cmd = "repo-add --quiet %s/%s.db.tar.gz %s" % (REPO, REPONAME, " ".join(new_packages))
    ret = subprocess.call(cmd, shell=True)
    if ret == 0:
        print("repo successfully build")
    else:
        print("repo-add freaked out")
        sys.exit(1)

# mostly (stupidly) ported from libalpm, so read the code there for comments, 
# but now written under the assumption we always have a pkgrel
def compare_versions(a, b):
    av, ar = a.split("-")
    bv, br = b.split("-")
    
    c = compare_pkgver(av, bv)
    if not c:
        return ar.split(".") >= br.split(".")
    else:
        return c 

def compare_pkgver(a, b):
    if a == b: 
        return 0

    i = j = 0
    la, lb = len(a), len(b)
    while (i < la and j < lb):
        while (i < la and not a[i].isalnum()): 
            i += 1
        while (j < lb and not b[j].isalnum()): 
            j += 1

        if (i == la or j == lb): break

        ii, jj = i, j

        if (a[ii].isdigit()):
            while (ii < la and a[ii].isdigit()): 
                ii += 1 
            while (jj < lb and b[jj].isdigit()): 
                jj += 1 
            isnum = True
        else:
            while (ii < la and a[ii].isalpha()): 
                ii += 1 
            while (jj < lb and b[jj].isalpha()): 
                jj += 1 
            isnum = False

        if i == ii: 
            return -1

        if j == jj:
            if isnum:
                return 1
            else:
                return -1

        if isnum:
            if int(int(a[i:ii]) > int(b[j:jj])):
                return 1
            elif (int(a[i:ii]) < int(b[j:jj])):
                return -1
        else:
            if a[i:ii] != b[j:jj]:
                if a[i:ii] > b[j:jj]:
                    return 1
                else:
                    return -1
        i, j = ii, jj
    if (i == la and j == lb):
        return 0

    if ((i == la and not b[j].isalpha()) or (a[i].isalpha())):
        return -1
    else:
        return 1

def cmp_to_arch(name, version):
    # get the newest version
    # TODO: read order from pacman.conf
    order = ("testing", "core", "extra", "community")
    pacver = ""
    for repo in order:
        g = glob.glob("%s/%s/%s-*" % (SYNC, repo, name))
        # trust that the repos are well-formed and a package
        # has only one version installed
        if g:
            for candidate in g:
                pattern = "%s/%s/%s-[^-]+-[^-]+$" % (SYNC, repo, name)
                m = re.match(pattern, candidate)
                if m:
                    pacver = "-".join(m.group().split("-")[-2:])
                    break
            break
    if not pacver:
        return 1
    else:
        c = compare_versions(version, pacver)
        if c < 0:
            print("WARNING: %s is outdated (%s ==> %s)" % (name, version, pacver))
        return c

def get_newest_packages():
# Reads all PKGBUILDs for the latest version number, finds all matching build 
# packages and returns them, issueing a user warning if no package has been built yet.
    packages = []
    ignore = set(IGNORE.split(" "))
    for path in glob.glob("%s/*" % PKGBUILDS):
        if os.path.isfile("%s/PKGBUILD" % path) and os.path.basename(path) not in ignore:
            locver = subprocess.Popen("source %s/PKGBUILD; echo -n $pkgname $pkgver-$pkgrel" % path, 
                                       shell=True,
                                       stdout=subprocess.PIPE).communicate()[0].decode()
            name, version = locver.split(" ")
            parch = "%s/%s-%s-%s.pkg.tar.gz" % (path, name, version, ARCH)
            pany = "%s/%s-%s-any.pkg.tar.gz" % (path, name, version)
            if os.path.isfile(parch):
                new_pkg = parch
            elif os.path.isfile(pany):
                new_pkg = pany
            else:
                print("WARNING: no package has been built for %s-%s" % (name, version))
                continue

            if cmp_to_arch(name, version) > 0:
                packages.append(new_pkg)
            #else:
                #print("WARNING: %s-%s is outdated" % (name, version))
                
    return packages

def main(argv):
    packages = get_newest_packages()
    for arg in argv:
        if arg == "--build":
            make_repo(packages)
    

if __name__ == "__main__":
    main(sys.argv)
