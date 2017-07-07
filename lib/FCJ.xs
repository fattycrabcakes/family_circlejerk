#include "family_circlejerk.h"

MODULE = FCJ PACKAGE = FCJ
PROTOTYPES: DISABLE

SV*
get(SV* caller,filename)
	SV* caller
	const char* filename
	CODE:
		RETVAL = fcj_get_info(filename);
	OUTPUT:
		RETVAL
 
