#include "curl-common.h"
#include <curl/options.h>


/* These are defined in typechecking.c */
extern int r_curl_is_slist_option(CURLoption x);
extern int r_curl_is_long_option(CURLoption x);
extern int r_curl_is_off_t_option(CURLoption x);
extern int r_curl_is_string_option(CURLoption x);
extern int r_curl_is_postfields_option(CURLoption x);

SEXP R_list_options(){
  int len = 0;
  const struct curl_easyoption *o = curl_easy_option_next(NULL);
  while(o){
    len++;
    o = curl_easy_option_next(o);
  }
  SEXP names = Rf_allocVector(STRSXP, len);
  SEXP values = Rf_allocVector(INTSXP, len);
  SEXP types = Rf_allocVector(INTSXP, len);
  SEXP alias = Rf_allocVector(LGLSXP, len);
  SEXP oldtype = Rf_allocVector(INTSXP, len);
  for(int i = 0; i < len; i++){
    o = curl_easy_option_next(o);
    SET_STRING_ELT(names, i, Rf_mkChar(o->name ? o->name : "???"));
    INTEGER(values)[i] = o->id;
    INTEGER(types)[i] = o->type;
    LOGICAL(alias)[i] = o->flags & CURLOT_FLAG_ALIAS;
    if(r_curl_is_long_option(o->id)){
      INTEGER(oldtype)[i] = 0;
    } else if(r_curl_is_off_t_option(o->id)){
      INTEGER(oldtype)[i] = 2;
    } else if(r_curl_is_string_option(o->id)){
      INTEGER(oldtype)[i] = 4;
    } else if(r_curl_is_slist_option(o->id)){
      INTEGER(oldtype)[i] = 5;
    } else if(r_curl_is_postfields_option(o->id)){
      INTEGER(oldtype)[i] = 3;
    } else {
      INTEGER(oldtype)[i] = NA_INTEGER;
    }
  }
  return Rf_list5(names, values, types, oldtype, alias);
}

SEXP R_get_opt_by_name(SEXP str){
  const struct curl_easyoption *o = curl_easy_option_by_name(CHAR(STRING_ELT(str, 0)));
  return Rf_mkString(o ? o->name : "");
}

SEXP R_get_opt_by_id(SEXP id){
  const struct curl_easyoption *o = curl_easy_option_by_id((CURLoption) INTEGER(id)[0]);
  return Rf_mkString(o ? o->name : "");
}

