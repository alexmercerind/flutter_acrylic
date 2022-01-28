#include "include/flutter_acrylic/flutter_acrylic_plugin.h"

#include <flutter_linux/flutter_linux.h>

#include <cstring>

#define FLUTTER_ACRYLIC_PLUGIN(obj)                                     \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), flutter_acrylic_plugin_get_type(), \
                              FlutterAcrylicPlugin))

#include <gtk/gtk.h>
#include <cairo/cairo.h>

struct _FlutterAcrylicPlugin {
  GObject parent_instance;
};

static double R = 0.0, G = 0.0, B = 0.0, A = 0.0;
static bool g_is_window_fullscreen = false;
static FlPluginRegistrar* g_registrar = nullptr;

G_DEFINE_TYPE(FlutterAcrylicPlugin, flutter_acrylic_plugin, g_object_get_type())

gboolean DrawCallback(GtkWidget* widget, cairo_t* cr, gpointer data) {
  cairo_save(cr);
  cairo_set_source_rgba(cr, R, G, B, A);
  cairo_set_operator(cr, CAIRO_OPERATOR_SOURCE);
  cairo_paint(cr);
  cairo_restore(cr);
  return FALSE;
}

static void flutter_acrylic_plugin_handle_method_call(
    FlutterAcrylicPlugin* self, FlMethodCall* method_call) {
  g_autoptr(FlMethodResponse) response = nullptr;
  const gchar* method = fl_method_call_get_name(method_call);
  if (strcmp(method, "Initialize") == 0) {
    /* Not required for Linux. */
    response = FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
  } else if (strcmp(method, "SetEffect") == 0) {
    FlView* view = fl_plugin_registrar_get_view(g_registrar);
    GtkWindow* window = GTK_WINDOW(gtk_widget_get_toplevel(GTK_WIDGET(view)));
    gtk_widget_hide(GTK_WIDGET(window));
    gtk_widget_hide(GTK_WIDGET(view));
    auto arguments = fl_method_call_get_args(method_call);
    int effect = fl_value_get_int(fl_value_lookup_string(arguments, "effect"));
    auto color = fl_value_lookup_string(arguments, "color");
    if (effect == 0) {
      R = 1.0;
      G = 1.0;
      B = 1.0;
      A = 1.0;
      response = FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
    } else if (effect == 1) {
      R = ((double)fl_value_get_int(fl_value_lookup_string(color, "R")) /
           255.0);
      G = ((double)fl_value_get_int(fl_value_lookup_string(color, "G")) /
           255.0);
      B = ((double)fl_value_get_int(fl_value_lookup_string(color, "B")) /
           255.0);
      A = 1.0;
      response = FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
    } else if (effect == 2) {
      R = ((double)fl_value_get_int(fl_value_lookup_string(color, "R")) /
           255.0);
      G = ((double)fl_value_get_int(fl_value_lookup_string(color, "G")) /
           255.0);
      B = ((double)fl_value_get_int(fl_value_lookup_string(color, "B")) /
           255.0);
      A = ((double)fl_value_get_int(fl_value_lookup_string(color, "A")) /
           255.0);
      response = FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
    } else {
      response = FL_METHOD_RESPONSE(fl_method_error_response_new(
          "-1", "NOT_SUPPORTED_ON_LINUX",
          fl_value_new_string(
              "Only AcrylicEffect.disabled, AcrylicEffect.solid & "
              "AcrylicEffect.transparent works on Linux.")));
    }
    gtk_widget_show(GTK_WIDGET(window));
    gtk_widget_show(GTK_WIDGET(view));
  } else if (strcmp(method, "EnterFullscreen") == 0) {
    if (!g_is_window_fullscreen) {
      g_is_window_fullscreen = true;
      FlView* view = fl_plugin_registrar_get_view(g_registrar);
      GtkWindow* window = GTK_WINDOW(gtk_widget_get_toplevel(GTK_WIDGET(view)));
      gtk_window_fullscreen(GTK_WINDOW(window));
    }
    response = FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
  } else if (strcmp(method, "ExitFullscreen") == 0) {
    if (g_is_window_fullscreen) {
      g_is_window_fullscreen = false;
      FlView* view = fl_plugin_registrar_get_view(g_registrar);
      GtkWindow* window = GTK_WINDOW(gtk_widget_get_toplevel(GTK_WIDGET(view)));
      gtk_window_unfullscreen(GTK_WINDOW(window));
    }
    response = FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
  } else {
    response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  }
  fl_method_call_respond(method_call, response, nullptr);
}

static void flutter_acrylic_plugin_dispose(GObject* object) {
  G_OBJECT_CLASS(flutter_acrylic_plugin_parent_class)->dispose(object);
}

static void flutter_acrylic_plugin_class_init(
    FlutterAcrylicPluginClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = flutter_acrylic_plugin_dispose;
}

static void flutter_acrylic_plugin_init(FlutterAcrylicPlugin* self) {}

static void method_call_cb(FlMethodChannel* channel, FlMethodCall* method_call,
                           gpointer user_data) {
  FlutterAcrylicPlugin* plugin = FLUTTER_ACRYLIC_PLUGIN(user_data);
  flutter_acrylic_plugin_handle_method_call(plugin, method_call);
}

void flutter_acrylic_plugin_register_with_registrar(
    FlPluginRegistrar* registrar) {
  FlutterAcrylicPlugin* plugin = FLUTTER_ACRYLIC_PLUGIN(
      g_object_new(flutter_acrylic_plugin_get_type(), nullptr));
  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  g_autoptr(FlMethodChannel) channel = fl_method_channel_new(
      fl_plugin_registrar_get_messenger(registrar),
      "com.alexmercerind/flutter_acrylic", FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(
      channel, method_call_cb, g_object_ref(plugin), g_object_unref);
  FlView* view = fl_plugin_registrar_get_view(registrar);
  GtkWindow* window = GTK_WINDOW(gtk_widget_get_toplevel(GTK_WIDGET(view)));
  GdkScreen* screen;
  GdkVisual* visual;
  gtk_widget_set_app_paintable(GTK_WIDGET(window), TRUE);
  screen = gdk_screen_get_default();
  visual = gdk_screen_get_rgba_visual(screen);
  if (visual != NULL && gdk_screen_is_composited(screen)) {
    gtk_widget_set_visual(GTK_WIDGET(window), visual);
  }
  g_signal_connect(G_OBJECT(window), "draw", G_CALLBACK(DrawCallback), NULL);
  gtk_widget_show(GTK_WIDGET(window));
  gtk_widget_show(GTK_WIDGET(view));
  g_registrar = FL_PLUGIN_REGISTRAR(g_object_ref(registrar));
  g_object_unref(plugin);
}
