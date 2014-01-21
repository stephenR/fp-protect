
// DO NOT EDIT THIS FILE - it is machine generated -*- c++ -*-

#ifndef __javax_swing_UIDefaults__
#define __javax_swing_UIDefaults__

#pragma interface

#include <java/util/Hashtable.h>
#include <gcj/array.h>

extern "Java"
{
  namespace java
  {
    namespace awt
    {
        class Color;
        class Dimension;
        class Font;
        class Insets;
    }
    namespace beans
    {
        class PropertyChangeListener;
        class PropertyChangeSupport;
    }
  }
  namespace javax
  {
    namespace swing
    {
        class Icon;
        class JComponent;
        class UIDefaults;
      namespace border
      {
          class Border;
      }
      namespace plaf
      {
          class ComponentUI;
      }
    }
  }
}

class javax::swing::UIDefaults : public ::java::util::Hashtable
{

public:
  UIDefaults();
  UIDefaults(JArray< ::java::lang::Object * > *);
  virtual ::java::lang::Object * get(::java::lang::Object *);
  virtual ::java::lang::Object * get(::java::lang::Object *, ::java::util::Locale *);
  virtual ::java::lang::Object * put(::java::lang::Object *, ::java::lang::Object *);
  virtual void putDefaults(JArray< ::java::lang::Object * > *);
private:
  ::java::lang::Object * checkAndPut(::java::lang::Object *, ::java::lang::Object *);
public:
  virtual ::java::awt::Font * getFont(::java::lang::Object *);
  virtual ::java::awt::Font * getFont(::java::lang::Object *, ::java::util::Locale *);
  virtual ::java::awt::Color * getColor(::java::lang::Object *);
  virtual ::java::awt::Color * getColor(::java::lang::Object *, ::java::util::Locale *);
  virtual ::javax::swing::Icon * getIcon(::java::lang::Object *);
  virtual ::javax::swing::Icon * getIcon(::java::lang::Object *, ::java::util::Locale *);
  virtual ::javax::swing::border::Border * getBorder(::java::lang::Object *);
  virtual ::javax::swing::border::Border * getBorder(::java::lang::Object *, ::java::util::Locale *);
  virtual ::java::lang::String * getString(::java::lang::Object *);
  virtual ::java::lang::String * getString(::java::lang::Object *, ::java::util::Locale *);
  virtual jint getInt(::java::lang::Object *);
  virtual jint getInt(::java::lang::Object *, ::java::util::Locale *);
  virtual jboolean getBoolean(::java::lang::Object *);
  virtual jboolean getBoolean(::java::lang::Object *, ::java::util::Locale *);
  virtual ::java::awt::Insets * getInsets(::java::lang::Object *);
  virtual ::java::awt::Insets * getInsets(::java::lang::Object *, ::java::util::Locale *);
  virtual ::java::awt::Dimension * getDimension(::java::lang::Object *);
  virtual ::java::awt::Dimension * getDimension(::java::lang::Object *, ::java::util::Locale *);
  virtual ::java::lang::Class * getUIClass(::java::lang::String *, ::java::lang::ClassLoader *);
  virtual ::java::lang::Class * getUIClass(::java::lang::String *);
public: // actually protected
  virtual void getUIError(::java::lang::String *);
public:
  virtual ::javax::swing::plaf::ComponentUI * getUI(::javax::swing::JComponent *);
  virtual void addPropertyChangeListener(::java::beans::PropertyChangeListener *);
  virtual void removePropertyChangeListener(::java::beans::PropertyChangeListener *);
  virtual JArray< ::java::beans::PropertyChangeListener * > * getPropertyChangeListeners();
public: // actually protected
  virtual void firePropertyChange(::java::lang::String *, ::java::lang::Object *, ::java::lang::Object *);
public:
  virtual void addResourceBundle(::java::lang::String *);
  virtual void removeResourceBundle(::java::lang::String *);
  virtual void setDefaultLocale(::java::util::Locale *);
  virtual ::java::util::Locale * getDefaultLocale();
private:
  ::java::util::LinkedList * __attribute__((aligned(__alignof__( ::java::util::Hashtable)))) bundles;
  ::java::util::Locale * defaultLocale;
  ::java::beans::PropertyChangeSupport * propertyChangeSupport;
  static const jlong serialVersionUID = 7341222528856548117LL;
public:
  static ::java::lang::Class class$;
};

#endif // __javax_swing_UIDefaults__
