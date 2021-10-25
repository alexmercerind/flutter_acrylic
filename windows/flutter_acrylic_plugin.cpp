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

typedef BOOL(WINAPI* GetWindowCompositionAttribute)(
    HWND, WINDOWCOMPOSITIONATTRIBDATA*);
typedef BOOL(WINAPI* SetWindowCompositionAttribute)(
    HWND, WINDOWCOMPOSITIONATTRIBDATA*);

namespace {

static constexpr auto kChannelName = "com.alexmercerind/flutter_acrylic";
static constexpr auto kInitialize = "Initialize";
static constexpr auto kSetEffect = "SetEffect";
static constexpr auto kEnterFullscreen = "EnterFullscreen";
static constexpr auto kExitFullscreen = "ExitFullscreen";

class FlutterAcrylicPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows* registrar);
  FlutterAcrylicPlugin(flutter::PluginRegistrarWindows* registrar);
  virtual ~FlutterAcrylicPlugin();

 private:
  HMODULE user32 = nullptr;
  SetWindowCompositionAttribute set_window_composition_attribute_ = nullptr;
  flutter::PluginRegistrarWindows* registrar_ = nullptr;
  bool is_initialized_ = false;
  bool is_fullscreen_ = false;
  RECT last_rect_ = {};

  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue>& call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

void FlutterAcrylicPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows* registrar) {
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), kChannelName,
          &flutter::StandardMethodCodec::GetInstance());
  auto plugin = std::make_unique<FlutterAcrylicPlugin>(registrar);
  channel->SetMethodCallHandler([plugin_pointer = plugin.get()](
      const auto& call, auto result) {
    plugin_pointer->HandleMethodCall(call, std::move(result));
  });
  registrar->AddPlugin(std::move(plugin));
}

FlutterAcrylicPlugin::FlutterAcrylicPlugin(
    flutter::PluginRegistrarWindows* registrar)
    : registrar_(registrar) {}

FlutterAcrylicPlugin::~FlutterAcrylicPlugin() {}

void FlutterAcrylicPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue>& call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (call.method_name() == kInitialize) {
    flutter::EncodableMap arguments =
        std::get<flutter::EncodableMap>(*call.arguments());
    bool draw_custom_frame =
        std::get<bool>(arguments[flutter::EncodableValue("drawCustomFrame")]);
    if (!is_initialized_) {
      user32 = GetModuleHandleA("user32.dll");
      if (user32) {
        set_window_composition_attribute_ =
            reinterpret_cast<SetWindowCompositionAttribute>(
                GetProcAddress(user32, "SetWindowCompositionAttribute"));
        if (set_window_composition_attribute_) {
          if (draw_custom_frame) {
            HWND window =
                GetAncestor(registrar_->GetView()->GetNativeWindow(), GA_ROOT);
            RECT rect;
            GetWindowRect(window, &rect);
            SetWindowLong(window, GWL_STYLE,
                          WS_POPUP | WS_CAPTION | WS_VISIBLE);
            MARGINS margins = {0, 0, 1, 0};
            DwmExtendFrameIntoClientArea(window, &margins);
            SetWindowPos(window, nullptr, rect.left, rect.top,
                         rect.right - rect.left, rect.bottom - rect.top,
                         SWP_NOZORDER | SWP_NOOWNERZORDER | SWP_NOMOVE |
                             SWP_NOSIZE | SWP_FRAMECHANGED);
          }
          is_initialized_ = true;
          result->Success();
        } else
          result->Error("-2", "FAIL_LOAD_METHOD");
      } else
        result->Error("-1", "FAIL_LOAD_DLL");
    } else
      result->Success();
  } else if (call.method_name() == kSetEffect) {
    flutter::EncodableMap arguments =
        std::get<flutter::EncodableMap>(*call.arguments());
    int32_t effect =
        std::get<int32_t>(arguments[flutter::EncodableValue("effect")]);
    flutter::EncodableMap gradient_color = std::get<flutter::EncodableMap>(
        arguments[flutter::EncodableValue("gradientColor")]);
    ACCENT_POLICY accent = {
        static_cast<ACCENT_STATE>(effect), 2,
        static_cast<DWORD>(
            (std::get<int>(gradient_color[flutter::EncodableValue("A")])
             << 24) +
            (std::get<int>(gradient_color[flutter::EncodableValue("B")])
             << 16) +
            (std::get<int>(gradient_color[flutter::EncodableValue("G")]) << 8) +
            (std::get<int>(gradient_color[flutter::EncodableValue("R")]))),
        0};
    WINDOWCOMPOSITIONATTRIBDATA data;
    data.Attrib = WCA_ACCENT_POLICY;
    data.pvData = &accent;
    data.cbData = sizeof(accent);
    set_window_composition_attribute_(
        GetAncestor(registrar_->GetView()->GetNativeWindow(), GA_ROOT), &data);
    result->Success();
  } else if (call.method_name() == kEnterFullscreen) {
    if (!is_fullscreen_) {
      is_fullscreen_ = true;
      HWND window =
          GetAncestor(registrar_->GetView()->GetNativeWindow(), GA_ROOT);
      HMONITOR monitor = ::MonitorFromWindow(window, MONITOR_DEFAULTTONEAREST);
      MONITORINFO info;
      info.cbSize = sizeof(MONITORINFO);
      GetMonitorInfo(monitor, &info);
      SetWindowLongPtr(window, GWL_STYLE, WS_POPUP | WS_VISIBLE);
      GetWindowRect(window, &last_rect_);
      SetWindowPos(window, HWND_TOPMOST, info.rcMonitor.left,
                   info.rcMonitor.top,
                   info.rcMonitor.right - info.rcMonitor.left,
                   info.rcMonitor.bottom - info.rcMonitor.top, SWP_SHOWWINDOW);
      ShowWindow(window, SW_MAXIMIZE);
    }
    result->Success();
  } else if (call.method_name() == kExitFullscreen) {
    if (is_fullscreen_) {
      is_fullscreen_ = false;
      HWND window =
          GetAncestor(registrar_->GetView()->GetNativeWindow(), GA_ROOT);
      SetWindowLongPtr(window, GWL_STYLE, WS_OVERLAPPEDWINDOW | WS_VISIBLE);
      SetWindowPos(window, HWND_NOTOPMOST, last_rect_.left, last_rect_.top,
                   last_rect_.right - last_rect_.left,
                   last_rect_.bottom - last_rect_.top, SWP_SHOWWINDOW);
      ShowWindow(window, SW_RESTORE);
    }
  } else
    result->NotImplemented();
}
}

void FlutterAcrylicPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  FlutterAcrylicPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
