param(
    [string]$ExePath = "",
    [string]$ArtifactDirectory = "",
    [string]$ScreenshotPath = "",
    [switch]$Dangerous
)

$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.Security
$root = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot ".."))
if (-not $ExePath) {
    $ExePath = Join-Path $root "build\Release\putty.exe"
}
if (-not $ArtifactDirectory) {
    $ArtifactDirectory = Join-Path $root "artifacts"
}
$ExePath = [IO.Path]::GetFullPath($ExePath)
$ArtifactDirectory = [IO.Path]::GetFullPath($ArtifactDirectory)
New-Item -ItemType Directory -Force -Path $ArtifactDirectory | Out-Null
if ($ScreenshotPath) {
    $ScreenshotPath = [IO.Path]::GetFullPath($ScreenshotPath)
    New-Item -ItemType Directory -Force -Path (
        [IO.Path]::GetDirectoryName($ScreenshotPath)) | Out-Null
}
$capturePath = Join-Path $ArtifactDirectory "mock-remote-received.txt"
$requestOnePath = Join-Path $ArtifactDirectory "mock-ai-request-1.json"
$requestTwoPath = Join-Path $ArtifactDirectory "mock-ai-request-2.json"
$requestThreePath = Join-Path $ArtifactDirectory "mock-ai-request-3.json"
$authorizationThreePath = Join-Path $ArtifactDirectory "mock-ai-authorization-3.txt"
# The legacy directory is still checked because existing builds write there.
$launchLogDirectory = Join-Path $env:LOCALAPPDATA "PuTTY AI"
function Get-LaunchLogState {
    $state = @{}
    if (Test-Path -LiteralPath $launchLogDirectory) {
        Get-ChildItem -LiteralPath $launchLogDirectory -Filter "*launch*.log" |
            ForEach-Object {
                $state[$_.Name] = [pscustomobject]@{
                    Length = $_.Length
                    LastWriteTimeUtc = $_.LastWriteTimeUtc
                }
            }
    }
    return $state
}
$launchLogBefore = Get-LaunchLogState
Remove-Item -LiteralPath @(
    $capturePath, $requestOnePath, $requestTwoPath, $requestThreePath,
    $authorizationThreePath
) -Force -ErrorAction SilentlyContinue
$firstQuestion = [Text.Encoding]::UTF8.GetString(
    [Convert]::FromBase64String(
        "5YiG5p6Q6L+c56iL5pyN5Yqh5bm25bu66K6u5LiA5p2h5peg5a6z5ZG95Luk"))
$firstAnswerMarker = [Text.Encoding]::UTF8.GetString(
    [Convert]::FromBase64String("6L+c56iL5qih5Z6L5pyN5Yqh5Y+v5Lul6K6/6Zeu"))
$firstStreamMarker = [Text.Encoding]::UTF8.GetString(
    [Convert]::FromBase64String("5qih5ouf5YiG5p6Q"))
$secondQuestion = [Text.Encoding]::UTF8.GetString(
    [Convert]::FromBase64String(
        "6K+357un57ut5YiG5p6Q77yM6L+Z5LiA6L2u5Y+q6ZyA6KaB57qv5paH5pys57uT6K66"))
$secondAnswerMarker = [Text.Encoding]::UTF8.GetString(
    [Convert]::FromBase64String("6L+Z5LiA6L2u5LiN6ZyA6KaB5o+Q5L6b5ZG95Luk"))
$chineseReplyMarker = [Text.Encoding]::UTF8.GetString(
    [Convert]::FromBase64String("6buY6K6k5L2/55So566A5L2T5Lit5paH"))
$optionalCommandMarker = [Text.Encoding]::UTF8.GetString(
    [Convert]::FromBase64String("5LiN6KaB5rGC5q+P5qyh6YO95o+Q5L6b5ZG95Luk"))
$continueMarker = [Text.Encoding]::UTF8.GetString(
    [Convert]::FromBase64String("6K+357un57ut5YiG5p6Q"))
$removedKnowledgeMarker = [Text.Encoding]::UTF8.GetString(
    [Convert]::FromBase64String("5pys5Zyw55+l6K+G"))
$removedKnowledgeBaseMarker = [Text.Encoding]::UTF8.GetString(
    [Convert]::FromBase64String("55+l6K+G5bqT"))
$settingsLabel = [Text.Encoding]::UTF8.GetString(
    [Convert]::FromBase64String("6K6+572u"))
$minimizeLabel = [Text.Encoding]::UTF8.GetString(
    [Convert]::FromBase64String("5pyA5bCP5YyW"))
$maximizeLabel = [Text.Encoding]::UTF8.GetString(
    [Convert]::FromBase64String("5pyA5aSn5YyW5oiW6L+Y5Y6f"))
$closeLabel = [Text.Encoding]::UTF8.GetString(
    [Convert]::FromBase64String("5YWz6Zet"))
$assistantLabel = [Text.Encoding]::UTF8.GetString(
    [Convert]::FromBase64String("QUkg5Yqp5omL"))
$userLabel = [Text.Encoding]::UTF8.GetString(
    [Convert]::FromBase64String("5L2g"))
$sendLabel = [Text.Encoding]::UTF8.GetString(
    [Convert]::FromBase64String("5Y+R6YCBKFMp"))
$contextLabel = [Text.Encoding]::UTF8.GetString(
    [Convert]::FromBase64String(
        "6ZmE5bim5bey6ISx5pWP55qE57uI56uv5LiK5LiL5paH"))
$clearLabel = [Text.Encoding]::UTF8.GetString(
    [Convert]::FromBase64String("5riF56m65a+56K+d"))
$clearDialogTitle = [Text.Encoding]::UTF8.GetString(
    [Convert]::FromBase64String("5riF56m65b2T5YmN5Lya6K+d"))
$readyStatus = [Text.Encoding]::UTF8.GetString(
    [Convert]::FromBase64String("5YeG5aSH5bCx57uq"))
$receivingStatus = [Text.Encoding]::UTF8.GetString(
    [Convert]::FromBase64String("5q2j5Zyo5o6l5pS25Zue5aSNLi4u"))
$completedStatus = [Text.Encoding]::UTF8.GetString(
    [Convert]::FromBase64String("5Zue5aSN5a6M5oiQ"))
$commandDialogTitle = [Text.Encoding]::UTF8.GetString(
    [Convert]::FromBase64String("UHVUVFkgQUkg5ZG95Luk56Gu6K6k"))
$secondConfirmationTitle = [Text.Encoding]::UTF8.GetString(
    [Convert]::FromBase64String("6ZyA6KaB5LqM5qyh56Gu6K6k"))
$commandFilledPrefix = [Text.Encoding]::UTF8.GetString(
    [Convert]::FromBase64String("5ZG95Luk5bey5aGr5YWl"))
$fillTerminalLabel = [Text.Encoding]::UTF8.GetString(
    [Convert]::FromBase64String("5aGr5YWl57uI56uv"))
$connectingStatus = [Text.Encoding]::UTF8.GetString(
    [Convert]::FromBase64String("5q2j5Zyo6L+e5o6l5qih5Z6L5pyN5YqhLi4u"))
$terminalContextMarker = [Text.Encoding]::UTF8.GetString(
    [Convert]::FromBase64String("57uI56uv5LiK5LiL5paH"))
$savedStatus = [Text.Encoding]::UTF8.GetString(
    [Convert]::FromBase64String("6K6+572u5bey5rC45LmF5L+d5a2Y"))
$expectedCommand = if ($Dangerous) {
    "rm -rf /tmp/putty-ai-test"
} else {
    "echo putty-ai-ok"
}
# The legacy registry key is still used for backwards-compatible settings.
$aiRegistryPath = "Software\PuTTY AI"
$aiRegistrySnapshot = @()
$aiRegistryExisted = $false
$aiRegistryKey = [Microsoft.Win32.Registry]::CurrentUser.OpenSubKey($aiRegistryPath)
if ($aiRegistryKey) {
    $aiRegistryExisted = $true
    foreach ($name in $aiRegistryKey.GetValueNames()) {
        $aiRegistrySnapshot += [pscustomobject]@{
            Name = $name
            Value = $aiRegistryKey.GetValue(
                $name, $null,
                [Microsoft.Win32.RegistryValueOptions]::DoNotExpandEnvironmentNames)
            Kind = $aiRegistryKey.GetValueKind($name)
        }
    }
    $aiRegistryKey.Dispose()
}

# Seed the setting removed with the knowledge-base feature. Startup must
# delete it without disturbing the other saved Chat Completions settings.
$testAiRegistryKey = [Microsoft.Win32.Registry]::CurrentUser.CreateSubKey(
    $aiRegistryPath)
try {
    $testAiRegistryKey.SetValue(
        "KnowledgeFile", "C:\obsolete-knowledge.md",
        [Microsoft.Win32.RegistryValueKind]::String)
    $seedApiKeyBytes = [Text.Encoding]::Unicode.GetBytes("test-seed-key`0")
    $protectedSeedApiKey = [Security.Cryptography.ProtectedData]::Protect(
        $seedApiKeyBytes, $null,
        [Security.Cryptography.DataProtectionScope]::CurrentUser)
    try {
        $testAiRegistryKey.SetValue(
            "ApiKey", $protectedSeedApiKey,
            [Microsoft.Win32.RegistryValueKind]::Binary)
    }
    finally {
        [Array]::Clear($seedApiKeyBytes, 0, $seedApiKeyBytes.Length)
        [Array]::Clear($protectedSeedApiKey, 0, $protectedSeedApiKey.Length)
    }
}
finally {
    $testAiRegistryKey.Dispose()
}

# Automated launchers can create a Raw saved session containing only a local
# relay port. Direct @session and -load launches must fill in loopback and
# connect instead of falling back to Configuration.
$bastionSessionName = "PuTTYAIRegression" + [Guid]::NewGuid().ToString("N")
$bastionSessionRegistryPath =
    "Software\SimonTatham\PuTTY\Sessions\$bastionSessionName"
$bastionSessionKey = [Microsoft.Win32.Registry]::CurrentUser.CreateSubKey(
    $bastionSessionRegistryPath)
try {
    $bastionSessionKey.SetValue(
        "HostName", "", [Microsoft.Win32.RegistryValueKind]::String)
    $bastionSessionKey.SetValue(
        "Protocol", "raw", [Microsoft.Win32.RegistryValueKind]::String)
    $bastionSessionKey.SetValue(
        "PortNumber", 18022, [Microsoft.Win32.RegistryValueKind]::DWord)
}
finally {
    $bastionSessionKey.Dispose()
}

$temporaryConfigPath = Join-Path $ArtifactDirectory "putty-temporary-config.txt"
$temporaryConfig = @(
    "NoRemoteWinTitle=1"
    "LineCodePage=UTF-8"
    "HostName=127.0.0.1"
    "LauncherPrivateField=ignored"
    "PortNumber=18023"
    "TermHeight=24"
    "TermWidth=80"
    "UserName=temporary-config-test"
    "WinTitle=temporary-config-regression"
) -join "`n"
[IO.File]::WriteAllText(
    $temporaryConfigPath, $temporaryConfig,
    [Text.UTF8Encoding]::new($false))

Add-Type -TypeDefinition @'
using System;
using System.Text;
using System.Runtime.InteropServices;

public static class PuttyAiAutomation
{
    public delegate bool EnumProc(IntPtr hwnd, IntPtr lParam);

    [DllImport("user32.dll")]
    public static extern IntPtr SetThreadDpiAwarenessContext(IntPtr context);

    [DllImport("user32.dll")]
    public static extern bool EnumWindows(EnumProc callback, IntPtr lParam);

    [DllImport("user32.dll")]
    public static extern uint GetWindowThreadProcessId(IntPtr hwnd, out uint processId);

    [DllImport("user32.dll", CharSet = CharSet.Unicode)]
    public static extern int GetClassName(IntPtr hwnd, StringBuilder text, int length);

    [DllImport("user32.dll", CharSet = CharSet.Unicode)]
    public static extern int GetWindowText(IntPtr hwnd, StringBuilder text, int length);

