
// DO NOT EDIT THIS FILE - it is machine generated -*- c++ -*-

#ifndef __javax_naming_ldap_UnsolicitedNotification__
#define __javax_naming_ldap_UnsolicitedNotification__

#pragma interface

#include <java/lang/Object.h>
#include <gcj/array.h>

extern "Java"
{
  namespace javax
  {
    namespace naming
    {
        class NamingException;
      namespace ldap
      {
          class Control;
          class UnsolicitedNotification;
      }
    }
  }
}

class javax::naming::ldap::UnsolicitedNotification : public ::java::lang::Object
{

public:
  virtual JArray< ::java::lang::String * > * getReferrals() = 0;
  virtual ::javax::naming::NamingException * getException() = 0;
  virtual ::java::lang::String * getID() = 0;
  virtual JArray< jbyte > * getEncodedValue() = 0;
  virtual JArray< ::javax::naming::ldap::Control * > * getControls() = 0;
  static ::java::lang::Class class$;
} __attribute__ ((java_interface));

#endif // __javax_naming_ldap_UnsolicitedNotification__
