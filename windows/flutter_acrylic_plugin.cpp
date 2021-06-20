#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include "include/flutter_acrylic/flutter_acrylic_plugin.h"


namespace {


class FlutterAcrylicPlugin : public flutter::Plugin {
  public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);
  FlutterAcrylicPlugin();
  virtual ~FlutterAcrylicPlugin();

  private:
  void HandleMethodCall(const flutter::MethodCall<flutter::EncodableValue> &method_call, std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};


  void FlutterAcrylicPlugin::RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar) {
    auto channel = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
      registrar->messenger(),
      "flutter_acrylic",
      &flutter::StandardMethodCodec::GetInstance()
    );
    auto plugin = std::make_unique<FlutterAcrylicPlugin>();
    channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto &call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      }
    );
    registrar->AddPlugin(std::move(plugin));
  }

  FlutterAcrylicPlugin::FlutterAcrylicPlugin() {}

  FlutterAcrylicPlugin::~FlutterAcrylicPlugin() {}

  void FlutterAcrylicPlugin::HandleMethodCall(const flutter::MethodCall<flutter::EncodableValue> &method_call, std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
    result->NotImplemented();
  }

}

void FlutterAcrylicPluginRegisterWithRegistrar(FlutterDesktopPluginRegistrarRef registrar) {
  FlutterAcrylicPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarManager::GetInstance()->GetRegistrar<flutter::PluginRegistrarWindows>(registrar)
  );
}
