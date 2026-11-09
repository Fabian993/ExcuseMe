import 'dart:html' show window;

String protocol() {
  return window.location.protocol == 'https:' ? 'https' : 'http';
}
