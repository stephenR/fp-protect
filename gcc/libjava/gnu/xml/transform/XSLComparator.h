
// DO NOT EDIT THIS FILE - it is machine generated -*- c++ -*-

#ifndef __gnu_xml_transform_XSLComparator__
#define __gnu_xml_transform_XSLComparator__

#pragma interface

#include <java/lang/Object.h>
extern "Java"
{
  namespace gnu
  {
    namespace xml
    {
      namespace transform
      {
          class XSLComparator;
      }
    }
  }
  namespace org
  {
    namespace w3c
    {
      namespace dom
      {
          class Node;
      }
    }
  }
}

class gnu::xml::transform::XSLComparator : public ::java::lang::Object
{

public: // actually package-private
  XSLComparator(::java::util::List *);
public:
  virtual jint XSLComparator$compare(::org::w3c::dom::Node *, ::org::w3c::dom::Node *);
  virtual jint compare(::java::lang::Object *, ::java::lang::Object *);
public: // actually package-private
  ::java::util::List * __attribute__((aligned(__alignof__( ::java::lang::Object)))) sortKeys;
public:
  static ::java::lang::Class class$;
};

#endif // __gnu_xml_transform_XSLComparator__
