#include <ruby.h>
#include <h3/h3api.h>

static GeoCoord to_geocoord(VALUE coords);

static VALUE h3_maxKringSize(VALUE mod, VALUE k) {
  return INT2NUM(maxKringSize(NUM2INT(k)));
}

static VALUE h3_geoToH3(VALUE mod, VALUE coords, VALUE res) {
  GeoCoord h3_coords = to_geocoord(coords);
  return LONG2NUM(geoToH3(&h3_coords, NUM2INT(res)));
}

static VALUE h3_h3ToGeo(VALUE mod, VALUE h3index) {
  GeoCoord h3_coords = { .lat = 0, .lon = 0 };
  h3ToGeo(NUM2LONG(h3index), &h3_coords);
  return rb_ary_new_from_args(2, DBL2NUM(radsToDegs(h3_coords.lat)), DBL2NUM(radsToDegs(h3_coords.lon)));
}

static VALUE h3_h3IsValid(VALUE mod, VALUE h3index) {
  uint64_t index = NUM2LONG(h3index);
  return h3IsValid(index) != 0 ? Qtrue : Qfalse;
}

static VALUE h3_numHexagons(VALUE mod, VALUE res) {
  int resolution = NUM2INT(res);
  return LONG2NUM(numHexagons(resolution));
}

void H3_EXPORT(h3ToGeo)(H3Index h3, GeoCoord *g);

/* --- Initialization -------------------------------------------------------------------------- */

/* This function has a special name and it is invoked by Ruby to initialize the extension. */
void Init_h3()
{
    VALUE h3_ruby = rb_define_module("H3Ruby");
    rb_define_singleton_method(h3_ruby, "max_kring_size", h3_maxKringSize, 1);
    rb_define_singleton_method(h3_ruby, "geo_to_h3", h3_geoToH3, 2);
    rb_define_singleton_method(h3_ruby, "h3_to_geo", h3_h3ToGeo, 1);
    rb_define_singleton_method(h3_ruby, "h3_valid?", h3_h3IsValid, 1);
    rb_define_singleton_method(h3_ruby, "num_hexagons", h3_numHexagons, 1);
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
