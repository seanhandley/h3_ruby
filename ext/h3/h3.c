#include <ruby.h>
// #include <h3/h3api.h>

static VALUE hello_world(VALUE mod)
{
  return rb_str_new2("hello world");
}

/* --- Initialization -------------------------------------------------------------------------- */

/* This function has a special name and it is invoked by Ruby to initialize the extension. */
void Init_h3()
{
    VALUE h3_ruby = rb_define_module("H3Ruby");
    rb_define_singleton_method(h3_ruby, "hello_world", hello_world, 0);
}
