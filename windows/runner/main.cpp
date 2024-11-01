#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>

#include "flutter_window.h"
#include "utils.h"

// Function to set the window to full screen
void SetFullScreen(HWND hwnd) {
    // Get the current monitor info
    MONITORINFO monitorInfo;
    monitorInfo.cbSize = sizeof(monitorInfo);
    GetMonitorInfo(MonitorFromWindow(hwnd, MONITOR_DEFAULTTONEAREST), &monitorInfo);

    // Set the window style
    SetWindowLong(hwnd, GWL_STYLE, WS_POPUP);
    SetWindowPos(hwnd, HWND_TOP, monitorInfo.rcMonitor.left, monitorInfo.rcMonitor.top,
                 monitorInfo.rcMonitor.right - monitorInfo.rcMonitor.left,
                 monitorInfo.rcMonitor.bottom - monitorInfo.rcMonitor.top,
                 SWP_NOZORDER);
}

int APIENTRY wWinMain(_In_ HINSTANCE instance, _In_opt_ HINSTANCE prev,
        _In_ wchar_t *command_line, _In_ int show_command) {
// Attach to console when present (e.g., 'flutter run') or create a
// new console when running with a debugger.
if (!::AttachConsole(ATTACH_PARENT_PROCESS) && ::IsDebuggerPresent()) {
CreateAndAttachConsole();
}

// Initialize COM, so that it is available for use in the library and/or
// plugins.
::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);

flutter::DartProject project(L"data");

std::vector<std::string> command_line_arguments =
        GetCommandLineArguments();

project.set_dart_entrypoint_arguments(std::move(command_line_arguments));

FlutterWindow window(project);
Win32Window::Point origin(0, 0);  // Set origin to (0, 0) for full screen
Win32Window::Size size(1280, 720); // Default size; can be ignored in full-screen mode

// Create a window
if (!window.Create(L"jk_evnt_proj", origin, size)) {
return EXIT_FAILURE;
}

// Set the window to full screen
HWND hwnd = window.GetHandle();
SetFullScreen(hwnd);

window.SetQuitOnClose(true);

// Handle the message loop
::MSG msg;
while (::GetMessage(&msg, nullptr, 0, 0)) {
::TranslateMessage(&msg);
::DispatchMessage(&msg);
}

::CoUninitialize();
return EXIT_SUCCESS;
}
