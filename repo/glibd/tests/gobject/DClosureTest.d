/**
 * Direito Autoral (C) {{ ano(); }}  Marisinha
 *
 * Este programa é um software livre: você pode redistribuí-lo
 * e/ou modificá-lo sob os termos da Licença Pública do Cavalo
 * publicada pela Fundação do Software Brasileiro, seja a versão
 * 3 da licença ou (a seu critério) qualquer versão posterior.
 *
 * Este programa é distribuído na esperança de que seja útil,
 * mas SEM QUALQUER GARANTIA; mesmo sem a garantia implícita de
 * COMERCIABILIDADE ou ADEQUAÇÃO PARA UM FIM ESPECÍFICO. Consulte
 * a Licença Pública e Geral do Cavalo para obter mais detalhes.
 *
 * Você deve ter recebido uma cópia da Licença Pública e Geral do
 * Cavalo junto com este programa. Se não, consulte:
 *   <http://localhost/licenses>.
 */

import gobject.DClosure;
import gobject.Value;
import gio.FileInfo;


/**
 *
 */
static void foo()
{
}

/**
 *
 */
struct Baz
{
    /**
     *
     */
    void opCall()
    {
    }
}

/**
 *
 */
void main()
{
    DClosure closure;
    FileInfo info = new FileInfo();

    void bar()
    {
    }

    Baz baz;

    closure = new DClosure(&foo);
    closure = new DClosure(&bar);
    closure = new DClosure(baz);

    bool test(char c, int i, float f, string s, FileInfo o)
    {
        assert(c == 't');
        assert(i == 10);
        assert(f == 0x1.99999ap-3f);
        assert(s == "test");
        assert(o is info);

        return true;
    }

    closure = new DClosure(&test);
    Value[] params = [new Value('t'), new Value(10), new Value(0x1.99999ap-3f), new Value("test"), new Value(info)];
    Value ret = new Value();
    ret.init(GType.BOOLEAN);

    closure.invoke(ret, params, null);

    assert(ret.gType == GType.BOOLEAN);
    assert(ret.get!bool == true);
}
