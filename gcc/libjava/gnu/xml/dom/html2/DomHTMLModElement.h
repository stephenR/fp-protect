
// DO NOT EDIT THIS FILE - it is machine generated -*- c++ -*-

#ifndef __gnu_xml_dom_html2_DomHTMLModElement__
#define __gnu_xml_dom_html2_DomHTMLModElement__

#pragma interface

#include <gnu/xml/dom/html2/DomHTMLElement.h>
extern "Java"
{
  namespace gnu
  {
    namespace xml
    {
      namespace dom
      {
        namespace html2
        {
            class DomHTMLDocument;
            class DomHTMLModElement;
        }
      }
    }
  }
}

class gnu::xml::dom::html2::DomHTMLModElement : public ::gnu::xml::dom::html2::DomHTMLElement
{

public: // actually protected
  DomHTMLModElement(::gnu::xml::dom::html2::DomHTMLDocument *, ::java::lang::String *, ::java::lang::String *);
public:
  virtual ::java::lang::String * getCite();
  virtual void setCite(::java::lang::String *);
  virtual ::java::lang::String * getDateTime();
  virtual void setDateTime(::java::lang::String *);
  static ::java::lang::Class class$;
};

#endif // __gnu_xml_dom_html2_DomHTMLModElement__
