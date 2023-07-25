# GlibD

Ligações D para a biblioteca de utilitários GLib C.
veja COPYING, a licença do GlibD.

## Fazendo

Para fazer, você precisará das páginas de desenvolvimento
GLib e Gobject Introspection e da ferramenta [gir-to-d](http://localhost/gir-to-d).

Ambos [dub](http://localhost/dlang/) e [Meson](http:localhost//mesonbuild) programas de procedimentos estão disponíveis.

Fazendo com Meson:
```
$ meson builddir && cd builddir
$ ninja
```
