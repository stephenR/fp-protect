
// DO NOT EDIT THIS FILE - it is machine generated -*- c++ -*-

#ifndef __javax_net_ssl_SSLException__
#define __javax_net_ssl_SSLException__

#pragma interface

#include <java/io/IOException.h>
extern "Java"
{
  namespace javax
  {
    namespace net
    {
      namespace ssl
      {
          class SSLException;
      }
    }
  }
}

class javax::net::ssl::SSLException : public ::java::io::IOException
{

public:
  SSLException(::java::lang::String *);
  SSLException(::java::lang::String *, ::java::lang::Throwable *);
  SSLException(::java::lang::Throwable *);
private:
  static const jlong serialVersionUID = 4511006460650708967LL;
public:
  static ::java::lang::Class class$;
};

#endif // __javax_net_ssl_SSLException__
