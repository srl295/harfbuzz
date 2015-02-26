#!/bin/sh
# Run this to generate all the initial makefiles, etc.

test -n "$srcdir" || srcdir=`dirname "$0"`
test -n "$srcdir" || srcdir=.

olddir=`pwd`
cd $srcdir

echo -n "checking for ragel... "
which ragel || {
	echo "You need to install ragel... See http://www.complang.org/ragel/"
	exit 1
}

echo -n "checking for pkg-config... "
which pkg-config || {
	echo "*** No pkg-config found, please install it ***"
	exit 1
}

echo -n "Checking for libtool... "
which libtool || {
    # the error message when libtool is missing may not be obvious
    echo "*** No libtool found, please install it ***"
    exit 1
}

echo -n "checking for gtkdocize... "
if which gtkdocize ; then
	gtkdocize --copy || exit 1
else
	echo "*** No gtkdocize (gtk-doc) found, skipping documentation ***"
	echo "EXTRA_DIST = " > gtk-doc.make
fi

echo -n "checking for autoreconf... "
which autoreconf || {
	echo "*** No autoreconf (autoconf) found, please install it ***"
	exit 1
}

echo "running autoreconf --force --install --verbose"
autoreconf --force --install --verbose || exit $?

cd $olddir
echo "running configure $@"
test -n "$NOCONFIGURE" || "$srcdir/configure" "$@"
make
