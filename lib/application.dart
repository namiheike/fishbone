part of fishbone;

class Application {
  html.Element container;
  String title;
  var controllers = {};
  var routes = {};
  var params = {};
  String currentPath;

  Application() {
  }

  void init(){
    // handle routes
    // TODO BUG handle if directly input an url with hash
    // TODO figure out if need to handle the title in this history management module
    html.window.onHashChange.listen((e){ navigated('onHashChange'); });
    html.window.onPopState.listen((e){ navigated('onPopState'); });
    if (html.window.location.hash == ''){
      html.window.history.replaceState('', title, "#/");
    }
    navigated();
  }

  void navigate(String path){
    print("navigate with path: $path");
    if (path == null) { path = ''; }
    if (path == currentPath) { return; }

    html.window.history.pushState(path, null, "#/$path");
    navigated('navigate');
  }

  void navigated([source]){
    print('navigated called by $source');
    // validate
    // TODO throw exception
    if (html.window.location.hash == '' || !html.window.location.hash.startsWith('#/')) {
      print('invalid path');
      currentPath = null;
      return;
    }

    String path = html.window.location.hash.replaceFirst('#/', '');
    if (path == currentPath) { return; }

    // get params
    // match routes
    // TODO regexp
    // TODO throw exception or redirect 404
    if (!routes.containsKey(path)) {
      print('no such route');
      currentPath = null;
      return;
    }
    var controller = controllers[routes[path].split('#').first];
    var action = routes[path].split('#').last;

    // distribute to controllers
    print("distributing to $controller#$action");
    var mirror = mirrors.reflect(controller);
    mirror.invoke(new Symbol(action), []);

    currentPath = path;
  }
}
