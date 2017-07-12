#include "family_circlejerk.h"



MODULE = FamilyCircleJerk PACKAGE = FamilyCircleJerk
PROTOTYPES: DISABLE

SV*
get(caller,data)
	SV* caller
	const char* data
	CODE:
		RETVAL = fcj_get_info(data);
	OUTPUT:
		RETVAL
