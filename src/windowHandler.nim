import nimqml

QtObject:
  type WindowHandler* = ref object of QObject
    app*: QApplication
    engine*: QQmlApplicationEngine
  
  proc delete*(self: WindowHandler) =
    self.QObject.delete
  
  proc setup(self: WindowHandler) =
    self.QObject.setup
  
proc newWindowHandler*[T](app: QApplication, engine: QQmlApplicationEngine): T =
  new(result)
  result.app = app
  result.engine = engine
  result.setup()

proc loadWindow*[T](wndHandler: T, windowName: string): T {.discardable.} =
  let qWh = newQVariant(wndHandler)
  defer: qWh.delete
  
  wndHandler.engine.setRootContextProperty(windowName, qWh)
  
  let qUrl = newQUrl("qrc:///" & windowName & ".qml");
  defer: qUrl.delete
  wndHandler.engine.load(qUrl)