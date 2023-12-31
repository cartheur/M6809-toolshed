/*****************************************************************************
	proc_branch.c	- Process branch ops

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
#include "as.h"
#include "error.h"
#include "util.h"
#include "proc_util.h"
#include "proto.h"


void ProcShortBranch(EnvContext *ctx, const Mneumonic *op)
{
	int32	result;
	int		dist;
	bool	status;

	status = Evaluate(ctx, &result, EVAL_NORMAL, NULL);

	if(true == status) {
		dist = (int)result - (GetPCReg() + 2);
	} else {
		dist = -2;
	}

	EmitOpCode(ctx, op, 0);

	if(ctx->m_Pass == 2 && (dist > MAX_BYTE || dist < MIN_BYTE)) {
		error(ctx, ERR_GENERAL, "branch destination is out of range", dist);
		dist = -2;
	}

	EmitOpRelAddrByte(ctx, lobyte(dist));
}


void ProcLongBranch(EnvContext *ctx, const Mneumonic *op)
{
	bool	status;
	int32	result;
	int		offset;
	int		dist;

	if(NOPAGE == op->page) {
		offset = 3;
	} else {
		offset = 4;
	}

	status = Evaluate(ctx, &result, EVAL_NORMAL, NULL);

	dist = (int)result - (GetPCReg() + offset);

	if((dist >= MIN_BYTE) && (dist <= MAX_BYTE)) {
		ctx->m_OptimizeLine = true;
	}

	EmitOpCode(ctx, op, 0);
	EmitOpRelAddrWord(ctx, loword(dist));
}


