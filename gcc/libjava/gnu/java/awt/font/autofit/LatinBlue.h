
// DO NOT EDIT THIS FILE - it is machine generated -*- c++ -*-

#ifndef __gnu_java_awt_font_autofit_LatinBlue__
#define __gnu_java_awt_font_autofit_LatinBlue__

#pragma interface

#include <java/lang/Object.h>
extern "Java"
{
  namespace gnu
  {
    namespace java
    {
      namespace awt
      {
        namespace font
        {
          namespace autofit
          {
              class LatinBlue;
              class Width;
          }
        }
      }
    }
  }
}

class gnu::java::awt::font::autofit::LatinBlue : public ::java::lang::Object
{

public:
  LatinBlue();
  virtual ::java::lang::String * toString();
public: // actually package-private
  static const jint FLAG_BLUE_ACTIVE = 1;
  static const jint FLAG_TOP = 2;
  static const jint FLAG_ADJUSTMENT = 4;
  ::gnu::java::awt::font::autofit::Width * __attribute__((aligned(__alignof__( ::java::lang::Object)))) ref;
  ::gnu::java::awt::font::autofit::Width * shoot;
  jint flags;
public:
  static ::java::lang::Class class$;
};

#endif // __gnu_java_awt_font_autofit_LatinBlue__
