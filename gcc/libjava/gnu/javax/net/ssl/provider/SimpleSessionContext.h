
// DO NOT EDIT THIS FILE - it is machine generated -*- c++ -*-

#ifndef __gnu_javax_net_ssl_provider_SimpleSessionContext__
#define __gnu_javax_net_ssl_provider_SimpleSessionContext__

#pragma interface

#include <gnu/javax/net/ssl/AbstractSessionContext.h>
#include <gcj/array.h>

extern "Java"
{
  namespace gnu
  {
    namespace javax
    {
      namespace net
      {
        namespace ssl
        {
            class Session;
          namespace provider
          {
              class SimpleSessionContext;
          }
        }
      }
    }
  }
}

class gnu::javax::net::ssl::provider::SimpleSessionContext : public ::gnu::javax::net::ssl::AbstractSessionContext
{

public:
  SimpleSessionContext();
public: // actually protected
  ::gnu::javax::net::ssl::Session * implGet(JArray< jbyte > *);
public:
  void load(JArray< jchar > *);
  void put(::gnu::javax::net::ssl::Session *);
  void remove(JArray< jbyte > *);
  void store(JArray< jchar > *);
  ::java::util::Enumeration * getIds();
  jint getSessionCacheSize();
  void setSessionCacheSize(jint);
public: // actually package-private
  static ::java::util::HashMap * access$0(::gnu::javax::net::ssl::provider::SimpleSessionContext *);
public:
  static const jint DEFAULT_TIMEOUT = 300;
private:
  ::java::util::HashMap * __attribute__((aligned(__alignof__( ::gnu::javax::net::ssl::AbstractSessionContext)))) store__;
  jint storeLimit;
public:
  static ::java::lang::Class class$;
};

#endif // __gnu_javax_net_ssl_provider_SimpleSessionContext__
