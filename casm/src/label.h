/*****************************************************************************
	label.h	- Interfaces for Label/Symbol helper functions

	Copyright (c) 2004 Chet Simpson, Digital Asphyxia. All rights reserved.

	The distribution, use, and duplication this file in source or binary form
	is restricted by an Artistic License (see license.txt) included with the
	standard distribution. If the license was not included with this package
	please refer to http://www.oarizo.com for more information.


	Redistribution and use in source and binary forms, with or without
	modification, are permitted provided that: (1) source code distributions
	retain the above copyright notice and this paragraph in its entirety, (2)
	distributions including binary code include the above copyright notice and
	this paragraph in its entirety in the documentation or other materials
	provided with the distribution, and (3) all advertising materials
	mentioning features or use of this software display the following
	acknowledgement:

		"This product includes software developed by Chet Simpson"
	
	The name of the author may be used to endorse or promote products derived
	from this software without specific priorwritten permission.

	THIS SOFTWARE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED
	WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
	MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.

*****************************************************************************/
#ifndef LABEL_H
#define LABEL_H

#include "config.h"
#include "context.h"

bool IsLocalLabelChar(EnvContext *ctx, const char ch);
bool IsLabelStart(EnvContext *ctx, const char ch);
bool IsLabelChar(EnvContext *ctx, const char ch);
bool IsStructLabelStart(EnvContext *ctx, const char ch);
bool IsStructLabelChar(EnvContext *ctx, const char ch);
bool HasLocalLabelChar(EnvContext *ctx, const char *str);
#define IsExportLabelStart IsStructLabelStart
#define IsExportLabelChar IsStructLabelChar


#endif	/* LABEL_H */
