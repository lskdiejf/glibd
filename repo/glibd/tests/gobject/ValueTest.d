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

import gobject.Value;

import gio.IconIF;
import gio.ThemedIcon;


/**
 *
 */
void main()
{
    Value val = new Value(true);
    assert(val.get!bool());

    val = new Value(42);
    assert(val.get!int() == 42);

    val = new Value(1.12);
    assert(val.get!double() == 1.12);

    ThemedIcon icon = new ThemedIcon("gnome-dev-cdrom-audio");
    val = new Value(icon);
    assert(val.get!ThemedIcon() is icon);
    assert(val.get!IconIF() is icon);
}
