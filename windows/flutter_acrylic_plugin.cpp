#include <thread>

#include <dwmapi.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include "include/flutter_acrylic/flutter_acrylic_plugin.h"

#pragma comment(lib, "dwmapi.lib")
#pragma comment(lib, "comctl32.lib")

typedef enum _WINDOWCOMPOSITIONATTRIB {
	WCA_UNDEFINED = 0,
	WCA_NCRENDERING_ENABLED = 1,
	WCA_NCRENDERING_POLICY = 2,
	WCA_TRANSITIONS_FORCEDISABLED = 3,
	WCA_ALLOW_NCPAINT = 4,
	WCA_CAPTION_BUTTON_BOUNDS = 5,
	WCA_NONCLIENT_RTL_LAYOUT = 6,
	WCA_FORCE_ICONIC_REPRESENTATION = 7,
	WCA_EXTENDED_FRAME_BOUNDS = 8,
	WCA_HAS_ICONIC_BITMAP = 9,
	WCA_THEME_ATTRIBUTES = 10,
	WCA_NCRENDERING_EXILED = 11,
	WCA_NCADORNMENTINFO = 12,
	WCA_EXCLUDED_FROM_LIVEPREVIEW = 13,
	WCA_VIDEO_OVERLAY_ACTIVE = 14,
	WCA_FORCE_ACTIVEWINDOW_APPEARANCE = 15,
	WCA_DISALLOW_PEEK = 16,
	WCA_CLOAK = 17,
	WCA_CLOAKED = 18,
	WCA_ACCENT_POLICY = 19,
	WCA_FREEZE_REPRESENTATION = 20,
	WCA_EVER_UNCLOAKED = 21,
	WCA_VISUAL_OWNER = 22,
	WCA_HOLOGRAPHIC = 23,
	WCA_EXCLUDED_FROM_DDA = 24,
	WCA_PASSIVEUPDATEMODE = 25,
	WCA_USEDARKMODECOLORS = 26,
	WCA_LAST = 27
} WINDOWCOMPOSITIONATTRIB;

typedef struct _WINDOWCOMPOSITIONATTRIBDATA {
	WINDOWCOMPOSITIONATTRIB Attrib;
	PVOID pvData;
	SIZE_T cbData;
} WINDOWCOMPOSITIONATTRIBDATA;

typedef enum _ACCENT_STATE {
	ACCENT_DISABLED = 0,
	ACCENT_ENABLE_GRADIENT = 1,
	ACCENT_ENABLE_TRANSPARENTGRADIENT = 2,
	ACCENT_ENABLE_BLURBEHIND = 3,
	ACCENT_ENABLE_ACRYLICBLURBEHIND = 4,
	ACCENT_ENABLE_HOSTBACKDROP = 5,
 	ACCENT_INVALID_STATE = 6
} ACCENT_STATE;

typedef struct _ACCENT_POLICY {
	ACCENT_STATE AccentState;
	DWORD AccentFlags;
	DWORD GradientColor;
	DWORD AnimationId;
} ACCENT_POLICY;

typedef BOOL (WINAPI *GetWindowCompositionAttribute)(HWND, WINDOWCOMPOSITIONATTRIBDATA*);
typedef BOOL (WINAPI *SetWindowCompositionAttribute)(HWND, WINDOWCOMPOSITIONATTRIBDATA*);