    [DllImport("user32.dll", CharSet = CharSet.Unicode)]
    public static extern bool SetWindowText(IntPtr hwnd, string text);

    [DllImport("user32.dll")]
    public static extern IntPtr GetDlgItem(IntPtr hwnd, int id);

    [DllImport("user32.dll")]
    public static extern IntPtr SendMessage(IntPtr hwnd, uint message, IntPtr wParam, IntPtr lParam);

    [DllImport("user32.dll", CharSet = CharSet.Unicode, EntryPoint = "SendMessageW")]
    public static extern IntPtr SendMessagePoint(
        IntPtr hwnd, uint message, ref POINT point, IntPtr characterIndex);

    [DllImport("user32.dll", EntryPoint = "SendMessageW")]
    public static extern IntPtr SendMessageWide(
        IntPtr hwnd, uint message, IntPtr wParam, IntPtr lParam);

    [DllImport("user32.dll")]
    public static extern bool PostMessage(IntPtr hwnd, uint message, IntPtr wParam, IntPtr lParam);

    [DllImport("user32.dll", CharSet = CharSet.Unicode, EntryPoint = "SendMessageW")]
    public static extern IntPtr SendMessageText(
        IntPtr hwnd, uint message, IntPtr wParam, string text);

    [DllImport("user32.dll", CharSet = CharSet.Unicode, EntryPoint = "SendMessageW")]
    public static extern IntPtr SendMessageBuffer(
        IntPtr hwnd, uint message, IntPtr wParam, StringBuilder text);

    [DllImport("user32.dll")]
    public static extern bool IsWindowEnabled(IntPtr hwnd);

    [DllImport("user32.dll")]
    public static extern bool IsWindowVisible(IntPtr hwnd);

    [DllImport("user32.dll")]
    public static extern bool IsZoomed(IntPtr hwnd);

