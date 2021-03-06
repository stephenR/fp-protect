
// DO NOT EDIT THIS FILE - it is machine generated -*- c++ -*-

#ifndef __gnu_javax_crypto_sasl_srp_SecurityContext__
#define __gnu_javax_crypto_sasl_srp_SecurityContext__

#pragma interface

#include <java/lang/Object.h>
#include <gcj/array.h>

extern "Java"
{
  namespace gnu
  {
    namespace javax
    {
      namespace crypto
      {
        namespace sasl
        {
          namespace srp
          {
              class CALG;
              class IALG;
              class SecurityContext;
          }
        }
      }
    }
  }
}

class gnu::javax::crypto::sasl::srp::SecurityContext : public ::java::lang::Object
{

public: // actually package-private
  SecurityContext(::java::lang::String *, JArray< jbyte > *, JArray< jbyte > *, JArray< jbyte > *, JArray< jbyte > *, jboolean, jint, jint, ::gnu::javax::crypto::sasl::srp::IALG *, ::gnu::javax::crypto::sasl::srp::IALG *, ::gnu::javax::crypto::sasl::srp::CALG *, ::gnu::javax::crypto::sasl::srp::CALG *);
  virtual ::java::lang::String * getMdName();
  virtual JArray< jbyte > * getSID();
  virtual JArray< jbyte > * getK();
  virtual JArray< jbyte > * getClientIV();
  virtual JArray< jbyte > * getServerIV();
  virtual jboolean hasReplayDetection();
  virtual jint getInCounter();
  virtual jint getOutCounter();
  virtual ::gnu::javax::crypto::sasl::srp::IALG * getInMac();
  virtual ::gnu::javax::crypto::sasl::srp::IALG * getOutMac();
  virtual ::gnu::javax::crypto::sasl::srp::CALG * getInCipher();
  virtual ::gnu::javax::crypto::sasl::srp::CALG * getOutCipher();
private:
  ::java::lang::String * __attribute__((aligned(__alignof__( ::java::lang::Object)))) mdName;
  JArray< jbyte > * sid;
  JArray< jbyte > * K;
  JArray< jbyte > * cIV;
  JArray< jbyte > * sIV;
  jboolean replayDetection;
  jint inCounter;
  jint outCounter;
  ::gnu::javax::crypto::sasl::srp::IALG * inMac;
  ::gnu::javax::crypto::sasl::srp::IALG * outMac;
  ::gnu::javax::crypto::sasl::srp::CALG * inCipher;
  ::gnu::javax::crypto::sasl::srp::CALG * outCipher;
public:
  static ::java::lang::Class class$;
};

#endif // __gnu_javax_crypto_sasl_srp_SecurityContext__
