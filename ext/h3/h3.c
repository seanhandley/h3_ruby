#include <ruby.h>
#include <h3/h3api.h>

#define TO_RADIANS(degrees) (degrees)*M_PI/180.0

static GeoCoord to_geocoord(VALUE coords);

static VALUE h3_maxKringSize(VALUE mod, VALUE k) {
  return INT2NUM(maxKringSize(NUM2INT(k)));
}

static VALUE h3_geoToH3(VALUE mod, VALUE coords, VALUE res) {
  GeoCoord h3_coords = to_geocoord(coords);
  return LONG2NUM(geoToH3(&h3_coords, NUM2INT(res)));
}

/* --- Initialization -------------------------------------------------------------------------- */

/* This function has a special name and it is invoked by Ruby to initialize the extension. */
void Init_h3()
{
    VALUE h3_ruby = rb_define_module("H3Ruby");
    rb_define_singleton_method(h3_ruby, "max_kring_size", h3_maxKringSize, 1);
    rb_define_singleton_method(h3_ruby, "geo_to_h3", h3_geoToH3, 2);
}

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
        TO_RADIANS(NUM2DBL(rb_ary_entry(coords, 0))),
        TO_RADIANS(NUM2DBL(rb_ary_entry(coords, 1)))
    };
}