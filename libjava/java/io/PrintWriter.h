
// DO NOT EDIT THIS FILE - it is machine generated -*- c++ -*-

#ifndef __java_io_PrintWriter__
#define __java_io_PrintWriter__

#pragma interface

#include <java/io/Writer.h>
#include <gcj/array.h>


class java::io::PrintWriter : public ::java::io::Writer
{

public:
  PrintWriter(::java::io::Writer *);
  PrintWriter(::java::io::Writer *, jboolean);
  PrintWriter(::java::io::OutputStream *);
  PrintWriter(::java::io::OutputStream *, jboolean);
  PrintWriter(::java::lang::String *);
  PrintWriter(::java::lang::String *, ::java::lang::String *);
  PrintWriter(::java::io::File *);
  PrintWriter(::java::io::File *, ::java::lang::String *);
public: // actually protected
  virtual void setError();
public:
  virtual jboolean checkError();
  virtual void flush();
  virtual void close();
  virtual void print(::java::lang::String *);
  virtual void print(jchar);
  virtual void print(JArray< jchar > *);
  virtual void print(jboolean);
  virtual void print(jint);
  virtual void print(jlong);
  virtual void print(jfloat);
  virtual void print(jdouble);
  virtual void print(::java::lang::Object *);
  virtual void println();
  virtual void println(jboolean);
  virtual void println(jint);
  virtual void println(jlong);
  virtual void println(jfloat);
  virtual void println(jdouble);
  virtual void println(::java::lang::Object *);
  virtual void println(::java::lang::String *);
  virtual void println(jchar);
  virtual void println(JArray< jchar > *);
  virtual void write(jint);
  virtual void write(JArray< jchar > *, jint, jint);
  virtual void write(::java::lang::String *, jint, jint);
  virtual void write(JArray< jchar > *);
  virtual void write(::java::lang::String *);
  virtual ::java::io::PrintWriter * PrintWriter$append(jchar);
  virtual ::java::io::PrintWriter * PrintWriter$append(::java::lang::CharSequence *);
  virtual ::java::io::PrintWriter * PrintWriter$append(::java::lang::CharSequence *, jint, jint);
  virtual ::java::io::PrintWriter * printf(::java::lang::String *, JArray< ::java::lang::Object * > *);
  virtual ::java::io::PrintWriter * printf(::java::util::Locale *, ::java::lang::String *, JArray< ::java::lang::Object * > *);
  virtual ::java::io::PrintWriter * format(::java::lang::String *, JArray< ::java::lang::Object * > *);
  virtual ::java::io::PrintWriter * format(::java::util::Locale *, ::java::lang::String *, JArray< ::java::lang::Object * > *);
  virtual ::java::lang::Appendable * append(::java::lang::CharSequence *, jint, jint);
  virtual ::java::io::Writer * Writer$append(::java::lang::CharSequence *, jint, jint);
  virtual ::java::lang::Appendable * append(::java::lang::CharSequence *);
  virtual ::java::io::Writer * Writer$append(::java::lang::CharSequence *);
  virtual ::java::lang::Appendable * append(jchar);
  virtual ::java::io::Writer * Writer$append(jchar);
private:
  jboolean __attribute__((aligned(__alignof__( ::java::io::Writer)))) autoflush;
  jboolean error;
  jboolean closed;
public: // actually protected
  ::java::io::Writer * out;
private:
  static JArray< jchar > * line_separator;
public:
  static ::java::lang::Class class$;
};

#endif // __java_io_PrintWriter__
