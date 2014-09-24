part of fishbone;

class Controller {
  Controller() {}

  void render(String action){
    var views = js.context['views'];
    String renderedHtml = views.callMethod("${getControllerAbbrName()}_$action");

    html.HtmlElement controllerElement = new html.Element.tag('controller');
    controllerElement.appendHtml(renderedHtml);
    html.document.body.children.add(controllerElement);
  }

  String getControllerFullName(){
    // as 'MainController', 'UsersController'
    InstanceMirror instanceMirror = mirrors.reflect(this);
    ClassMirror classMirror = instanceMirror.type; 
    return mirrors.MirrorSystem.getName(classMirror.simpleName);
  }
  
  String getControllerAbbrName(){
    // as 'main', 'users'
    return getControllerFullName().replaceAll('Controller', '').toLowerCase();
  }

  // TODO simulate a function class as action
  // https://www.dartlang.org/articles/emulating-functions/

  // void getCurrentActionName(){
  //   as 'show', 'edit'
  //   http://stackoverflow.com/questions/17741543/how-do-i-get-a-methodmirror-for-the-current-function
  //   https://code.google.com/p/dart/issues/detail?id=11916&thanks=11916&ts=1374225632
  // }
}
