#include <ruby.h>
#include <h3/h3api.h>

static VALUE hello_world(VALUE mod)
{
  return rb_str_new2("hello world");
}

static VALUE h3_maxKringSize(VALUE mod, VALUE k) {
  return INT2NUM(maxKringSize(NUM2INT(k)));
}

/* --- Initialization -------------------------------------------------------------------------- */

/* This function has a special name and it is invoked by Ruby to initialize the extension. */
void Init_h3()
{
    VALUE h3_ruby = rb_define_module("H3Ruby");
    rb_define_singleton_method(h3_ruby, "hello_world", hello_world, 0);
    rb_define_singleton_method(h3_ruby, "max_kring_size", h3_maxKringSize, 1);
}
