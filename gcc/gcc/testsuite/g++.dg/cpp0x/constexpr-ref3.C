// PR c++/50298
// { dg-options -std=c++0x }

int global_variable;

template <class T> struct X {
  static constexpr T r = global_variable;
};

X<int&> x;