namespace {

static bool isInitialized;
static bool isFullscreen;
static RECT initialRect;

LRESULT wndProc(HWND hwnd, UINT const message, WPARAM const wparam, LPARAM const lparam, UINT_PTR uIdSubclass, DWORD_PTR dwRefData) {
  switch(message) {
    case WM_NCCALCSIZE: {
      if (wparam) {
        SetWindowLong(hwnd, 0, 0); 
        return 1;
      }
      return 0;
    }
    case WM_NCHITTEST: {
      LONG width = 10;
      POINT mouse = { LOWORD(lparam), HIWORD(lparam) };
      RECT window;
      GetWindowRect(hwnd, &window);
      RECT rcFrame = { 0 };
      AdjustWindowRectEx(&rcFrame, WS_OVERLAPPEDWINDOW & ~WS_CAPTION, FALSE, NULL);
      USHORT x = 1;
      USHORT y = 1;
      bool fOnResizeBorder = false;
      if (mouse.y >= window.top && mouse.y < window.top + width) x = 0;
      else if (mouse.y < window.bottom && mouse.y >= window.bottom - width) x = 2;
      if (mouse.x >= window.left && mouse.x < window.left + width) y = 0;
      else if (mouse.x < window.right && mouse.x >= window.right - width) y = 2;
      LRESULT hitTests[3][3] =  {
        { HTTOPLEFT   , fOnResizeBorder ? HTTOP : HTCAPTION, HTTOPRIGHT },
        { HTLEFT      , HTNOWHERE                          , HTRIGHT },
        { HTBOTTOMLEFT, HTBOTTOM                           , HTBOTTOMRIGHT },
      };
      return hitTests[x][y];
    }
  }
  return DefSubclassProc(hwnd, message, wparam, lparam);
}


class FlutterAcrylicPlugin : public flutter::Plugin {
public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows* registrar);
  FlutterAcrylicPlugin(flutter::PluginRegistrarWindows* registrar);
  virtual ~FlutterAcrylicPlugin();

private:
  HMODULE user32 = nullptr;
  SetWindowCompositionAttribute setWindowCompositionAttribute = nullptr;
  flutter::PluginRegistrarWindows* registrar = nullptr;

  void HandleMethodCall(const flutter::MethodCall<flutter::EncodableValue> &call, std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};


void FlutterAcrylicPlugin::RegisterWithRegistrar(flutter::PluginRegistrarWindows* registrar) {
  auto channel = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
    registrar->messenger(),
    "flutter_acrylic",
    &flutter::StandardMethodCodec::GetInstance()
 );
  auto plugin = std::make_unique<FlutterAcrylicPlugin>(registrar);
  channel->SetMethodCallHandler(
    [plugin_pointer = plugin.get()](const auto &call, auto result) {
      plugin_pointer->HandleMethodCall(call, std::move(result));
    }
 );
  registrar->AddPlugin(std::move(plugin));
}

FlutterAcrylicPlugin::FlutterAcrylicPlugin(flutter::PluginRegistrarWindows* registrar): registrar(registrar) {}

FlutterAcrylicPlugin::~FlutterAcrylicPlugin() {}

