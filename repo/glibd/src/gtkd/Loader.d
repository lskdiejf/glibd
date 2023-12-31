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

module gtkd.Loader;

import std.algorithm : canFind;
import std.stdio;
import std.string;

import gtkd.paths;


/**
 *
 */
public struct Linker
{
    /**
     *
     */
    private static void*[string] loadedLibraries;

    /**
     *
     */
    private static string[][string] loadFailures;

    /**
     *
     */
    extern(C) static void unsupportedSymbol()
    {
        throw new Error("The function you are calling is not pressent in your version of GTK+.");
    }

    /**
     * Vincula o símbolo fornecido.
     *
     * Parâmetros:
     *     funct = A função que estamos vinculando.
     *     symbol = O nome do símbolo para vincular.
     *     libraries = Uma ou mais bibliotecas para procurar o símbolo.
     */
    deprecated("Use the LIBRARY_* symbols defined for each package, instead of gtkd.paths.LIBRARY")
    public static void link(T)(ref T funct, string symbol, LIBRARY[] libraries ...)
    {
        funct = cast(T)getSymbol(symbol, libraries);
    }

    /**
     * Vincula o símbolo fornecido.
     *
     * Parâmetros:
     *     funct = A função que estamos vinculando.
     *     symbol = O nome do símbolo a ser vinculado.
     *     libraries = Uma ou mais bibliotecas para procurar o símbolo.
     */
    public static void link(T)(ref T funct, string symbol, const string[] libraries ...)
    {
        funct = cast(T)getSymbol(symbol, libraries);
    }

    /**
     * Obtém um símbolo de uma das bibliotecas fornecidas.
     *
     * Parâmetros:
     *     symbol = O nome do símbolo para vincular.
     *     libraries = Uma ou mais bibliotecas para procurar o símbolo.
     */
    deprecated("Use the LIBRARY_* symbols defined for each package, instead of gtkd.paths.LIBRARY")
    public static void* getSymbol(string symbol, LIBRARY[] libraries ...)
    {
        string[] libStr = new string[libraries.length];

        foreach (i, library; libraries )
        {
            libStr[i] = importLibs[library];
        }

        return getSymbol(symbol, libStr);
    }

    /**
     * Obtém um símbolo de uma das bibliotecas fornecidas.
     *
     * Parâmetros:
     *     symbol = O nome do símbolo a ser vinculado.
     *     libraries = Uma ou mais bibliotecas para procurar o símbolo.
     */
    public static void* getSymbol(string symbol, const string[] libraries ...)
    {
        void* handle;

        foreach ( library; libraries )
        {
            if(!(library in loadedLibraries))
            {
                loadLibrary(library);
            }

            handle = pGetSymbol(loadedLibraries[library], symbol);

            if (handle !is null)
            {
                break;
            }
        }

        if ( handle is null )
        {
            foreach (library; libraries)
            {
                loadFailures[library] ~= symbol;
            }

            handle = &unsupportedSymbol;
        }

        return handle;
    }

    /**
     * Carrega uma biblioteca.
     */
    public static void loadLibrary(string library)
    {
        void* handle;

        if (library.canFind(';'))
        {
            foreach (lib; library.split(';'))
            {
                handle = pLoadLibrary(lib);

                if (handle)
                {
                    break;
                }
            }
        } else
        {
            handle = pLoadLibrary(library);
        }

        if (handle is null)
        {
            throw new Exception("Library load failed ("~ library ~"): "~ getErrorMessage());
        }

        loadedLibraries[library] = handle;
    }

    /**
     * Descarregar uma biblioteca.
     */
    deprecated("Use the LIBRARY_* symbols defined for each package, instead of gtkd.paths.LIBRARY")
    public static void unloadLibrary(LIBRARY library)
    {
        unloadLibrary(importLibs[library]);
    }

    /**
     * Descarregar uma biblioteca.
     */
    public static void unloadLibrary(string library)
    {
        pUnloadLibrary(loadedLibraries[library]);
        loadedLibraries.remove(library);
    }

