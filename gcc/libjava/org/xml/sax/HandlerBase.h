
// DO NOT EDIT THIS FILE - it is machine generated -*- c++ -*-

#ifndef __org_xml_sax_HandlerBase__
#define __org_xml_sax_HandlerBase__

#pragma interface

#include <java/lang/Object.h>
#include <gcj/array.h>

extern "Java"
{
  namespace org
  {
    namespace xml
    {
      namespace sax
      {
          class AttributeList;
          class HandlerBase;
          class InputSource;
          class Locator;
          class SAXParseException;
      }
    }
  }
}

class org::xml::sax::HandlerBase : public ::java::lang::Object
{

public:
  HandlerBase();
  virtual ::org::xml::sax::InputSource * resolveEntity(::java::lang::String *, ::java::lang::String *);
  virtual void notationDecl(::java::lang::String *, ::java::lang::String *, ::java::lang::String *);
  virtual void unparsedEntityDecl(::java::lang::String *, ::java::lang::String *, ::java::lang::String *, ::java::lang::String *);
  virtual void setDocumentLocator(::org::xml::sax::Locator *);
  virtual void startDocument();
  virtual void endDocument();
  virtual void startElement(::java::lang::String *, ::org::xml::sax::AttributeList *);
  virtual void endElement(::java::lang::String *);
  virtual void characters(JArray< jchar > *, jint, jint);
  virtual void ignorableWhitespace(JArray< jchar > *, jint, jint);
  virtual void processingInstruction(::java::lang::String *, ::java::lang::String *);
  virtual void warning(::org::xml::sax::SAXParseException *);
  virtual void error(::org::xml::sax::SAXParseException *);
  virtual void fatalError(::org::xml::sax::SAXParseException *);
  static ::java::lang::Class class$;
};

#endif // __org_xml_sax_HandlerBase__
