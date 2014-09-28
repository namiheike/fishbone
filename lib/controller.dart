part of fishbone;

class Controller {
  Controller() {}

  void render(String action, {Map locals}){
    var views = js.context['Fishbone']['views'];
    String renderedHtml = views[getCurrentControllerAbbrName()].callMethod(action, [new js.JsObject.jsify(locals)]);

    html.HtmlElement controllerElement = new html.Element.tag('controller');
    controllerElement.id = getCurrentControllerAbbrName();

    html.HtmlElement actionElement = new html.Element.tag('action');
    actionElement.id = action;

    actionElement.appendHtml(renderedHtml);
    controllerElement.append(actionElement);
    html.document.body.children.add(controllerElement);
  }

  String getCurrentControllerFullName(){
    // as 'MainController', 'UsersController'
    InstanceMirror instanceMirror = mirrors.reflect(this);
    ClassMirror classMirror = instanceMirror.type;
    return mirrors.MirrorSystem.getName(classMirror.simpleName);
  }

  String getCurrentControllerAbbrName(){
    // as 'main', 'users'
    return getCurrentControllerFullName().replaceAll('Controller', '').toLowerCase();
  }

  // TODO simulate a function class as action
  // https://www.dartlang.org/articles/emulating-functions/

  // void getCurrentActionName(){
  //   as 'show', 'edit'
  //   http://stackoverflow.com/questions/17741543/how-do-i-get-a-methodmirror-for-the-current-function
  //   https://code.google.com/p/dart/issues/detail?id=11916&thanks=11916&ts=1374225632
  // }
}
