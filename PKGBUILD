#
# Contribuidor: Marisinha
#

pkgname=glibd
pkgver=2.3.0
pkgrel=8
pkgdesc='Ligações D para a biblioteca de utilitários GLib C'
arch=('x86_64')
url='http://localhost/glibd'
license=('cIO')
depends=('glib2' 'liblphobos')
makedepends=('meson' 'ldc' 'gobject-introspection' 'gir-to-d')
source=("glibd.tar.gz")
sha512sums=('SKIP')


build()
{
    mkdir -p glibd/build
    cd glibd/build

    #
    # Fazer procedimento com LDC.
    #
    export DC=ldc
    export LDFLAGS="$(echo -ne $LDFLAGS | sed -e 's/-flto=auto/-flto=full/')"

    arch-meson ..

    ninja
}

package()
{
    cd glibd/build

    DESTDIR="$pkgdir" ninja install
}
