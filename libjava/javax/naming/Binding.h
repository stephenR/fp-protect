
// DO NOT EDIT THIS FILE - it is machine generated -*- c++ -*-

#ifndef __javax_naming_Binding__
#define __javax_naming_Binding__

#pragma interface

#include <javax/naming/NameClassPair.h>
extern "Java"
{
  namespace javax
  {
    namespace naming
    {
        class Binding;
    }
  }
}

class javax::naming::Binding : public ::javax::naming::NameClassPair
{

public:
  Binding(::java::lang::String *, ::java::lang::Object *);
  Binding(::java::lang::String *, ::java::lang::Object *, jboolean);
  Binding(::java::lang::String *, ::java::lang::String *, ::java::lang::Object *);
  Binding(::java::lang::String *, ::java::lang::String *, ::java::lang::Object *, jboolean);
  virtual ::java::lang::String * getClassName();
  virtual ::java::lang::Object * getObject();
  virtual void setObject(::java::lang::Object *);
  virtual ::java::lang::String * toString();
private:
  static const jlong serialVersionUID = 8839217842691845890LL;
  ::java::lang::Object * __attribute__((aligned(__alignof__( ::javax::naming::NameClassPair)))) boundObj;
public:
  static ::java::lang::Class class$;
};

#endif // __javax_naming_Binding__