    [DllImport("user32.dll")]
    public static extern bool IsIconic(IntPtr hwnd);

    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hwnd, int command);

    [DllImport("user32.dll")]
    public static extern IntPtr GetForegroundWindow();

    [DllImport("user32.dll", CharSet = CharSet.Unicode,
        EntryPoint = "SendMessageTimeoutW")]
    public static extern IntPtr SendMessageTimeout(
        IntPtr hwnd, uint message, IntPtr wParam, IntPtr lParam,
        uint flags, uint timeout, out IntPtr result);

    [DllImport("user32.dll")]
    public static extern bool SetWindowPos(
        IntPtr hwnd, IntPtr insertAfter, int x, int y, int width, int height,
        uint flags);

    [DllImport("user32.dll")]
    public static extern bool SetCursorPos(int x, int y);

    [DllImport("user32.dll")]
    public static extern void mouse_event(
        uint flags, uint dx, uint dy, uint data, UIntPtr extraInfo);

    [DllImport("user32.dll")]
    public static extern bool GetWindowRect(IntPtr hwnd, out RECT rect);

    [DllImport("user32.dll", EntryPoint = "GetWindowLongPtrW")]
    public static extern IntPtr GetWindowLongPtr(IntPtr hwnd, int index);

    [DllImport("user32.dll")]
    public static extern bool RedrawWindow(
        IntPtr hwnd, IntPtr updateRect, IntPtr updateRegion, uint flags);

    [DllImport("user32.dll")]
    public static extern IntPtr GetDC(IntPtr hwnd);

    [DllImport("user32.dll")]
    public static extern int ReleaseDC(IntPtr hwnd, IntPtr dc);

    [DllImport("gdi32.dll")]
    public static extern uint GetPixel(IntPtr dc, int x, int y);

    [DllImport("user32.dll")]
    public static extern IntPtr MonitorFromWindow(IntPtr hwnd, uint flags);

    [DllImport("user32.dll", CharSet = CharSet.Unicode)]
    public static extern bool GetMonitorInfo(IntPtr monitor, ref MONITORINFO info);

    [DllImport("kernel32.dll")]
    public static extern uint GetCurrentThreadId();

    [DllImport("user32.dll")]
    public static extern bool AttachThreadInput(uint idAttach, uint idAttachTo, bool attach);

    [DllImport("user32.dll")]
    public static extern IntPtr SetFocus(IntPtr hwnd);

    [DllImport("user32.dll")]
    public static extern IntPtr GetFocus();

    [DllImport("user32.dll")]
    public static extern bool SetForegroundWindow(IntPtr hwnd);

    [DllImport("user32.dll")]
    public static extern bool BringWindowToTop(IntPtr hwnd);

    [DllImport("kernel32.dll")]
    public static extern IntPtr OpenThread(
        uint access, bool inheritHandle, uint threadId);

    [DllImport("kernel32.dll")]
    public static extern uint SuspendThread(IntPtr thread);

    [DllImport("kernel32.dll")]
    public static extern uint ResumeThread(IntPtr thread);

    [DllImport("kernel32.dll")]
    public static extern bool CloseHandle(IntPtr handle);

    [DllImport("user32.dll")]
    public static extern IntPtr GetAncestor(IntPtr hwnd, uint flags);

    [StructLayout(LayoutKind.Sequential)]
    public struct RECT
    {
        public int left;
        public int top;
        public int right;
        public int bottom;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct POINT
    {
        public int x;
        public int y;
    }

    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
    public struct MONITORINFO
    {
        public int cbSize;
        public RECT rcMonitor;
        public RECT rcWork;
        public uint dwFlags;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct GUITHREADINFO
    {
        public int cbSize;
        public uint flags;
        public IntPtr hwndActive;
        public IntPtr hwndFocus;
        public IntPtr hwndCapture;
        public IntPtr hwndMenuOwner;
        public IntPtr hwndMoveSize;
        public IntPtr hwndCaret;
        public RECT rcCaret;
    }

    [DllImport("user32.dll")]
    public static extern bool GetGUIThreadInfo(uint idThread, ref GUITHREADINFO info);

    public static bool FocusWindow(IntPtr hwnd)
    {
        uint processId;
        uint targetThread = GetWindowThreadProcessId(hwnd, out processId);
        uint currentThread = GetCurrentThreadId();
        bool attached = targetThread != currentThread &&
            AttachThreadInput(currentThread, targetThread, true);
        SetForegroundWindow(GetAncestor(hwnd, 2));
        SetFocus(hwnd);
        bool focused = GetFocus() == hwnd;
        if (attached)
            AttachThreadInput(currentThread, targetThread, false);
        return focused;
    }

    public static IntPtr FocusedWindow(IntPtr hwnd)
    {
        uint processId;
        uint threadId = GetWindowThreadProcessId(hwnd, out processId);
        GUITHREADINFO info = new GUITHREADINFO();
        info.cbSize = Marshal.SizeOf(typeof(GUITHREADINFO));
        return GetGUIThreadInfo(threadId, ref info) ? info.hwndFocus : IntPtr.Zero;
    }

}
'@

# Keep one-pixel custom-frame coordinates in physical pixels. Otherwise
# cross-process window APIs virtualize them at non-100% display scaling.
[PuttyAiAutomation]::SetThreadDpiAwarenessContext([IntPtr](-4)) | Out-Null

function Get-WindowText([IntPtr]$Handle) {
    $buffer = New-Object Text.StringBuilder 65536
    [PuttyAiAutomation]::SendMessageBuffer(
        $Handle, 0x000D, [IntPtr]$buffer.Capacity, $buffer) | Out-Null
    return $buffer.ToString()
}

function Set-UnicodeEditText([IntPtr]$Handle, [string]$Value) {
    [PuttyAiAutomation]::SendMessageText(
        $Handle, 0x000C, [IntPtr]::Zero, "") | Out-Null
    foreach ($character in $Value.ToCharArray()) {
        [PuttyAiAutomation]::SendMessageWide(
            $Handle, 0x0102, [IntPtr][int]$character, [IntPtr]1) | Out-Null
    }
    return Get-WindowText $Handle
}

function Find-Window([int]$ProcessId, [string]$ClassName, [string]$TitlePrefix = "") {
    $script:foundWindow = [IntPtr]::Zero
    [PuttyAiAutomation]::EnumWindows({
        param($hwnd, $lParam)
        $pidValue = 0
        [PuttyAiAutomation]::GetWindowThreadProcessId($hwnd, [ref]$pidValue) | Out-Null
        if ($pidValue -ne $ProcessId) { return $true }
        $class = New-Object Text.StringBuilder 256
        $title = New-Object Text.StringBuilder 512
        [PuttyAiAutomation]::GetClassName($hwnd, $class, $class.Capacity) | Out-Null
        [PuttyAiAutomation]::GetWindowText($hwnd, $title, $title.Capacity) | Out-Null
        if ($class.ToString() -eq $ClassName -and
            (!$TitlePrefix -or $title.ToString().StartsWith($TitlePrefix))) {
            $script:foundWindow = $hwnd
            return $false
        }
        return $true
    }, [IntPtr]::Zero) | Out-Null
    return $script:foundWindow
}

function Assert-WindowResponsive(
    [IntPtr]$Window, [string]$State, [uint32]$Timeout = 250) {
    $result = [IntPtr]::Zero
    # WM_NULL must be answered by the target UI thread without changing state.
    if ([PuttyAiAutomation]::SendMessageTimeout(
            $Window, 0, [IntPtr]::Zero, [IntPtr]::Zero, 2, $Timeout,
            [ref]$result) -eq [IntPtr]::Zero) {
        throw "PuTTY stopped responding after $State"
    }
}

function Activate-TestWindow([IntPtr]$Window, [string]$Name) {
    for ($i = 0; $i -lt 4; $i++) {
        [PuttyAiAutomation]::ShowWindow($Window, 9) | Out-Null
        [PuttyAiAutomation]::BringWindowToTop($Window) | Out-Null
        [PuttyAiAutomation]::SetForegroundWindow($Window) | Out-Null
        if ([PuttyAiAutomation]::GetForegroundWindow() -eq $Window) {
            return $true
        }
        Start-Sleep -Milliseconds 25
    }
    # Some Windows sessions deny programmatic foreground changes even after
    # real input was sent. The activation message regression below remains
    # deterministic, so keep the best-effort switch non-fatal here.
    return $false
}

function Invoke-EdgeResize([IntPtr]$Window, [string]$Edge, [int]$Delta) {
    $rect = [PuttyAiAutomation+RECT]::new()
    if (-not [PuttyAiAutomation]::GetWindowRect($Window, [ref]$rect)) {
        throw "Could not inspect the window before the $Edge drag"
    }
    $x = switch ($Edge) {
        "left" { $rect.left + 1; break }
        "right" { $rect.right - 2; break }
        default { $rect.left + (($rect.right - $rect.left) / 2) }
    }
    $y = switch ($Edge) {
        "top" { $rect.top + 1; break }
        "bottom" { $rect.bottom - 2; break }
        default { $rect.top + (($rect.bottom - $rect.top) / 2) }
    }
    [PuttyAiAutomation]::SetForegroundWindow($Window) | Out-Null
    [PuttyAiAutomation]::SetCursorPos([int]$x, [int]$y) | Out-Null
    [PuttyAiAutomation]::mouse_event(
        0x0002, 0, 0, 0, [UIntPtr]::Zero)
    for ($step = 1; $step -le 8; $step++) {
        $offset = [int]($Delta * $step / 8)
        $nextX = if ($Edge -eq "left") { $x + $offset } elseif ($Edge -eq "right") { $x + $offset } else { $x }
        $nextY = if ($Edge -eq "top") { $y + $offset } elseif ($Edge -eq "bottom") { $y + $offset } else { $y }
        [PuttyAiAutomation]::SetCursorPos($nextX, $nextY) | Out-Null
        Start-Sleep -Milliseconds 25
    }
    [PuttyAiAutomation]::mouse_event(
        0x0004, 0, 0, 0, [UIntPtr]::Zero)
    Start-Sleep -Milliseconds 150
    $after = [PuttyAiAutomation+RECT]::new()
    [PuttyAiAutomation]::GetWindowRect($Window, [ref]$after) | Out-Null
    return $after
}

function Assert-NoStaleFramePixel(
    [IntPtr]$Window, $Before, $After, [string]$Edge) {
    $x = [int](($After.right - $After.left) / 2)
    $y = [int](($After.bottom - $After.top) / 2)
    switch ($Edge) {
        "left" { $x = $Before.left - $After.left; break }
        "right" { $x = $Before.right - 1 - $After.left; break }
        "top" { $y = $Before.top - $After.top; break }
        "bottom" { $y = $Before.bottom - 1 - $After.top; break }
    }
    if ($x -lt 0 -or $y -lt 0 -or
        $x -ge ($After.right - $After.left) -or
        $y -ge ($After.bottom - $After.top)) {
        return
    }
    $dc = [PuttyAiAutomation]::GetDC($Window)
    if ($dc -eq [IntPtr]::Zero) {
        throw "Could not sample the old $Edge frame position after a drag"
    }
    try {
        $pixel = [PuttyAiAutomation]::GetPixel($dc, $x, $y)
        if ($pixel -eq [uint32]0x00977E69) {
            throw "The old $Edge frame remained visible after an interactive resize"
        }
    }
    finally {
        [PuttyAiAutomation]::ReleaseDC($Window, $dc) | Out-Null
    }
}

function Assert-CustomFramePixels([IntPtr]$Window, [string]$State) {
    $rect = [PuttyAiAutomation+RECT]::new()
    [PuttyAiAutomation]::FocusWindow($Window) | Out-Null
    Start-Sleep -Milliseconds 100
    if (-not [PuttyAiAutomation]::GetWindowRect($Window, [ref]$rect)) {
        throw "Could not inspect the custom frame in the $State state"
    }

    # Establish the full parent/child image, then repaint only the parent.
    # Without WS_CLIPCHILDREN the second pass deterministically overwrites the
    # one-pixel child controls that make up the custom frame.
    $fullRedrawFlags = 0x0001 -bor 0x0004 -bor 0x0080 -bor 0x0100
    if (-not [PuttyAiAutomation]::RedrawWindow(
            $Window, [IntPtr]::Zero, [IntPtr]::Zero, $fullRedrawFlags)) {
        throw "Could not establish the custom frame in the $State state"
    }
    $redrawFlags = 0x0001 -bor 0x0004 -bor 0x0040 -bor 0x0100
    if (-not [PuttyAiAutomation]::RedrawWindow(
            $Window, [IntPtr]::Zero, [IntPtr]::Zero, $redrawFlags)) {
        throw "Could not force a parent-only redraw in the $State state"
    }

    $frameControls = @(
        @("top", 0x7120, $true),
        @("bottom", 0x7121, $true),
        @("left", 0x7122, $false),
        @("right", 0x7123, $false)
    )
    $expected = [uint32]0x00977E69
    foreach ($frameControl in $frameControls) {
        $name = [string]$frameControl[0]
        $control = [PuttyAiAutomation]::GetDlgItem(
            $Window, [int]$frameControl[1])
        $controlRect = [PuttyAiAutomation+RECT]::new()
        if ($control -eq [IntPtr]::Zero -or
            -not [PuttyAiAutomation]::GetWindowRect(
                $control, [ref]$controlRect)) {
            throw "Could not inspect the $name custom frame in the $State state"
        }
        $horizontal = [bool]$frameControl[2]
        $length = if ($horizontal) {
            $controlRect.right - $controlRect.left
        } else {
            $controlRect.bottom - $controlRect.top
        }
        $dc = [PuttyAiAutomation]::GetDC($control)
        if ($dc -eq [IntPtr]::Zero) {
            throw "Could not sample the $name custom frame in the $State state"
        }
        try {
            foreach ($numerator in 1..5) {
                $position = [int](($length - 1) * $numerator / 6)
                $x = if ($horizontal) { $position } else { 0 }
                $y = if ($horizontal) { 0 } else { $position }
                $pixel = [PuttyAiAutomation]::GetPixel($dc, $x, $y)
                if ($pixel -ne $expected) {
                    throw "The $name custom frame was partially overwritten " +
                        "in the $State state at offset ${position}: expected " +
                        "0x$($expected.ToString('X8')), got 0x$($pixel.ToString('X8'))"
                }
            }
        }
        finally {
            [PuttyAiAutomation]::ReleaseDC($control, $dc) | Out-Null
        }
    }
}

function Test-BastionDirectLaunch([string[]]$Arguments) {
    $argumentDisplay = $Arguments -join " "
    $probe = Start-Process -FilePath $ExePath -PassThru -ArgumentList $Arguments
    try {
        $mainWindow = [IntPtr]::Zero
        for ($i = 0; $i -lt 50 -and $mainWindow -eq [IntPtr]::Zero; $i++) {
            Start-Sleep -Milliseconds 100
            if ((Find-Window $probe.Id "PuTTYConfigBox") -ne [IntPtr]::Zero) {
                throw "Bastion launch '$argumentDisplay' opened Configuration"
            }
            $mainWindow = Find-Window $probe.Id "PuTTY"
        }
        if ($mainWindow -eq [IntPtr]::Zero) {
            throw "Bastion launch '$argumentDisplay' did not establish its relay connection"
        }
        Start-Sleep -Milliseconds 500
        if (-not (Get-Process -Id $probe.Id -ErrorAction SilentlyContinue)) {
            throw "Bastion launch '$argumentDisplay' closed immediately after launch"
        }
    }
    finally {
        if (Get-Process -Id $probe.Id -ErrorAction SilentlyContinue) {
            Stop-Process -Id $probe.Id -Force
        }
    }
}

$mockScript = Join-Path $PSScriptRoot "mock-services.ps1"
$serverArguments = @(
    "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", $mockScript,
    "-CapturePath", $capturePath,
    "-HttpCaptureDirectory", $ArtifactDirectory
)
if ($Dangerous) { $serverArguments += "-Dangerous" }
$server = Start-Process -FilePath "powershell.exe" -WindowStyle Hidden -PassThru -ArgumentList $serverArguments
$putty = $null
$putty2 = $null
$puttyTab = $null
$otherApp = $null
$hungPutty = $null
$hungThread = [IntPtr]::Zero

try {
    Start-Sleep -Milliseconds 700

    Test-BastionDirectLaunch @("-raw", "-P", "18022")
    Test-BastionDirectLaunch @("@$bastionSessionName")
    Test-BastionDirectLaunch @("-load", $bastionSessionName)
    Test-BastionDirectLaunch @(
        "-load", "tmp:$temporaryConfigPath", "-pw", "mock-password")

    $putty = Start-Process -FilePath $ExePath -PassThru -ArgumentList @(
        "-raw", "127.0.0.1", "-P", "18022"
    )

    $launchLogAfter = Get-LaunchLogState
    $launchLogChanged = $launchLogBefore.Count -ne $launchLogAfter.Count
    foreach ($name in $launchLogBefore.Keys) {
        if (-not $launchLogAfter.ContainsKey($name) -or
            $launchLogBefore[$name].Length -ne $launchLogAfter[$name].Length -or
            $launchLogBefore[$name].LastWriteTimeUtc -ne
                $launchLogAfter[$name].LastWriteTimeUtc) {
            $launchLogChanged = $true
            break
        }
    }
    if ($launchLogChanged) {
        throw "Production build wrote a sensitive command-line launch log"
    }

    $main = [IntPtr]::Zero
    for ($i = 0; $i -lt 50 -and $main -eq [IntPtr]::Zero; $i++) {
        Start-Sleep -Milliseconds 100
        if ((Find-Window $putty.Id "PuTTYConfigBox") -ne [IntPtr]::Zero) {
            throw "Explicit host launch opened Configuration instead of connecting"
        }
        $main = Find-Window $putty.Id "PuTTY"
    }
    if ($main -eq [IntPtr]::Zero) { throw "PuTTY main window was not created" }

    $mainRect = [PuttyAiAutomation+RECT]::new()
    $monitorInfo = [PuttyAiAutomation+MONITORINFO]::new()
    $monitorInfo.cbSize = [Runtime.InteropServices.Marshal]::SizeOf($monitorInfo)
    $monitor = [PuttyAiAutomation]::MonitorFromWindow($main, 2)
    if (-not [PuttyAiAutomation]::GetWindowRect($main, [ref]$mainRect) -or
        $monitor -eq [IntPtr]::Zero -or
        -not [PuttyAiAutomation]::GetMonitorInfo($monitor, [ref]$monitorInfo)) {
        throw "Could not inspect the initial PuTTY window placement"
    }
    $windowCentreX = $mainRect.left + $mainRect.right
    $windowCentreY = $mainRect.top + $mainRect.bottom
    $workCentreX = $monitorInfo.rcWork.left + $monitorInfo.rcWork.right
    $workCentreY = $monitorInfo.rcWork.top + $monitorInfo.rcWork.bottom
    if ([Math]::Abs($windowCentreX - $workCentreX) -gt 48 -or
        [Math]::Abs($windowCentreY - $workCentreY) -gt 48) {
        throw "The initial PuTTY window was not centred in the working area"
    }
    $windowWidth = $mainRect.right - $mainRect.left
    $windowHeight = $mainRect.bottom - $mainRect.top
    $workWidth = $monitorInfo.rcWork.right - $monitorInfo.rcWork.left
    $workHeight = $monitorInfo.rcWork.bottom - $monitorInfo.rcWork.top
    $minimumInitialWidth = [Math]::Floor($workWidth * 0.68) - 4
    $minimumInitialHeight = [Math]::Floor($workHeight * 0.62) - 4
    if ($windowWidth -lt $minimumInitialWidth -or
        $windowHeight -lt $minimumInitialHeight) {
        throw "The initial PuTTY-Assistant workspace was smaller than the " +
            "configured monitor-relative layout"
    }

    $endpoint = $model = $key = $transcript = $prompt = $ask = $context =
        $clear = $apply = $background = $title = $hostTabs =
        $settings = $save = $status = $minimize = $maximize = $close =
        $leftSeparator =
        $outerTop = $outerBottom = $outerLeft = $outerRight =
        [IntPtr]::Zero
    for ($i = 0; $i -lt 50; $i++) {
        $endpoint = [PuttyAiAutomation]::GetDlgItem($main, 0x710A)
        $model = [PuttyAiAutomation]::GetDlgItem($main, 0x710C)
        $key = [PuttyAiAutomation]::GetDlgItem($main, 0x710E)
        $transcript = [PuttyAiAutomation]::GetDlgItem($main, 0x7103)
        $prompt = [PuttyAiAutomation]::GetDlgItem($main, 0x7104)
        $ask = [PuttyAiAutomation]::GetDlgItem($main, 0x7105)
        $context = [PuttyAiAutomation]::GetDlgItem($main, 0x7106)
        $clear = [PuttyAiAutomation]::GetDlgItem($main, 0x7118)
        $background = [PuttyAiAutomation]::GetDlgItem($main, 0x7100)
        $title = [PuttyAiAutomation]::GetDlgItem($main, 0x7101)
        $hostTabs = [PuttyAiAutomation]::GetDlgItem($main, 0x7116)
        $apply = [PuttyAiAutomation]::GetDlgItem($main, 0x7107)
        $settings = [PuttyAiAutomation]::GetDlgItem($main, 0x7108)
        $save = [PuttyAiAutomation]::GetDlgItem($main, 0x7114)
        $status = [PuttyAiAutomation]::GetDlgItem($main, 0x7102)
        $minimize = [PuttyAiAutomation]::GetDlgItem($main, 0x711D)
        $maximize = [PuttyAiAutomation]::GetDlgItem($main, 0x711E)
        $close = [PuttyAiAutomation]::GetDlgItem($main, 0x711F)
        $leftSeparator = [PuttyAiAutomation]::GetDlgItem($main, 0x711B)
        $outerTop = [PuttyAiAutomation]::GetDlgItem($main, 0x7120)
        $outerBottom = [PuttyAiAutomation]::GetDlgItem($main, 0x7121)
        $outerLeft = [PuttyAiAutomation]::GetDlgItem($main, 0x7122)
        $outerRight = [PuttyAiAutomation]::GetDlgItem($main, 0x7123)
        if (-not (@(
            $endpoint, $model, $key, $transcript, $prompt, $ask, $context,
            $clear, $apply, $background, $title, $hostTabs,
            $settings, $save, $status, $minimize, $maximize, $close,
            $leftSeparator,
            $outerTop, $outerBottom, $outerLeft, $outerRight
        ) | Where-Object { $_ -eq [IntPtr]::Zero })) {
            break
        }
        Start-Sleep -Milliseconds 100
    }
    $controlHandles = [ordered]@{
        endpoint = $endpoint; model = $model; key = $key
        transcript = $transcript; prompt = $prompt; ask = $ask
        context = $context; clear = $clear; apply = $apply; settings = $settings
        background = $background; title = $title; hostTabs = $hostTabs
        save = $save; status = $status; minimize = $minimize
        maximize = $maximize; close = $close
        leftSeparator = $leftSeparator
        outerTop = $outerTop; outerBottom = $outerBottom
        outerLeft = $outerLeft; outerRight = $outerRight
    }
    $missingControls = @($controlHandles.Keys | Where-Object {
        $controlHandles[$_] -eq [IntPtr]::Zero
    })
    if ($missingControls.Count) {
        throw "AI panel controls were not created: $($missingControls -join ', ')"
    }
    $sessionMetadata = [PuttyAiAutomation]::GetDlgItem($main, 0x7119)
    if ($sessionMetadata -eq [IntPtr]::Zero -or
        (Get-WindowText $sessionMetadata) -match "\(-\)$") {
        throw "A session without a known login user still displayed a placeholder user"
    }
    if ((Get-WindowText $settings) -ne $settingsLabel -or
        (Get-WindowText $ask) -ne $sendLabel -or
        (Get-WindowText $context) -ne $contextLabel -or
        (Get-WindowText $clear) -ne $clearLabel -or
        (Get-WindowText $status) -ne $readyStatus) {
        throw "AI panel controls were not localized to Chinese " +
            "(settings='$(Get-WindowText $settings)', " +
            "send='$(Get-WindowText $ask)', " +
            "context='$(Get-WindowText $context)', " +
            "clear='$(Get-WindowText $clear)', " +
            "status='$(Get-WindowText $status)')"
    }
    if (-not [PuttyAiAutomation]::IsWindowVisible($context) -or
        -not [PuttyAiAutomation]::IsWindowVisible($clear)) {
        throw "Context switch or standalone clear button was not visible"
    }
    $hostTabsRect = [PuttyAiAutomation+RECT]::new()
    $backgroundRect = [PuttyAiAutomation+RECT]::new()
    $titleRect = [PuttyAiAutomation+RECT]::new()
    $minimizeRect = [PuttyAiAutomation+RECT]::new()
    $closeRect = [PuttyAiAutomation+RECT]::new()
    $outerTopRect = [PuttyAiAutomation+RECT]::new()
    $outerBottomRect = [PuttyAiAutomation+RECT]::new()
    $outerLeftRect = [PuttyAiAutomation+RECT]::new()
    $outerRightRect = [PuttyAiAutomation+RECT]::new()
    $leftSeparatorRect = [PuttyAiAutomation+RECT]::new()
    if (-not [PuttyAiAutomation]::GetWindowRect($main, [ref]$mainRect) -or
        -not [PuttyAiAutomation]::GetWindowRect($hostTabs, [ref]$hostTabsRect) -or
        -not [PuttyAiAutomation]::GetWindowRect($background, [ref]$backgroundRect) -or
        -not [PuttyAiAutomation]::GetWindowRect($title, [ref]$titleRect) -or
        -not [PuttyAiAutomation]::GetWindowRect($minimize, [ref]$minimizeRect) -or
        -not [PuttyAiAutomation]::GetWindowRect($close, [ref]$closeRect) -or
        -not [PuttyAiAutomation]::GetWindowRect($outerTop, [ref]$outerTopRect) -or
        -not [PuttyAiAutomation]::GetWindowRect(
            $outerBottom, [ref]$outerBottomRect) -or
        -not [PuttyAiAutomation]::GetWindowRect($outerLeft, [ref]$outerLeftRect) -or
        -not [PuttyAiAutomation]::GetWindowRect(
            $outerRight, [ref]$outerRightRect) -or
        -not [PuttyAiAutomation]::GetWindowRect(
            $leftSeparator, [ref]$leftSeparatorRect)) {
        throw "Could not inspect the global header layout"
    }
    if ($hostTabsRect.left -ne $outerLeftRect.right -or
        $hostTabsRect.top -ne $outerTopRect.bottom -or
        $hostTabsRect.right -ne $outerRightRect.left -or
        $backgroundRect.top -ne $hostTabsRect.bottom -or
        $backgroundRect.right -ne $outerRightRect.left -or
        $backgroundRect.bottom -ne $outerBottomRect.top -or
        $leftSeparatorRect.bottom -ne $outerBottomRect.top -or
        $titleRect.top -lt $hostTabsRect.bottom -or
        $minimizeRect.top -ne $hostTabsRect.top -or
        $closeRect.right -ne $hostTabsRect.right -or
        $closeRect.bottom -gt
            ($hostTabsRect.top + 44)) {
        throw "Window controls were not placed in the full-width global header " +
            "(tabs=$($hostTabsRect.left),$($hostTabsRect.top),$($hostTabsRect.right),$($hostTabsRect.bottom); " +
            "background=$($backgroundRect.left),$($backgroundRect.top),$($backgroundRect.right),$($backgroundRect.bottom); " +
            "top=$($outerTopRect.left),$($outerTopRect.top),$($outerTopRect.right),$($outerTopRect.bottom); " +
            "right=$($outerRightRect.left),$($outerRightRect.top),$($outerRightRect.right),$($outerRightRect.bottom); " +
            "minimize=$($minimizeRect.left),$($minimizeRect.top),$($minimizeRect.right),$($minimizeRect.bottom); " +
            "close=$($closeRect.left),$($closeRect.top),$($closeRect.right),$($closeRect.bottom))"
    }
    if ($outerTopRect.left -ne $mainRect.left -or
        $outerTopRect.top -ne $mainRect.top -or
        $outerTopRect.right -ne $mainRect.right -or
        ($outerTopRect.bottom - $outerTopRect.top) -ne 1 -or
        $outerBottomRect.left -ne $mainRect.left -or
        $outerBottomRect.right -ne $mainRect.right -or
        $outerBottomRect.bottom -ne $mainRect.bottom -or
        ($outerBottomRect.bottom - $outerBottomRect.top) -ne 1 -or
        $outerLeftRect.left -ne $mainRect.left -or
        $outerLeftRect.top -ne $outerTopRect.bottom -or
        $outerLeftRect.bottom -ne $outerBottomRect.top -or
        ($outerLeftRect.right - $outerLeftRect.left) -ne 1 -or
        $outerRightRect.right -ne $mainRect.right -or
        $outerRightRect.top -ne $outerTopRect.bottom -or
        $outerRightRect.bottom -ne $outerBottomRect.top -or
        ($outerRightRect.right - $outerRightRect.left) -ne 1) {
        throw "The custom frame did not enclose all four sides of the PuTTY window " +
            "(window=$($mainRect.left),$($mainRect.top),$($mainRect.right),$($mainRect.bottom); " +
            "top=$($outerTopRect.left),$($outerTopRect.top),$($outerTopRect.right),$($outerTopRect.bottom); " +
            "bottom=$($outerBottomRect.left),$($outerBottomRect.top),$($outerBottomRect.right),$($outerBottomRect.bottom); " +
            "left=$($outerLeftRect.left),$($outerLeftRect.top),$($outerLeftRect.right),$($outerLeftRect.bottom); " +
            "right=$($outerRightRect.left),$($outerRightRect.top),$($outerRightRect.right),$($outerRightRect.bottom))"
    }
    $mainStyle = [PuttyAiAutomation]::GetWindowLongPtr($main, -16).ToInt64()
    if (($mainStyle -band 0x02000000) -eq 0) {
        throw "The terminal parent does not clip drawing around its child controls"
    }
    Assert-CustomFramePixels $main "initial"

    # Exercise every interactive resize direction. The custom frame must move
    # with the client area and remain repaintable after each edge changes.
    $originalRect = [PuttyAiAutomation+RECT]::new()
    [PuttyAiAutomation]::GetWindowRect($main, [ref]$originalRect) | Out-Null
    $dragCases = @(
        @{ Edge = "left"; Delta = -40 },
        @{ Edge = "right"; Delta = 40 },
        @{ Edge = "top"; Delta = -40 },
        @{ Edge = "bottom"; Delta = 40 }
    )
    foreach ($dragCase in $dragCases) {
        $edge = $dragCase.Edge
        $beforeResize = [PuttyAiAutomation+RECT]::new()
        [PuttyAiAutomation]::GetWindowRect($main, [ref]$beforeResize) | Out-Null
        $afterResize = Invoke-EdgeResize $main $edge $dragCase.Delta
        Assert-NoStaleFramePixel $main $beforeResize $afterResize $edge
        Assert-CustomFramePixels $main "mouse-$edge-edge"
    }
    [PuttyAiAutomation]::SetWindowPos(
        $main, [IntPtr]::Zero, $originalRect.left, $originalRect.top,
        $originalRect.right - $originalRect.left,
        $originalRect.bottom - $originalRect.top, 0x0004 -bor 0x0010) | Out-Null
    Start-Sleep -Milliseconds 150
    Assert-CustomFramePixels $main "mouse-resize-restored"

    $resizeFlags = 0x0004 -bor 0x0010 # SWP_NOZORDER | SWP_NOACTIVATE
    $resizeCases = @(
        @{ Name = "right-edge"; X = $originalRect.left; Y = $originalRect.top;
           Width = ($originalRect.right - $originalRect.left) + 80;
           Height = ($originalRect.bottom - $originalRect.top) },
        @{ Name = "bottom-edge"; X = $originalRect.left; Y = $originalRect.top;
           Width = ($originalRect.right - $originalRect.left) + 80;
           Height = ($originalRect.bottom - $originalRect.top) + 60 },
        @{ Name = "left-edge"; X = $originalRect.left - 40; Y = $originalRect.top;
           Width = ($originalRect.right - $originalRect.left) + 120;
           Height = ($originalRect.bottom - $originalRect.top) + 60 },
        @{ Name = "top-edge"; X = $originalRect.left - 40; Y = $originalRect.top - 30;
           Width = ($originalRect.right - $originalRect.left) + 120;
           Height = ($originalRect.bottom - $originalRect.top) + 90 }
    )
    foreach ($resizeCase in $resizeCases) {
        if (-not [PuttyAiAutomation]::SetWindowPos(
                $main, [IntPtr]::Zero, $resizeCase.X, $resizeCase.Y,
                $resizeCase.Width, $resizeCase.Height, $resizeFlags)) {
            throw "Could not resize PuTTY through the $($resizeCase.Name)"
        }
        Start-Sleep -Milliseconds 150
        Assert-CustomFramePixels $main $resizeCase.Name
    }
    [PuttyAiAutomation]::SetWindowPos(
        $main, [IntPtr]::Zero, $originalRect.left, $originalRect.top,
        $originalRect.right - $originalRect.left,
        $originalRect.bottom - $originalRect.top, $resizeFlags) | Out-Null
    Start-Sleep -Milliseconds 150
    Assert-CustomFramePixels $main "resize-restored"

    # A million-character setting must survive normalization, saving, and a
    # later process startup instead of silently returning to the default.
    $limit = [PuttyAiAutomation]::GetDlgItem($main, 0x7110)
    [PuttyAiAutomation]::SendMessageText(
        $limit, 0x000C, [IntPtr]::Zero, "1000000") | Out-Null
    [PuttyAiAutomation]::SendMessage(
        $main, 0x0111, [IntPtr]0x7114, $save) | Out-Null
    if ((Get-WindowText $limit) -ne "1000000") {
        throw "Saving a 1,000,000-character context limit changed the control to '$(Get-WindowText $limit)'"
    }
    $savedLimitKey = [Microsoft.Win32.Registry]::CurrentUser.OpenSubKey(
        $aiRegistryPath)
    try {
        if (-not $savedLimitKey -or
            [uint32]$savedLimitKey.GetValue("ContextChars", 0) -ne 1000000) {
            throw "A 1,000,000-character context limit was not persisted"
        }
    }
    finally {
        if ($savedLimitKey) { $savedLimitKey.Dispose() }
    }

    if ([PuttyAiAutomation]::GetDlgItem($main, 0x7117) -ne [IntPtr]::Zero) {
        throw "The obsolete user-selectable conversation history control is still present"
    }
    if ([PuttyAiAutomation]::SendMessage(
            $context, 0x00F0, [IntPtr]::Zero, [IntPtr]::Zero) -ne [IntPtr]::Zero) {
        throw "Terminal context was enabled by default"
    }
    [PuttyAiAutomation]::SendMessage(
        $main, 0x0111, [IntPtr]0x7106, $context) | Out-Null
    if ([PuttyAiAutomation]::SendMessage(
            $context, 0x00F0, [IntPtr]::Zero, [IntPtr]::Zero) -eq [IntPtr]::Zero) {
        throw "Terminal context switch did not turn on"
    }
    [PuttyAiAutomation]::SendMessage(
        $main, 0x0111, [IntPtr]0x7106, $context) | Out-Null
    if ([PuttyAiAutomation]::SendMessage(
            $context, 0x00F0, [IntPtr]::Zero, [IntPtr]::Zero) -ne [IntPtr]::Zero) {
        throw "Terminal context switch did not turn off"
    }
    [PuttyAiAutomation]::PostMessage(
        $main, 0x0111, [IntPtr]0x7118, $clear) | Out-Null
    $clearDialog = [IntPtr]::Zero
    for ($i = 0; $i -lt 30 -and $clearDialog -eq [IntPtr]::Zero; $i++) {
        Start-Sleep -Milliseconds 100
        $clearDialog = Find-Window $putty.Id "#32770" $clearDialogTitle
    }
    if ($clearDialog -eq [IntPtr]::Zero) {
        throw "Standalone clear button did not open its confirmation"
    }
    [PuttyAiAutomation]::SendMessage(
        $clearDialog, 0x0111, [IntPtr]7, [IntPtr]::Zero) | Out-Null
    $transcriptRect = [PuttyAiAutomation+RECT]::new()
    $transcriptRectOk = [PuttyAiAutomation]::GetWindowRect(
        $transcript, [ref]$transcriptRect)
    $transcriptWidth = $transcriptRect.right - $transcriptRect.left
    $configuredPanelWidth = [PuttyAiAutomation]::SendMessage(
        $main, 0x802A, [IntPtr]::Zero, [IntPtr]::Zero).ToInt32()
    if ($configuredPanelWidth -ne 440 -or
        -not $transcriptRectOk -or $transcriptWidth -lt 300) {
        throw "AI transcript width was not expanded (measured=$transcriptWidth)"
    }
    $contextRect = [PuttyAiAutomation+RECT]::new()
    $clearRect = [PuttyAiAutomation+RECT]::new()
    [PuttyAiAutomation]::GetWindowRect($context, [ref]$contextRect) | Out-Null
    [PuttyAiAutomation]::GetWindowRect($clear, [ref]$clearRect) | Out-Null
    $contextWidth = $contextRect.right - $contextRect.left
    if ($contextWidth -gt 275 -or $contextRect.right -ge $clearRect.left) {
        throw "Terminal context label and switch were not grouped compactly"
    }
    if ((Get-WindowText $minimize) -ne $minimizeLabel -or
        (Get-WindowText $maximize) -ne $maximizeLabel -or
        (Get-WindowText $close) -ne $closeLabel) {
        throw "Global window controls were not localized or accessible"
    }
    [PuttyAiAutomation]::SendMessage(
        $main, 0x0111, [IntPtr]0x711E, $maximize) | Out-Null
    $maximized = $false
    for ($i = 0; $i -lt 30 -and -not $maximized; $i++) {
        Start-Sleep -Milliseconds 100
        $maximized = [PuttyAiAutomation]::IsZoomed($main)
    }
    if (-not $maximized) {
        throw "Global maximize button did not maximize the PuTTY window"
    }
    Assert-CustomFramePixels $main "maximized"
    [PuttyAiAutomation]::SendMessage(
        $main, 0x0111, [IntPtr]0x711E, $maximize) | Out-Null
    $restored = $false
    for ($i = 0; $i -lt 30 -and -not $restored; $i++) {
        Start-Sleep -Milliseconds 100
        $restored = -not [PuttyAiAutomation]::IsZoomed($main)
    }
    if (-not $restored) {
        throw "Global maximize button did not restore the PuTTY window"
    }
    Assert-CustomFramePixels $main "maximized-then-restored"
    [PuttyAiAutomation]::SendMessage(
        $main, 0x0111, [IntPtr]0x711D, $minimize) | Out-Null
    $minimized = $false
    for ($i = 0; $i -lt 30 -and -not $minimized; $i++) {
        Start-Sleep -Milliseconds 100
        $minimized = [PuttyAiAutomation]::IsIconic($main)
    }
    if (-not $minimized) {
        throw "Global minimize button did not minimize the PuTTY window"
    }
    [PuttyAiAutomation]::ShowWindow($main, 9) | Out-Null
    $restored = $false
    for ($i = 0; $i -lt 30 -and -not $restored; $i++) {
        Start-Sleep -Milliseconds 100
        $restored = -not [PuttyAiAutomation]::IsIconic($main)
    }
    if (-not $restored) {
        throw "PuTTY window could not be restored after minimizing"
    }
    Assert-CustomFramePixels $main "minimized-then-restored"
    if (@(0x7111, 0x7112, 0x7113) | Where-Object {
            [PuttyAiAutomation]::GetDlgItem($main, $_) -ne [IntPtr]::Zero
        }) {
        throw "Removed knowledge-base controls are still present"
    }
    $startupAiKey = [Microsoft.Win32.Registry]::CurrentUser.OpenSubKey(
        $aiRegistryPath)
    try {
        if ($startupAiKey -and
            $null -ne $startupAiKey.GetValue("KnowledgeFile", $null)) {
            throw "Obsolete knowledge-base registry setting was not removed"
        }
    }
    finally {
        if ($startupAiKey) { $startupAiKey.Dispose() }
    }

    # Exercise the real keyboard-message path. WM_SETTEXT alone would miss a
    # regression where PuTTY dispatches WM_KEYDOWN without producing WM_CHAR.
    [PuttyAiAutomation]::SendMessageText(
        $endpoint, 0x000C, [IntPtr]::Zero, "") | Out-Null
    [PuttyAiAutomation]::PostMessage(
        $endpoint, 0x0100, [IntPtr]0x58, [IntPtr]1) | Out-Null
    [PuttyAiAutomation]::PostMessage(
        $endpoint, 0x0101, [IntPtr]0x58, [IntPtr]0xC0000001L) | Out-Null
    Start-Sleep -Milliseconds 200
    if ((Get-WindowText $endpoint) -notmatch "^[xX]$") {
        throw "AI edit controls did not receive translated keyboard input"
    }

    [PuttyAiAutomation]::SendMessageText(
        $endpoint, 0x000C, [IntPtr]::Zero,
        "http://127.0.0.1:18080/v1/chat/completions") | Out-Null
    [PuttyAiAutomation]::SendMessageText(
        $model, 0x000C, [IntPtr]::Zero, "mock-model") | Out-Null
    [PuttyAiAutomation]::SendMessageText(
        $key, 0x000C, [IntPtr]::Zero, "mock-persistent-key") | Out-Null
    $firstQuestionActual = Set-UnicodeEditText $prompt $firstQuestion
    if ($firstQuestionActual -ne $firstQuestion) {
        $actualBase64 = [Convert]::ToBase64String(
            [Text.Encoding]::UTF8.GetBytes($firstQuestionActual))
        throw "Could not enter the first Unicode AI question " +
            "(expectedLength=$($firstQuestion.Length) " +
            "actualLength=$($firstQuestionActual.Length) actual=$actualBase64)"
    }
    [PuttyAiAutomation]::SendMessage(
        $main, 0x0111, [IntPtr]0x7105, $ask) | Out-Null

    $streamObserved = $false
    for ($i = 0; $i -lt 80; $i++) {
        Start-Sleep -Milliseconds 25
        $partialConversation = Get-WindowText $transcript
        if ($partialConversation.Contains($firstStreamMarker) -and
            -not $partialConversation.Contains($firstAnswerMarker) -and
            (Get-WindowText $status) -eq $receivingStatus) {
            $streamObserved = $true
            break
        }
        if ((Get-WindowText $status) -eq $completedStatus) { break }
    }
    if (-not $streamObserved) {
        throw "AI response was not displayed incrementally"
    }
    $partialConversation = Get-WindowText $transcript
    $streamMarkerIndex = $partialConversation.IndexOf($firstStreamMarker)
    if ($streamMarkerIndex -lt 0 -or $partialConversation.Contains("## ")) {
        throw "Streaming Markdown heading syntax was not rendered"
    }
    $streamHeadingStyle = 0L
    $streamRichEditLimit = [Text.Encoding]::UTF8.GetByteCount(
        $partialConversation) + 16
    for ($scan = 0; $scan -lt $streamRichEditLimit; $scan++) {
        [PuttyAiAutomation]::SendMessage(
            $transcript, 0x00B1, [IntPtr]$scan,
            [IntPtr]($scan + 1)) | Out-Null
        $scanStyle = [PuttyAiAutomation]::SendMessage(
            $main, 0x802C, [IntPtr]::Zero, [IntPtr]::Zero).ToInt64()
        $scanHeight = ($scanStyle -shr 8) -band 0xFFFF
        if (($scanStyle -band 0x1) -ne 0 -and $scanHeight -ge 240) {
            $streamHeadingStyle = $scanStyle
            break
        }
    }
    if ($streamHeadingStyle -eq 0) {
        throw "Streaming Markdown heading did not receive heading formatting " +
            "(style=0x$($streamHeadingStyle.ToString('X')))"
    }

    $scrollContentReady = $false
    for ($i = 0; $i -lt 60; $i++) {
        Start-Sleep -Milliseconds 25
        if ((Get-WindowText $transcript).Contains("stream-scroll-anchor")) {
            $scrollContentReady = $true
            break
        }
    }
    if (-not $scrollContentReady) {
        throw "Streaming response did not reach the scroll stability marker"
    }
    [PuttyAiAutomation]::SendMessage(
        $transcript, 0x0115, [IntPtr]6, [IntPtr]::Zero) | Out-Null
    $streamTopLine = [PuttyAiAutomation]::SendMessage(
        $transcript, 0x00CE, [IntPtr]::Zero, [IntPtr]::Zero).ToInt32()

    $requestOk = $false
    for ($i = 0; $i -lt 100; $i++) {
        Start-Sleep -Milliseconds 100
        if ((Get-WindowText $status) -eq $completedStatus) {
            $requestOk = $true
            break
        }
    }
    if (-not $requestOk) {
        throw "AI request did not complete: $(Get-WindowText $status)"
    }
    $completedTopLine = [PuttyAiAutomation]::SendMessage(
        $transcript, 0x00CE, [IntPtr]::Zero, [IntPtr]::Zero).ToInt32()
    if ($streamTopLine -gt 1 -or $completedTopLine -gt 1) {
        throw "Streaming redraw forced the transcript away from the user's scroll position " +
            "(before=$streamTopLine after=$completedTopLine)"
    }

    $conversation = Get-WindowText $transcript
    if (-not $conversation.Contains($firstAnswerMarker)) {
        throw "AI response was not rendered in the transcript"
    }
    if (-not $conversation.Contains($assistantLabel) -or
        -not $conversation.Contains([string][char]0x2500)) {
        throw "AI response label or conversation separator was not rendered"
    }
    $userHeaderIndex = $conversation.IndexOf($userLabel)
    $assistantHeaderIndex = $conversation.IndexOf($assistantLabel)
    if ($userHeaderIndex -lt 0 -or $assistantHeaderIndex -lt 0) {
        throw "User or AI role header was not rendered"
    }
    if ($ScreenshotPath) {
        $screenshotTool = Join-Path $root "build\Release\test_screenshot.exe"
        [PuttyAiAutomation]::SetForegroundWindow($main) | Out-Null
        Start-Sleep -Milliseconds 200
        & $screenshotTool -p $putty.Id -o $ScreenshotPath
        if ($LASTEXITCODE -ne 0 -or -not (Test-Path -LiteralPath $ScreenshotPath)) {
            throw "Could not capture the completed PuTTY-Assistant visual regression image"
        }
    }
    if ($conversation.Contains('## ') -or $conversation.Contains('```') -or
        $conversation.Contains('**') -or $conversation.Contains('*italic*') -or
        $conversation.Contains('~~removed~~') -or
        $conversation.Contains('[docs](') -or
        $conversation.Contains('| --- |') -or
        -not $conversation.Contains([string][char]0x2022)) {
        throw "Completed Markdown syntax was not converted to rich text"
    }
    $tableRow = ([string][char]0x2502) + ' col ' +
        ([string][char]0x2502) + ' value ' + ([string][char]0x2502)
    if (-not $conversation.Contains(([string][char]0x2502) + ' quote') -or
        -not $conversation.Contains('1. item with italic, removed, inline,') -or
        -not $conversation.Contains('docs (https://example.com)') -or
        -not $conversation.Contains($tableRow)) {
        throw "Markdown block or inline content was not rendered as expected"
    }
    $commandMarkerIndex = $conversation.IndexOf($expectedCommand)
    $codeStyleFound = $false
    $italicStyleFound = $false
    $strikeStyleFound = $false
    $linkStyleFound = $false
    $bodyBoldFound = $false
    $userStyleFound = $false
    $assistantStyleFound = $false
    $userHeaderStyleFound = $false
    $assistantHeaderStyleFound = $false
    $userBodyBackColour = 232 -bor (242 -shl 8) -bor (252 -shl 16)
    $userBodyTextColour = 24 -bor (46 -shl 8) -bor (68 -shl 16)
    $assistantBodyTextColour = 29 -bor (33 -shl 8) -bor (37 -shl 16)
    $userHeaderTextColour = 0 -bor (92 -shl 8) -bor (153 -shl 16)
    $assistantHeaderTextColour = 36 -bor (105 -shl 8) -bor (92 -shl 16)
    $richEditLimit = [Text.Encoding]::UTF8.GetByteCount($conversation) + 64
    for ($scan = 0; $scan -lt $richEditLimit; $scan++) {
        [PuttyAiAutomation]::SendMessage(
            $transcript, 0x00B1, [IntPtr]$scan,
            [IntPtr]($scan + 1)) | Out-Null
        $scanStyle = [PuttyAiAutomation]::SendMessage(
            $main, 0x802C, [IntPtr]::Zero, [IntPtr]::Zero).ToInt64()
        $scanBackColour = [PuttyAiAutomation]::SendMessage(
            $main, 0x802D, [IntPtr]::Zero, [IntPtr]::Zero).ToInt64() -band 0xFFFFFF
        $scanTextColour = [PuttyAiAutomation]::SendMessage(
            $main, 0x802B, [IntPtr]::Zero, [IntPtr]::Zero).ToInt64() -band 0xFFFFFF
        $scanHeight = ($scanStyle -shr 8) -band 0xFFFF
        if (($scanStyle -band 0x10) -ne 0) {
            $codeStyleFound = $true
        }
        if (($scanStyle -band 0x2) -ne 0) { $italicStyleFound = $true }
        if (($scanStyle -band 0x4) -ne 0) { $linkStyleFound = $true }
        if (($scanStyle -band 0x8) -ne 0) { $strikeStyleFound = $true }
        if (($scanStyle -band 0x1) -ne 0 -and $scanHeight -eq 190 -and
            $scanBackColour -eq 0xFFFFFF) { $bodyBoldFound = $true }
        if ($scanBackColour -eq $userBodyBackColour -and
            $scanTextColour -eq $userBodyTextColour) { $userStyleFound = $true }
        if ($scanBackColour -eq 0xFFFFFF -and
            $scanTextColour -eq $assistantBodyTextColour) {
            $assistantStyleFound = $true
        }
        if (($scanStyle -band 0x21) -eq 0x21 -and $scanHeight -eq 200) {
            if ($scanTextColour -eq $userHeaderTextColour -and
                $scanBackColour -eq $userBodyBackColour) {
                $userHeaderStyleFound = $true
            }
            if ($scanTextColour -eq $assistantHeaderTextColour -and
                $scanBackColour -eq 0xFFFFFF) {
                $assistantHeaderStyleFound = $true
            }
        }
    }
    if ($commandMarkerIndex -lt 0 -or -not $codeStyleFound -or
        -not $italicStyleFound -or -not $strikeStyleFound -or
        -not $linkStyleFound -or -not $bodyBoldFound) {
        throw "Markdown inline or code content did not receive rich-text formatting"
    }
    if (-not $userStyleFound -or -not $assistantStyleFound) {
        throw "User and AI messages did not receive distinct visual styles"
    }
    if (-not $userHeaderStyleFound -or -not $assistantHeaderStyleFound) {
        throw "User and AI role headers do not use the same optimized font style"
    }
    if (-not [PuttyAiAutomation]::IsWindowEnabled($apply)) {
        throw "Command candidate was not detected"
    }
    $candidateStart = [PuttyAiAutomation]::SendMessage(
        $main, 0x8031, [IntPtr]::Zero, [IntPtr]::Zero).ToInt32()
    $candidateEnd = [PuttyAiAutomation]::SendMessage(
        $main, 0x8031, [IntPtr]1, [IntPtr]::Zero).ToInt32()
    if ($candidateStart -lt 0 -or $candidateEnd -le $candidateStart) {
        throw "Command candidate was not mapped to its response code block"
    }
    if ([PuttyAiAutomation]::IsWindowVisible($apply)) {
        throw "Command fill action was visible before hovering its code block"
    }
    [PuttyAiAutomation]::SendMessage(
        $transcript, 0x0115, [IntPtr]7, [IntPtr]::Zero) | Out-Null
    $commandMouse = [PuttyAiAutomation]::SendMessage(
        $main, 0x8032, [IntPtr]::Zero, [IntPtr]::Zero)
    $commandMouseValue = $commandMouse.ToInt64()
    $commandX = $commandMouseValue -band 0xFFFF
    $commandY = ($commandMouseValue -shr 16) -band 0xFFFF
    if ($commandX -ge 0x8000) { $commandX -= 0x10000 }
    if ($commandY -ge 0x8000) { $commandY -= 0x10000 }
    [PuttyAiAutomation]::SendMessage(
        $transcript, 0x0200, [IntPtr]::Zero, $commandMouse) | Out-Null
    Start-Sleep -Milliseconds 100
    $applyText = Get-WindowText $apply
    $applyVisible = [PuttyAiAutomation]::IsWindowVisible($apply)
    $applyLocalized = $applyText.Contains($fillTerminalLabel.Substring(0, 2))
    if (-not $applyVisible -or -not $applyLocalized) {
        throw "Hovering the response command did not expose its terminal fill action " +
            "(point=$commandX,$commandY, " +
            "range=$candidateStart..$candidateEnd, visible=" +
            "$applyVisible, text='$applyText')"
    }

    if (-not [PuttyAiAutomation]::FocusWindow($prompt)) {
        throw "Could not focus the AI prompt before terminal focus regression test"
    }
    if ([PuttyAiAutomation]::FocusedWindow($main) -ne $prompt) {
        throw "AI prompt did not receive focus before terminal focus regression test"
    }
    $terminalPoint = [IntPtr](10 -bor (10 -shl 16))
    [PuttyAiAutomation]::SendMessage(
        $main, 0x0201, [IntPtr]1, $terminalPoint) | Out-Null
    [PuttyAiAutomation]::SendMessage(
        $main, 0x0202, [IntPtr]::Zero, $terminalPoint) | Out-Null
    if ([PuttyAiAutomation]::FocusedWindow($main) -ne $main) {
        throw "Clicking the terminal did not restore terminal keyboard focus"
    }

    [PuttyAiAutomation]::PostMessage(
        $main, 0x0111, [IntPtr]0x7107, $apply) | Out-Null
    $confirmation = [IntPtr]::Zero
    for ($i = 0; $i -lt 30 -and $confirmation -eq [IntPtr]::Zero; $i++) {
        Start-Sleep -Milliseconds 100
        $confirmation = Find-Window $putty.Id "#32770" $commandDialogTitle
    }
    if ($confirmation -eq [IntPtr]::Zero) {
        throw "Command confirmation dialog was not shown"
    }
    [PuttyAiAutomation]::SendMessage(
        $confirmation, 0x0111, [IntPtr]6, [IntPtr]::Zero) | Out-Null

    if ($Dangerous) {
        $secondConfirmation = [IntPtr]::Zero
        for ($i = 0; $i -lt 30 -and $secondConfirmation -eq [IntPtr]::Zero; $i++) {
            Start-Sleep -Milliseconds 100
            $secondConfirmation = Find-Window $putty.Id "#32770" $secondConfirmationTitle
        }
        if ($secondConfirmation -eq [IntPtr]::Zero) {
            throw "Dangerous command did not require a second confirmation"
        }
        [PuttyAiAutomation]::SendMessage(
            $secondConfirmation, 0x0111, [IntPtr]6, [IntPtr]::Zero) | Out-Null
    }

    Start-Sleep -Milliseconds 500
    if (-not (Get-WindowText $status).StartsWith($commandFilledPrefix)) {
        throw "The application did not report a successful terminal fill"
    }

    $received = "(buffered by local line discipline)"
    if (Test-Path $capturePath) {
        $received = [Text.Encoding]::UTF8.GetString(
            [IO.File]::ReadAllBytes($capturePath))
        if ($received.Contains("`r") -or $received.Contains("`n")) {
            throw "PuTTY-Assistant automatically sent Enter with the command"
        }
    }
    if ($received -ne "(buffered by local line discipline)" -and
        $received -ne $expectedCommand) {
        throw "Unexpected terminal fill payload: '$received'"
    }

    $secondQuestionActual = Set-UnicodeEditText $prompt $secondQuestion
    if ($secondQuestionActual -ne $secondQuestion) {
        throw "Could not enter the second Unicode AI question"
    }
    [PuttyAiAutomation]::SendMessage(
        $main, 0x0111, [IntPtr]0x7105, $ask) | Out-Null
    if ((Get-WindowText $status) -notin @($connectingStatus, $receivingStatus)) {
        throw "Second AI request did not start"
    }
    $secondRequestOk = $false
    for ($i = 0; $i -lt 100; $i++) {
        Start-Sleep -Milliseconds 100
        if ((Get-WindowText $status) -eq $completedStatus) {
            $secondRequestOk = $true
            break
        }
    }
    if (-not $secondRequestOk) {
        throw "Second AI request did not complete: $(Get-WindowText $status)"
    }
    $conversation = Get-WindowText $transcript
    if (-not $conversation.Contains($secondAnswerMarker)) {
        throw "Plain-text second response was not rendered"
    }
    if ([PuttyAiAutomation]::IsWindowEnabled($apply)) {
        throw "A pure-text response incorrectly left a command candidate enabled"
    }
    $secondMarkerIndex = $conversation.IndexOf($secondAnswerMarker)
    $secondMarkerColor = [PuttyAiAutomation]::SendMessage(
        $main, 0x802E, [IntPtr]::Zero, [IntPtr]::Zero).ToInt32()
    if ($secondMarkerIndex -lt 0 -or
        ($secondMarkerColor -band 0xFFFFFF) -eq 0xFFFFFF) {
        throw "AI transcript response text was rendered in white"
    }

    if (-not (Test-Path $requestOnePath) -or -not (Test-Path $requestTwoPath)) {
        throw "Mock model request captures were not written"
    }
    $requestOne = Get-Content -Raw -Encoding UTF8 $requestOnePath | ConvertFrom-Json
    $requestTwo = Get-Content -Raw -Encoding UTF8 $requestTwoPath | ConvertFrom-Json
    if ($requestOne.messages[0].content -notmatch $chineseReplyMarker -or
        $requestOne.messages[0].content -notmatch $optionalCommandMarker) {
        throw "System prompt does not enforce Chinese, optional-command replies"
    }
    if ($requestOne.stream -ne $true) {
        throw "Chat Completions request did not enable streaming"
    }
    if ($requestOne.messages[-1].content -match $terminalContextMarker) {
        throw "The default request unexpectedly included terminal context"
    }
    if ($requestOne.messages[-1].content -match
        "Terminal context|Local knowledge|User question") {
        throw "Request context still contains English prompt scaffolding"
    }
    $requestOneRaw = Get-Content -Raw -Encoding UTF8 $requestOnePath
    if ($requestOneRaw -match "Local knowledge|KnowledgeFile" -or
        $requestOneRaw.Contains($removedKnowledgeMarker) -or
        $requestOneRaw.Contains($removedKnowledgeBaseMarker)) {
        throw "Model request still contains knowledge-base prompt residue"
    }
    if ($requestTwo.messages.Count -ne 4 -or
        $requestTwo.messages[1].role -ne "user" -or
        $requestTwo.messages[2].role -ne "assistant" -or
        $requestTwo.messages[3].role -ne "user") {
        throw "Second request did not include the previous conversation turn"
    }
    if ($requestTwo.messages[1].content -ne $firstQuestion -or
        $requestTwo.messages[2].content -notmatch $firstAnswerMarker -or
        $requestTwo.messages[3].content -notmatch $continueMarker) {
        throw "Multi-turn conversation content was not preserved"
    }

    [PuttyAiAutomation]::SendMessageText(
        $endpoint, 0x000C, [IntPtr]::Zero,
        "http://127.0.0.1:18080/v1/chat/completions") | Out-Null
    [PuttyAiAutomation]::SendMessageText(
        $model, 0x000C, [IntPtr]::Zero, "persist-model") | Out-Null
    [PuttyAiAutomation]::SendMessageText(
        $key, 0x000C, [IntPtr]::Zero, "persist-key") | Out-Null
    [PuttyAiAutomation]::SendMessage(
        $main, 0x0111, [IntPtr]0x7114, $save) | Out-Null
    if ((Get-WindowText $status) -ne $savedStatus) {
        $actualStatus = Get-WindowText $status
        $actualStatusBase64 = [Convert]::ToBase64String(
            [Text.Encoding]::UTF8.GetBytes($actualStatus))
        throw "Chat Completions settings did not report a permanent save " +
            "(actual=$actualStatusBase64)"
    }

    $savedKey = [Microsoft.Win32.Registry]::CurrentUser.OpenSubKey($aiRegistryPath)
    if (-not $savedKey) { throw "AI registry settings key was not created" }
    try {
        $encryptedApiKey = $savedKey.GetValue("ApiKey")
        if ($savedKey.GetValue("Endpoint") -ne
                "http://127.0.0.1:18080/v1/chat/completions" -or
            $savedKey.GetValue("Model") -ne "persist-model" -or
            $savedKey.GetValueKind("ApiKey") -ne
                [Microsoft.Win32.RegistryValueKind]::Binary -or
            -not ($encryptedApiKey -is [byte[]])) {
            throw "Chat Completions settings were not persisted correctly"
        }
        $plainApiKeyBytes = [Security.Cryptography.ProtectedData]::Unprotect(
            $encryptedApiKey, $null,
            [Security.Cryptography.DataProtectionScope]::CurrentUser)
        try {
            $plainApiKey = [Text.Encoding]::Unicode.GetString(
                $plainApiKeyBytes).TrimEnd([char]0)
            if ($plainApiKey -ne "persist-key") {
                throw "Persisted API key could not be decrypted for this user"
            }
        }
        finally {
            [Array]::Clear($plainApiKeyBytes, 0, $plainApiKeyBytes.Length)
        }
    }
    finally {
        $savedKey.Dispose()
    }

    $puttyTab = Start-Process -FilePath $ExePath -PassThru -ArgumentList @(
        "-raw", "127.0.0.1", "-P", "18022"
    )
    $tabMain = [IntPtr]::Zero
    for ($i = 0; $i -lt 50 -and $tabMain -eq [IntPtr]::Zero; $i++) {
        Start-Sleep -Milliseconds 100
        $tabMain = Find-Window $puttyTab.Id "PuTTY"
    }
    if ($tabMain -eq [IntPtr]::Zero) {
        throw "Second concurrent PuTTY host session was not created"
    }
    $hostTabs = [PuttyAiAutomation]::GetDlgItem($main, 0x7116)
    $tabTranscript = [PuttyAiAutomation]::GetDlgItem($tabMain, 0x7103)
    $sessionCount = 0
    for ($i = 0; $i -lt 30 -and $sessionCount -lt 2; $i++) {
        Start-Sleep -Milliseconds 100
        $sessionCount = [PuttyAiAutomation]::SendMessage(
            $main, 0x802F, [IntPtr]::Zero, [IntPtr]::Zero).ToInt32()
    }
    if ($hostTabs -eq [IntPtr]::Zero -or
        -not [PuttyAiAutomation]::IsWindowVisible($hostTabs) -or
        $sessionCount -lt 2) {
        throw "Concurrent PuTTY sessions were not exposed in the host tab bar"
    }
    [PuttyAiAutomation]::SendMessage(
        $main, 0x0111, [IntPtr]0x711E, $maximize) | Out-Null
    $maximized = $false
    for ($i = 0; $i -lt 30 -and -not $maximized; $i++) {
        Start-Sleep -Milliseconds 100
        $maximized = [PuttyAiAutomation]::IsZoomed($main) -and
            [PuttyAiAutomation]::IsZoomed($tabMain)
    }
    if (-not $maximized) {
        throw "Global maximize did not affect every PuTTY session"
    }
    [PuttyAiAutomation]::SendMessage(
        $main, 0x0111, [IntPtr]0x711E, $maximize) | Out-Null
    $restored = $false
    for ($i = 0; $i -lt 30 -and -not $restored; $i++) {
        Start-Sleep -Milliseconds 100
        $restored = -not [PuttyAiAutomation]::IsZoomed($main) -and
            -not [PuttyAiAutomation]::IsZoomed($tabMain)
    }
    if (-not $restored) {
        throw "Global maximize restore did not affect every PuTTY session"
    }
    [PuttyAiAutomation]::SendMessage(
        $main, 0x0111, [IntPtr]0x711D, $minimize) | Out-Null
    $minimized = $false
    for ($i = 0; $i -lt 30 -and -not $minimized; $i++) {
        Start-Sleep -Milliseconds 100
        $minimized = [PuttyAiAutomation]::IsIconic($main) -and
            [PuttyAiAutomation]::IsIconic($tabMain)
    }
    if (-not $minimized) {
        throw "Global minimize did not affect every PuTTY session"
    }
    [PuttyAiAutomation]::ShowWindow($main, 9) | Out-Null
    [PuttyAiAutomation]::ShowWindow($tabMain, 9) | Out-Null
    $restored = $false
    for ($i = 0; $i -lt 30 -and -not $restored; $i++) {
        Start-Sleep -Milliseconds 100
        $restored = -not [PuttyAiAutomation]::IsIconic($main) -and
            -not [PuttyAiAutomation]::IsIconic($tabMain)
    }
    if (-not $restored) {
        throw "A globally minimized PuTTY session could not be restored"
    }
    if ((Get-WindowText $tabTranscript).Contains($firstAnswerMarker)) {
        throw "AI conversation leaked from one host session into another"
    }
    [PuttyAiAutomation]::SetForegroundWindow($main) | Out-Null
    Start-Sleep -Milliseconds 100
    Assert-CustomFramePixels $main "concurrent-primary"
    [PuttyAiAutomation]::SetForegroundWindow($tabMain) | Out-Null
    Start-Sleep -Milliseconds 100
    Assert-CustomFramePixels $tabMain "concurrent-secondary"
    $targetTabIndex = -1
    for ($i = 0; $i -lt $sessionCount; $i++) {
        $sessionWindow = [PuttyAiAutomation]::SendMessage(
            $main, 0x8030, [IntPtr]$i, [IntPtr]::Zero)
        if ($sessionWindow -eq $tabMain) {
            $targetTabIndex = $i
            break
        }
    }
    if ($targetTabIndex -lt 0) {
        throw "Host tab list did not map to the concurrent PuTTY window"
    }
    $hostTabsRect = [PuttyAiAutomation+RECT]::new()
    [PuttyAiAutomation]::GetWindowRect($hostTabs, [ref]$hostTabsRect) | Out-Null
    $availableTabWidth =
        ($hostTabsRect.right - $hostTabsRect.left) - 48
    $tabWidth = 200
    if ($sessionCount * $tabWidth -gt $availableTabWidth - 100) {
        $tabWidth = [int](($availableTabWidth - 100) / $sessionCount)
    }
    if ($tabWidth -lt 140) { $tabWidth = 140 }
    $tabClick = [IntPtr](
        ((48 + $targetTabIndex * $tabWidth + [int]($tabWidth / 2)) -bor
         (22 -shl 16)))
    [PuttyAiAutomation]::SetForegroundWindow($main) | Out-Null
    [PuttyAiAutomation]::SendMessage(
        $hostTabs, 0x0202, [IntPtr]::Zero, $tabClick) | Out-Null
    Start-Sleep -Milliseconds 200
    $foregroundAfterTab = [PuttyAiAutomation]::GetForegroundWindow()
    $activatedSession = [PuttyAiAutomation]::SendMessage(
        $main, 0x8033, [IntPtr]::Zero, [IntPtr]::Zero)
    if (($foregroundAfterTab -ne [IntPtr]::Zero -and
         $foregroundAfterTab -ne $tabMain) -or
        $activatedSession -ne $tabMain) {
        $tabClickX = 48 + $targetTabIndex * $tabWidth +
            [int]($tabWidth / 2)
        throw "Clicking a host tab did not switch to its PuTTY session " +
            "(index=$targetTabIndex width=$tabWidth x=$tabClickX " +
            "target=$($tabMain.ToInt64()) foreground=" +
            "$($foregroundAfterTab.ToInt64()) activated=" +
            "$($activatedSession.ToInt64()) main=$($main.ToInt64()))"
    }
    Stop-Process -Id $puttyTab.Id -Force
    $puttyTab = $null

    Stop-Process -Id $putty.Id -Force
    $putty = $null
    $putty2 = Start-Process -FilePath $ExePath -PassThru -ArgumentList @(
        "-raw", "127.0.0.1", "-P", "18022"
    )
    $main2 = [IntPtr]::Zero
    for ($i = 0; $i -lt 50 -and $main2 -eq [IntPtr]::Zero; $i++) {
        Start-Sleep -Milliseconds 100
        $main2 = Find-Window $putty2.Id "PuTTY"
    }
    if ($main2 -eq [IntPtr]::Zero) {
        throw "Second PuTTY session was not created for persistence regression"
    }
    $endpoint2 = $model2 = $key2 = $settings2 = $prompt2 = $ask2 =
        $limit2 = $status2 = $close2 = [IntPtr]::Zero
    for ($i = 0; $i -lt 50; $i++) {
        $endpoint2 = [PuttyAiAutomation]::GetDlgItem($main2, 0x710A)
        $model2 = [PuttyAiAutomation]::GetDlgItem($main2, 0x710C)
        $key2 = [PuttyAiAutomation]::GetDlgItem($main2, 0x710E)
        $settings2 = [PuttyAiAutomation]::GetDlgItem($main2, 0x7108)
        $prompt2 = [PuttyAiAutomation]::GetDlgItem($main2, 0x7104)
        $ask2 = [PuttyAiAutomation]::GetDlgItem($main2, 0x7105)
        $limit2 = [PuttyAiAutomation]::GetDlgItem($main2, 0x7110)
        $status2 = [PuttyAiAutomation]::GetDlgItem($main2, 0x7102)
        $close2 = [PuttyAiAutomation]::GetDlgItem($main2, 0x711F)
        if (-not (@(
            $endpoint2, $model2, $key2, $settings2, $prompt2, $ask2, $limit2, $status2,
            $close2
        ) | Where-Object { $_ -eq [IntPtr]::Zero })) {
            break
        }
        Start-Sleep -Milliseconds 100
    }
    if (@(
        $endpoint2, $model2, $key2, $settings2, $prompt2, $ask2, $limit2, $status2,
        $close2
    ) |
        Where-Object { $_ -eq [IntPtr]::Zero }) {
        throw "Second session AI settings controls were not created"
    }
    [PuttyAiAutomation]::SendMessage(
        $main2, 0x0111, [IntPtr]0x7108, $settings2) | Out-Null
    $restoredEndpoint = Get-WindowText $endpoint2
    $restoredModel = Get-WindowText $model2
    $restoredLimit = Get-WindowText $limit2
    $settingsRestored =
        [PuttyAiAutomation]::IsWindowVisible($endpoint2) -and
        $restoredEndpoint -eq "http://127.0.0.1:18080/v1/chat/completions" -and
        $restoredModel -eq "persist-model" -and
        $restoredLimit -eq "1000000"
    if (-not $settingsRestored) {
        $debugKey = [Microsoft.Win32.Registry]::CurrentUser.OpenSubKey(
            $aiRegistryPath)
        $debugRegistryLimit = if ($debugKey) {
            $debugKey.GetValue("ContextChars", "<missing>")
        } else { "<missing-key>" }
        if ($debugKey) { $debugKey.Dispose() }
        throw "Saved Chat Completions settings were not restored in the next session " +
            "(visible=$([PuttyAiAutomation]::IsWindowVisible($endpoint2)); " +
            "endpoint-eq=$($restoredEndpoint -eq 'http://127.0.0.1:18080/v1/chat/completions'); " +
            "model-eq=$($restoredModel -eq 'persist-model'); " +
            "limit-eq=$($restoredLimit -eq '1000000'); " +
            "endpoint-bytes=$([Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($restoredEndpoint))); " +
            "model-bytes=$([Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($restoredModel))); " +
            "limit-bytes=$([Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($restoredLimit))); " +
            "registry-limit='$debugRegistryLimit')"
    }

    # Switching between PuTTY sessions and a separate GUI process must not
    # leave either PuTTY UI thread blocked by activation bookkeeping.
    $otherApp = Start-Process -FilePath "$env:WINDIR\System32\notepad.exe" -PassThru
    $otherWindow = [IntPtr]::Zero
    for ($i = 0; $i -lt 50 -and $otherWindow -eq [IntPtr]::Zero; $i++) {
        Start-Sleep -Milliseconds 100
        $otherWindow = Find-Window $otherApp.Id "Notepad"
    }
    if ($otherWindow -eq [IntPtr]::Zero) {
        throw "The GUI peer used for the window-switch responsiveness test was not created"
    }
    $hungPutty = Start-Process -FilePath $ExePath -PassThru -ArgumentList @(
        "-raw", "127.0.0.1", "-P", "18022"
    )
    $hungWindow = [IntPtr]::Zero
    $hungMetadata = [IntPtr]::Zero
    for ($i = 0; $i -lt 50 -and $hungMetadata -eq [IntPtr]::Zero; $i++) {
        Start-Sleep -Milliseconds 100
        $hungWindow = Find-Window $hungPutty.Id "PuTTY"
        if ($hungWindow -ne [IntPtr]::Zero) {
            $hungMetadata = [PuttyAiAutomation]::GetDlgItem($hungWindow, 0x7119)
        }
    }
    if ($hungMetadata -eq [IntPtr]::Zero) {
        throw "The suspended peer PuTTY session did not expose its session metadata control"
    }
    $hungProcessId = 0
    $hungThreadId = [PuttyAiAutomation]::GetWindowThreadProcessId(
        $hungWindow, [ref]$hungProcessId)
    $hungThread = [PuttyAiAutomation]::OpenThread(
        0x0002, $false, $hungThreadId)
    if ($hungThread -eq [IntPtr]::Zero -or
        [PuttyAiAutomation]::SuspendThread($hungThread) -eq [uint32]::MaxValue) {
        throw "Could not suspend the peer PuTTY UI thread for the activation regression"
    }
    Activate-TestWindow $otherWindow "the GUI peer" | Out-Null
    Start-Sleep -Milliseconds 100
    Activate-TestWindow $main2 "PuTTY" | Out-Null
    Assert-WindowResponsive $main2 "return while a peer PuTTY UI is suspended" 75
    $activationTimer = [Diagnostics.Stopwatch]::StartNew()
    [PuttyAiAutomation]::SendMessage(
        $main2, 0x0006, [IntPtr]1, [IntPtr]::Zero) | Out-Null
    $activationTimer.Stop()
    if ($activationTimer.ElapsedMilliseconds -ge 75) {
        throw "PuTTY activation spent $($activationTimer.ElapsedMilliseconds) ms querying a suspended peer"
    }
    [PuttyAiAutomation]::ResumeThread($hungThread) | Out-Null
    [PuttyAiAutomation]::CloseHandle($hungThread) | Out-Null
    $hungThread = [IntPtr]::Zero
    for ($i = 0; $i -lt 40; $i++) {
        Activate-TestWindow $main2 "PuTTY" | Out-Null
        Start-Sleep -Milliseconds 20
        Assert-WindowResponsive $main2 "switch $i to PuTTY" 1000
        Activate-TestWindow $otherWindow "the GUI peer" | Out-Null
        Start-Sleep -Milliseconds 20
        Assert-WindowResponsive $main2 "switch $i away from PuTTY" 1000
    }
    Activate-TestWindow $main2 "PuTTY" | Out-Null
    Assert-WindowResponsive $main2 "final return from another application"
    [PuttyAiAutomation]::SendMessageText(
        $prompt2, 0x000C, [IntPtr]::Zero,
        "Verify persisted settings") | Out-Null
    [PuttyAiAutomation]::SendMessage(
        $main2, 0x0111, [IntPtr]0x7105, $ask2) | Out-Null
    $persistedRequestOk = $false
    for ($i = 0; $i -lt 100; $i++) {
        Start-Sleep -Milliseconds 100
        if ((Get-WindowText $status2) -eq $completedStatus) {
            $persistedRequestOk = $true
            break
        }
    }
    if (-not $persistedRequestOk) {
        throw "Restored Chat Completions settings could not make a request: " +
            (Get-WindowText $status2)
    }
    if (-not (Test-Path $requestThreePath) -or
        -not (Test-Path $authorizationThreePath)) {
        throw "The request using restored Chat Completions settings was not captured"
    }
    $requestThree = Get-Content -Raw -Encoding UTF8 $requestThreePath |
        ConvertFrom-Json
    $authorizationThree = Get-Content -Raw -Encoding UTF8 $authorizationThreePath
    if ($requestThree.model -ne "persist-model" -or
        $authorizationThree -ne "Bearer persist-key") {
        throw "The next session did not use the persisted model and API key"
    }

    [PuttyAiAutomation]::PostMessage(
        $main2, 0x0111, [IntPtr]0x711F, $close2) | Out-Null
    $closeConfirmation = [IntPtr]::Zero
    for ($i = 0; $i -lt 30; $i++) {
        Start-Sleep -Milliseconds 100
        $closeConfirmation = Find-Window $putty2.Id "#32770"
        if ($closeConfirmation -ne [IntPtr]::Zero -or
            -not (Get-Process -Id $putty2.Id -ErrorAction SilentlyContinue)) {
            break
        }
    }
    if ($closeConfirmation -ne [IntPtr]::Zero) {
        [PuttyAiAutomation]::SendMessage(
            $closeConfirmation, 0x0111, [IntPtr]2, [IntPtr]::Zero) | Out-Null
    } elseif (Get-Process -Id $putty2.Id -ErrorAction SilentlyContinue) {
        throw "Global close button neither closed PuTTY nor opened confirmation"
    } else {
        $putty2 = $null
    }

    [pscustomobject]@{
        AiRequest = "passed"
        StreamingResponse = "passed"
        StreamingScroll = "stable"
        ContextDefault = "disabled"
        ChineseUi = "passed"
        TranscriptTextColor = "readable"
        ExpandedPanel = "passed"
        ContextSwitch = "visible toggle; disabled by default"
        ConversationHistory = "always retained; no user-facing option"
        StandaloneClear = "passed"
        WindowControls = "minimize, maximize/restore, and close across all sessions"
        InitialPlacement = "centred"
        GlobalHeader = "full-width"
        CompleteFrame = "all four sides"
        MessageSeparation = "user and AI labelled with separators"
        RoleHeaderTypography = "uniform"
        Screenshot = $(if ($ScreenshotPath) { $ScreenshotPath } else { "not requested" })
        BastionDirectLaunch = "@session, -load, -load tmp:file, and -raw -P passed"
        ConnectionKeepalive = "enabled"
        KnowledgeBaseRemoved = "passed"
        TerminalFocusRestore = "passed"
        ChinesePrompt = "passed"
        MultiTurnConversation = "passed"
        HostSessionTabs = "isolated and switchable"
        PersistentChatCompletions = "passed"
        ProtectedApiKey = "Windows DPAPI"
        SensitiveLaunchLogging = "disabled"
        MarkdownRender = "passed"
        CommandDetection = "passed"
        CommandHoverAction = "passed"
        Confirmation = "passed"
        TerminalFill = "passed"
        AutoEnter = "not sent"
        RiskFlow = $(if ($Dangerous) { "double-confirmed" } else { "normal" })
        Payload = $received
    } | Format-List
}
finally {
    if ($puttyTab -and (Get-Process -Id $puttyTab.Id -ErrorAction SilentlyContinue)) {
        Stop-Process -Id $puttyTab.Id -Force
    }
    if ($putty2 -and (Get-Process -Id $putty2.Id -ErrorAction SilentlyContinue)) {
        Stop-Process -Id $putty2.Id -Force
    }
    if ($putty -and (Get-Process -Id $putty.Id -ErrorAction SilentlyContinue)) {
        Stop-Process -Id $putty.Id -Force
    }
    if ($server -and (Get-Process -Id $server.Id -ErrorAction SilentlyContinue)) {
        Stop-Process -Id $server.Id -Force
    }
    if ($otherApp -and (Get-Process -Id $otherApp.Id -ErrorAction SilentlyContinue)) {
        Stop-Process -Id $otherApp.Id -Force
    }
    if ($hungThread -ne [IntPtr]::Zero) {
        [PuttyAiAutomation]::ResumeThread($hungThread) | Out-Null
        [PuttyAiAutomation]::CloseHandle($hungThread) | Out-Null
    }
    if ($hungPutty -and (Get-Process -Id $hungPutty.Id -ErrorAction SilentlyContinue)) {
        Stop-Process -Id $hungPutty.Id -Force
    }

    [Microsoft.Win32.Registry]::CurrentUser.DeleteSubKeyTree(
        $aiRegistryPath, $false)
    if ($aiRegistryExisted) {
        $restoredKey = [Microsoft.Win32.Registry]::CurrentUser.CreateSubKey(
            $aiRegistryPath)
        try {
            foreach ($entry in $aiRegistrySnapshot) {
                $restoredKey.SetValue($entry.Name, $entry.Value, $entry.Kind)
            }
        }
        finally {
            $restoredKey.Dispose()
        }
    }
    [Microsoft.Win32.Registry]::CurrentUser.DeleteSubKeyTree(
        $bastionSessionRegistryPath, $false)
    Remove-Item -LiteralPath $temporaryConfigPath -Force -ErrorAction SilentlyContinue
}
