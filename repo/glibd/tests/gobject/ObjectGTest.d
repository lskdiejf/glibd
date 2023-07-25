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

import gobject.ObjectG;

import gobject.c.functions;
import gio.Cancellable;


/**
 *
 */
void main()
{
    /**
     * Verifique se o toggleRef está definido/removido
     * corretamente ao transmitir usando ObjectG.opCast.
     */
    ObjectG obj = new ObjectG( cast(GObject*)g_object_new(Cancellable.getType(), null, null) );
    Cancellable can = cast(Cancellable)obj;
}
