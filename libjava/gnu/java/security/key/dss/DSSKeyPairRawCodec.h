
// DO NOT EDIT THIS FILE - it is machine generated -*- c++ -*-

#ifndef __gnu_java_security_key_dss_DSSKeyPairRawCodec__
#define __gnu_java_security_key_dss_DSSKeyPairRawCodec__

#pragma interface

#include <java/lang/Object.h>
#include <gcj/array.h>

extern "Java"
{
  namespace gnu
  {
    namespace java
    {
      namespace security
      {
        namespace key
        {
          namespace dss
          {
              class DSSKeyPairRawCodec;
          }
        }
      }
    }
  }
  namespace java
  {
    namespace security
    {
        class PrivateKey;
        class PublicKey;
    }
  }
}

class gnu::java::security::key::dss::DSSKeyPairRawCodec : public ::java::lang::Object
{

public:
  DSSKeyPairRawCodec();
  virtual jint getFormatID();
  virtual JArray< jbyte > * encodePublicKey(::java::security::PublicKey *);
  virtual ::java::security::PublicKey * decodePublicKey(JArray< jbyte > *);
  virtual JArray< jbyte > * encodePrivateKey(::java::security::PrivateKey *);
  virtual ::java::security::PrivateKey * decodePrivateKey(JArray< jbyte > *);
  static ::java::lang::Class class$;
};

#endif // __gnu_java_security_key_dss_DSSKeyPairRawCodec__
