/*****************************************************************************
	input.h	- Generic file input functions

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
#ifndef INPUT_H
#define INPUT_H

#include "context.h"

typedef struct {
	char		m_Line[MAX_BUFFERSIZE];
	char		m_Label[MAX_BUFFERSIZE];
	char		m_Opcode[MAX_BUFFERSIZE];
	char		m_Operand[MAX_BUFFERSIZE];
} LineBuffer;


int GetOpenFileCount();
bool OpenInputFile(EnvContext *ctx, const char *filename, const bool binary);
int CloseInputFile(EnvContext *ctx);
const char *GetCurrentFilePathname();
int GetCurrentInputFileSize(void);
u_char ReadInputByte();
bool ReadInputLine(EnvContext *ctx, char *lineBuffer, const int maxLength);


#endif	/* INPUT_H */