void FlutterAcrylicPlugin::HandleMethodCall(const flutter::MethodCall<flutter::EncodableValue> &call, std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (call.method_name() == "Acrylic.initialize") {
    flutter::EncodableMap arguments = std::get<flutter::EncodableMap>(*call.arguments());
    bool drawCustomFrame = std::get<bool>(arguments[flutter::EncodableValue("drawCustomFrame")]);
    if (!isInitialized) {
      this->user32 = GetModuleHandleA("user32.dll");
      if (this->user32) {
        this->setWindowCompositionAttribute = reinterpret_cast<SetWindowCompositionAttribute>(GetProcAddress(this->user32, "SetWindowCompositionAttribute"));
        if (this->setWindowCompositionAttribute) {
          if (drawCustomFrame) {
            SetWindowSubclass(GetAncestor(this->registrar->GetView()->GetNativeWindow(), GA_ROOT), &wndProc, 1, 0);
            RECT rect;
            GetWindowRect(GetAncestor(this->registrar->GetView()->GetNativeWindow(), GA_ROOT), &rect);
            SetWindowLong(
              GetAncestor(this->registrar->GetView()->GetNativeWindow(), GA_ROOT),
              GWL_STYLE, WS_POPUP | WS_CAPTION | WS_VISIBLE
            );
            MARGINS margins = { 0, 0, 1, 0 };
            DwmExtendFrameIntoClientArea(GetAncestor(this->registrar->GetView()->GetNativeWindow(), GA_ROOT), &margins);
            SetWindowPos(
              GetAncestor(this->registrar->GetView()->GetNativeWindow(), GA_ROOT),
              nullptr,
              rect.left, rect.top, rect.right - rect.left, rect.bottom - rect.top, SWP_NOZORDER | SWP_NOOWNERZORDER | SWP_NOMOVE | SWP_NOSIZE | SWP_FRAMECHANGED
            );
          }
          isInitialized = true;
          result->Success();
        }
        else result->Error("-2", "FAIL_LOAD_METHOD");
      }
      else result->Error("-1", "FAIL_LOAD_DLL");
    }
    else result->Success();
  }
  else if (call.method_name() == "Acrylic.setEffect") {
    flutter::EncodableMap arguments = std::get<flutter::EncodableMap>(*call.arguments());
    int32_t effect = std::get<int32_t>(arguments[flutter::EncodableValue("effect")]);
    flutter::EncodableMap gradientColor = std::get<flutter::EncodableMap>(arguments[flutter::EncodableValue("gradientColor")]);
    ACCENT_POLICY accent = {
      static_cast<ACCENT_STATE>(effect),
      2,
      static_cast<DWORD>(
        (std::get<int>(gradientColor[flutter::EncodableValue("A")]) << 24) +
        (std::get<int>(gradientColor[flutter::EncodableValue("B")]) << 16) +
        (std::get<int>(gradientColor[flutter::EncodableValue("G")]) << 8) +
        (std::get<int>(gradientColor[flutter::EncodableValue("R")]))),
      0
    };
    WINDOWCOMPOSITIONATTRIBDATA data;
    data.Attrib = WCA_ACCENT_POLICY;
    data.pvData = &accent;
    data.cbData = sizeof(accent);
    this->setWindowCompositionAttribute(
      GetAncestor(this->registrar->GetView()->GetNativeWindow(), GA_ROOT),
      &data
   );
    result->Success();
  }
  else if (call.method_name() == "Window.enterFullscreen") {
    if (!isFullscreen) {
      isFullscreen = true;
      HWND window = GetAncestor(this->registrar->GetView()->GetNativeWindow(), GA_ROOT);
      HMONITOR monitor = ::MonitorFromWindow(window, MONITOR_DEFAULTTONEAREST);
      MONITORINFO info;
      info.cbSize = sizeof(MONITORINFO);
      GetMonitorInfo(monitor, &info);
      SetWindowLongPtr(window, GWL_STYLE, WS_POPUP | WS_VISIBLE);
      GetWindowRect(window, &initialRect);
      SetWindowPos(
        window, HWND_TOPMOST,
        info.rcMonitor.left, info.rcMonitor.top,
        info.rcMonitor.right - info.rcMonitor.left,
        info.rcMonitor.bottom - info.rcMonitor.top,
        SWP_SHOWWINDOW
      );
      ShowWindow(window, SW_MAXIMIZE);
    }
    result->Success();
  } else if (call.method_name() == "Window.exitFullscreen") {
    if (isFullscreen) {
      isFullscreen = false;
      HWND window = GetAncestor(this->registrar->GetView()->GetNativeWindow(), GA_ROOT);
      SetWindowLongPtr(window, GWL_STYLE, WS_OVERLAPPEDWINDOW | WS_VISIBLE);
      SetWindowPos(
        window, HWND_NOTOPMOST,
        initialRect.left, initialRect.top,
        initialRect.right - initialRect.left,
        initialRect.bottom - initialRect.top,
        SWP_SHOWWINDOW
      );
      ShowWindow(window, SW_RESTORE);
    }
  }
  else result->NotImplemented();
}

}

void FlutterAcrylicPluginRegisterWithRegistrar(FlutterDesktopPluginRegistrarRef registrar) {
  FlutterAcrylicPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarManager::GetInstance()->GetRegistrar<flutter::PluginRegistrarWindows>(registrar)
  );
}
