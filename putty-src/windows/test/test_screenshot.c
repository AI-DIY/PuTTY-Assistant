#include "putty.h"

static NORETURN PRINTF_LIKE(1, 2) void fatal_error(const char *p, ...)
{
    va_list ap;
    fprintf(stderr, "screenshot: ");
    va_start(ap, p);
    vfprintf(stderr, p, ap);
    va_end(ap);
    fputc('\n', stderr);
    exit(1);
}

void out_of_memory(void) { fatal_error("out of memory"); }

static DWORD target_pid;
static HWND target_window;

static void enable_physical_window_coordinates(void)
{
    typedef HANDLE (WINAPI *SetThreadDpiAwarenessContextFn)(HANDLE);
    HMODULE user32 = GetModuleHandleW(L"user32.dll");
    SetThreadDpiAwarenessContextFn set_thread_dpi_awareness = user32 ?
        (SetThreadDpiAwarenessContextFn)GetProcAddress(
            user32, "SetThreadDpiAwarenessContext") : NULL;

    if (set_thread_dpi_awareness)
        set_thread_dpi_awareness((HANDLE)(INT_PTR)-4);
    else
        SetProcessDPIAware();
}

static BOOL CALLBACK find_process_window(HWND hwnd, LPARAM lParam)
{
    DWORD pid = 0;
    wchar_t classname[64];
    (void)lParam;
    GetWindowThreadProcessId(hwnd, &pid);
    classname[0] = L'\0';
    GetClassNameW(hwnd, classname, lenof(classname));
    if (pid == target_pid && IsWindowVisible(hwnd) &&
        !wcscmp(classname, L"PuTTY")) {
        target_window = hwnd;
        return FALSE;
    }
    return TRUE;
}

int main(int argc, char **argv)
{
    Filename *outfile = NULL;
    HWND target;

    enable_physical_window_coordinates();

    AuxMatchOpt amo = aux_match_opt_init(fatal_error);
    while (!aux_match_done(&amo)) {
        CmdlineArg *val;
        #define match_opt(...) aux_match_opt( \
            &amo, NULL, __VA_ARGS__, (const char *)NULL)
        #define match_optval(...) aux_match_opt( \
            &amo, &val, __VA_ARGS__, (const char *)NULL)

        if (aux_match_arg(&amo, &val)) {
            fatal_error("unexpected argument '%s'", cmdline_arg_to_str(val));
        } else if (match_optval("-o", "--output")) {
            outfile = cmdline_arg_to_filename(val);
        } else if (match_optval("-p", "--process")) {
            target_pid = strtoul(cmdline_arg_to_str(val), NULL, 10);
        } else {
            fatal_error("unrecognised option '%s'\n",
                        cmdline_arg_to_str(amo.arglist->args[amo.index]));
        }
    }

    if (!outfile)
        fatal_error("expected an output file name");

    if (target_pid) {
        EnumWindows(find_process_window, 0);
        target = target_window;
    } else {
        target = FindWindowW(L"PuTTY", NULL);
    }
    if (!target)
        fatal_error("PuTTY window was not found");

    char *err = save_screenshot(target, outfile);
    if (err)
        fatal_error("%s", err);
    filename_free(outfile);

    return 0;
}
