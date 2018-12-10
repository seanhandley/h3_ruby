#include <ruby.h>
#include <h3/h3api.h>
#include <stdio.h>

#define H3_TO_STR_BUF_SIZE 32

static GeoCoord to_geocoord(VALUE coords);

static VALUE h3_geoToH3(VALUE mod, VALUE coords, VALUE res) {
  GeoCoord h3_coords = to_geocoord(coords);
  return LONG2NUM(geoToH3(&h3_coords, NUM2INT(res)));
}

static VALUE h3_h3ToGeo(VALUE mod, VALUE h3index) {
  GeoCoord h3_coords = { .lat = 0, .lon = 0 };
  h3ToGeo(NUM2LONG(h3index), &h3_coords);
  return rb_ary_new_from_args(2, DBL2NUM(radsToDegs(h3_coords.lat)), DBL2NUM(radsToDegs(h3_coords.lon)));
}

static VALUE h3_h3ToString(VALUE mod, VALUE h) {
  size_t sz = H3_TO_STR_BUF_SIZE;
  char str[H3_TO_STR_BUF_SIZE];
  h3ToString(NUM2LONG(h), str, sz);
  return rb_str_new_cstr(str);
}

/* --- Initialization -------------------------------------------------------------------------- */

/* This function has a special name and it is invoked by Ruby to initialize the extension. */
void Init_h3()
{
  VALUE h3_ruby = rb_define_module("H3");
  rb_define_singleton_method(h3_ruby, "geo_to_h3", h3_geoToH3, 2);
  rb_define_singleton_method(h3_ruby, "h3_to_geo", h3_h3ToGeo, 1);
  rb_define_singleton_method(h3_ruby, "h3_to_string", h3_h3ToString, 1);
}

// Private functions

static GeoCoord to_geocoord(VALUE coords)
{
  if (TYPE(coords) != T_ARRAY) {
    ID method = rb_intern("to_coordinates");
    if (rb_respond_to(coords, method)) {
      coords = rb_funcall(coords, method, 0);
      Check_Type(coords, T_ARRAY);
    } else {
      rb_raise(rb_eTypeError, "%+"PRIsVALUE" are not valid coordinates", coords);
    }
  }

  if (RARRAY_LEN(coords) != 2) {
    rb_raise(rb_eArgError, "%+"PRIsVALUE" should have exactly two coordinates", coords);
  }

  return (GeoCoord) {
    degsToRads(NUM2DBL(rb_ary_entry(coords, 0))),
    degsToRads(NUM2DBL(rb_ary_entry(coords, 1)))
  };
}