    /**
     *
     */
    public static void unloadLibrary(const string[] libraries)
    {
        foreach (lib; libraries)
        {
            unloadLibrary(lib);
        }
    }

    /**
     * Verifica se algum símbolo falhou ao carregar.
     * Devolve: true se TODOS os símbolos forem carregados.
     */
    public static bool isPerfectLoad()
    {
        return loadFailures.keys.length == 0;
    }

    /**
     * Obtém todas as bibliotecas carregadas.
     * Devolve: Uma matriz com as bibliotecas carregadas.
     */
    public static string[] getLoadLibraries()
    {
        return loadedLibraries.keys;
    }

    /**
     * Imprima todas as bibliotecas carregadas.
     */
    public static void dumpLoadLibraries()
    {
        foreach (lib; getLoadLibraries())
        {
            writefln("Loaded lib = %s", lib);
        }
    }

    /**
     * Verifica se uma biblioteca está carregada.
     * Devolve: true é que a biblioteca foi carregada com sucesso.
     */
    deprecated("Use the LIBRARY_* symbols defined for each package, instead of gtkd.paths.LIBRARY")
    public static bool isLoaded(LIBRARY library)
    {
        return isLoaded(importLibs[library]);
    }

    /**
     * Verifica se uma biblioteca está carregada.
     * Devolve: true é que a biblioteca foi carregada com sucesso.
     */
    public static bool isLoaded(string library)
    {
        if (library in loadedLibraries)
        {
            return true;
        } else
        {
            return false;
        }
    }

    /**
     *
     */
    public static bool isLoaded(const string[] libraries)
    {
        return isLoaded(libraries[0]);
    }

    /**
     * Obtém todos os carregamentos com falha para uma
     * biblioteca específica.
     *
     * Devolve: Um vetor de nomes falhou ao carregar para
     *          uma biblioteca específica ou nula se nenhuma
     *          foi encontrada.
     */
    deprecated("Use the LIBRARY_* symbols defined for each package, instead of gtkd.paths.LIBRARY")
    public static string[] getLoadFailures(LIBRARY library)
    {
        return getLoadFailures(importLibs[library]);
    }

    /**
     * Obtém todos os carregamentos com falha para uma
     * biblioteca específica.
     *
     * Devolve: Um vetor de nomes falhou ao carregar
     *          para uma biblioteca específica ou nula
     *          se nenhuma foi encontrada.
     */
    public static string[] getLoadFailures(string library)
    {
        if ( library in loadFailures )
        {
            return loadFailures[library];
        } else
        {
            return null;
        }
    }

    /**
     *
     */
    public static string[] getLoadFailures(const string[] libraries)
    {
        string[] failures;

        foreach ( lib; libraries )
        {
            failures ~= getLoadFailures(lib);
        }

        return failures;
    }

    /**
     * Imprimir todos os símbolos que falharam ao carregar.
     */
    public static void dumpFailedLoads()
    {
        foreach (library; loadedLibraries.keys)
        {
            foreach (symbol; getLoadFailures(library))
            {
                writefln("failed (%s) %s", library, symbol);
            }
        }
    }

    /**
     *
     */
    static ~this()
    {
        foreach (library; loadedLibraries.keys)
        {
            unloadLibrary(library);
        }
    }
}

/**
 * Implementação específica da plataforma abaixo.
 */

/**
 *
 */
