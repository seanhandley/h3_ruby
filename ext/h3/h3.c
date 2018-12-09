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

static VALUE h3_degsToRads(VALUE mod, VALUE degrees) {
  return DBL2NUM(degsToRads(NUM2DBL(degrees)));
}

static VALUE h3_radsToDegs(VALUE mod, VALUE rads) {
  return DBL2NUM(radsToDegs(NUM2DBL(rads)));
}

static VALUE h3_hexAreaKm2(VALUE mod, VALUE res) {
  return DBL2NUM(hexAreaKm2(NUM2INT(res)));
}

static VALUE h3_hexAreaM2(VALUE mod, VALUE res) {
  return DBL2NUM(hexAreaM2(NUM2INT(res)));
}

static VALUE h3_edgeLengthKm(VALUE mod, VALUE res) {
  return DBL2NUM(edgeLengthKm(NUM2INT(res)));
}

static VALUE h3_edgeLengthM(VALUE mod, VALUE res) {
  return DBL2NUM(edgeLengthM(NUM2INT(res)));
}

static VALUE h3_h3IsResClassIII(VALUE mod, VALUE h) {
  return h3IsResClassIII(NUM2LONG(h)) != 0 ? Qtrue : Qfalse;
}

static VALUE h3_h3IsPentagon(VALUE mod, VALUE h) {
  return h3IsPentagon(NUM2LONG(h)) != 0 ? Qtrue : Qfalse;
}

static VALUE h3_h3UnidirectionalEdgeIsValid(VALUE mod, VALUE edge) {
  return h3UnidirectionalEdgeIsValid(NUM2LONG(edge)) != 0 ? Qtrue : Qfalse;
}

static VALUE h3_h3GetResolution(VALUE mod, VALUE h) {
  return INT2NUM(h3GetResolution(NUM2LONG(h)));
}

static VALUE h3_h3GetBaseCell(VALUE mod, VALUE h) {
  return INT2NUM(h3GetBaseCell(NUM2LONG(h)));
}

static VALUE h3_getOriginuint64_tFromUnidirectionalEdge(VALUE mod, VALUE edge) {
  return LONG2NUM(getOriginH3IndexFromUnidirectionalEdge(NUM2LONG(edge)));
}

static VALUE h3_getDestinationuint64_tFromUnidirectionalEdge(VALUE mod, VALUE edge) {
  return LONG2NUM(getDestinationH3IndexFromUnidirectionalEdge(NUM2LONG(edge)));
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
    rb_define_singleton_method(h3_ruby, "degs_to_rads", h3_degsToRads, 1);
    rb_define_singleton_method(h3_ruby, "rads_to_degs", h3_radsToDegs, 1);
    rb_define_singleton_method(h3_ruby, "hex_area_km2", h3_hexAreaKm2, 1);
    rb_define_singleton_method(h3_ruby, "hex_area_m2", h3_hexAreaM2, 1);
    rb_define_singleton_method(h3_ruby, "edge_length_km", h3_edgeLengthKm, 1);
    rb_define_singleton_method(h3_ruby, "edge_length_m", h3_edgeLengthM, 1);
    rb_define_singleton_method(h3_ruby, "h3_res_class_3?", h3_h3IsResClassIII, 1);
    rb_define_singleton_method(h3_ruby, "h3_pentagon?", h3_h3IsPentagon, 1);
    rb_define_singleton_method(h3_ruby, "h3_unidirectional_edge_valid?", h3_h3UnidirectionalEdgeIsValid, 1);
    rb_define_singleton_method(h3_ruby, "h3_resolution", h3_h3GetResolution, 1);
    rb_define_singleton_method(h3_ruby, "h3_base_cell", h3_h3GetBaseCell, 1);
    rb_define_singleton_method(h3_ruby, "origin_from_unidirectional_edge", h3_getOriginuint64_tFromUnidirectionalEdge, 1);
    rb_define_singleton_method(h3_ruby, "destination_from_unidirectional_edge", h3_getDestinationuint64_tFromUnidirectionalEdge, 1);
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
