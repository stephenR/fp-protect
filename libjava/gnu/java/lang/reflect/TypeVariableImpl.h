
// DO NOT EDIT THIS FILE - it is machine generated -*- c++ -*-

#ifndef __gnu_java_lang_reflect_TypeVariableImpl__
#define __gnu_java_lang_reflect_TypeVariableImpl__

#pragma interface

#include <gnu/java/lang/reflect/TypeImpl.h>
#include <gcj/array.h>

extern "Java"
{
  namespace gnu
  {
    namespace java
    {
      namespace lang
      {
        namespace reflect
        {
            class TypeVariableImpl;
        }
      }
    }
  }
}

class gnu::java::lang::reflect::TypeVariableImpl : public ::gnu::java::lang::reflect::TypeImpl
{

public: // actually package-private
  TypeVariableImpl(::java::lang::reflect::GenericDeclaration *, JArray< ::java::lang::reflect::Type * > *, ::java::lang::String *);
  ::java::lang::reflect::Type * resolve();
public:
  JArray< ::java::lang::reflect::Type * > * getBounds();
  ::java::lang::reflect::GenericDeclaration * getGenericDeclaration();
  ::java::lang::String * getName();
  jboolean equals(::java::lang::Object *);
  jint hashCode();
  ::java::lang::String * toString();
private:
  ::java::lang::reflect::GenericDeclaration * __attribute__((aligned(__alignof__( ::gnu::java::lang::reflect::TypeImpl)))) decl;
  JArray< ::java::lang::reflect::Type * > * bounds;
  ::java::lang::String * name;
public:
  static ::java::lang::Class class$;
};

#endif // __gnu_java_lang_reflect_TypeVariableImpl__