version(Windows)
{
    import core.sys.windows.winbase : LoadLibraryA,
        GetProcAddress,
        FreeLibrary,
        GetLastError,
        FormatMessageA,
        FORMAT_MESSAGE_FROM_SYSTEM,
        FORMAT_MESSAGE_ARGUMENT_ARRAY;

    import core.sys.windows.winnt : LANG_NEUTRAL,
        IMAGE_FILE_MACHINE_AMD64,
        IMAGE_FILE_MACHINE_I386;

    /**
     *
     */
    extern(Windows)
    {
        int SetDllDirectoryA(const(char)* path);
    }

    /**
     *
     */
    private void* pLoadLibrary(string libraryName)
    {
        setDllPath();

        return LoadLibraryA(cast(char*)toStringz(libraryName));
    }

    /**
     *
     */
    private void* pGetSymbol(void* handle, string symbol)
    {
        return GetProcAddress(handle, cast(char*)toStringz(symbol));
    }

    /**
     *
     */
    private alias FreeLibrary pUnloadLibrary;

    /**
     *
     */
    private string getErrorMessage()
    {
        char[] buffer = new char[2048];
        buffer[0] = '\0';

        FormatMessageA(FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_ARGUMENT_ARRAY,
            null,
            GetLastError(),
            LANG_NEUTRAL,
            buffer.ptr,
            cast(uint)buffer.length,
            cast(char**)["\0".ptr].ptr);

        return buffer.ptr.fromStringz.idup;
    }

    /**
     *
     */
    private void setDllPath()
    {
        static bool isSet;

        if (isSet)
        {
            return;
        }

        string gtkPath = getGtkPath();

        if (gtkPath.length > 0)
        {
            SetDllDirectoryA((gtkPath~'\0').ptr);
        }

        isSet = true;
    }

    /**
     *
     */
    private string getGtkPath()
    {
        import std.algorithm;
        import std.path;
        import std.process;
        import std.file;

        foreach (path; splitter(environment.get("PATH"), ';'))
        {
            string dllPath = buildNormalizedPath(path, "libgtk-3-0.dll");

            if (!exists(dllPath))
            {
                continue;
            }

            if (checkArchitecture(dllPath))
            {
                return path;
            }
        }

        return null;
    }

    /**
     *
     */
    private bool checkArchitecture(string dllPath)
    {
        import std.stdio;

        File dll = File(dllPath);

        dll.seek(0x3c);
        int offset = dll.rawRead(new int[1])[0];

        dll.seek(offset);
        uint peHead = dll.rawRead(new uint[1])[0];

        /**
         * Não é um cabeçalho PE.
         */
        if (peHead != 0x00004550)
        {
            return false;
        }

        ushort type = dll.rawRead(new ushort[1])[0];

        version(Win32)
        {
            if (type == IMAGE_FILE_MACHINE_I386)
            {
                return true;
            }
        } else version(Win64)
        {
            if (type == IMAGE_FILE_MACHINE_AMD64)
            {
                return true;
            }
        }

        return false;
    }
} else
{
    import core.sys.posix.dlfcn : dlopen, dlerror, dlsym, dlclose, RTLD_NOW, RTLD_GLOBAL;
    import std.path : buildPath;

    private string lastError;

    /**
     *
     */
    version(OSX)
    {
        string basePath()
        {
            import std.process;

            static string path;

            if (path !is null)
            {
                return path;
            }

            path = environment.get("GTK_BASEPATH");

            if (!path)
            {
                path=environment.get("HOMEBREW_ROOT");

                if (path)
                {
                    path=path.buildPath("lib");
                }
            }

            return path;
        }
    } else
    {
        enum basePath = "";
    }

    /**
     *
     */
    private void* pLoadLibrary(string libraryName, int flag = RTLD_NOW)
    {
        void* handle = dlopen(cast(char*)toStringz(basePath.buildPath(libraryName)), flag | RTLD_GLOBAL);

        if (!handle)
        {
            lastError = dlerror().fromStringz.idup;
        }

        /**
         * Limpar o buffer de falha.
         */
        dlerror();

        return handle;
    }

    /**
     *
     */
    private void* pGetSymbol(void* libraryHandle, string symbol)
    {
        void* symbolHandle = dlsym(libraryHandle, cast(char*)toStringz(symbol));

        /**
         * Limpar o buffer de falha.
         */
        dlerror();

        return symbolHandle;
    }

    /**
     *
     */
    private int pUnloadLibrary(void* libraryHandle)
    {
        return dlclose(libraryHandle);
    }

    /**
     *
     */
    private string getErrorMessage()
    {
        scope(exit) lastError = null;

        return lastError;
    }
}
