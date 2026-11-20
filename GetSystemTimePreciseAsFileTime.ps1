if (-not ('PreciseSystemTime' -as [type])) {
    Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;

public static class PreciseSystemTime
{
    [StructLayout(LayoutKind.Sequential)]
    private struct FILETIME
    {
        public uint LowDateTime;
        public uint HighDateTime;
    }

    [DllImport("kernel32.dll", ExactSpelling = true)]
    private static extern void GetSystemTimePreciseAsFileTime(out FILETIME fileTime);

    public static long GetFileTimeTicks()
    {
        FILETIME ft;
        GetSystemTimePreciseAsFileTime(out ft);
        return ((long)ft.HighDateTime << 32) | ft.LowDateTime;
    }
}
'@
}

$ticks = [PreciseSystemTime]::GetFileTimeTicks()

$ticks
