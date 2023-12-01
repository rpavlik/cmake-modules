/**	@file
	@brief	Fake header to allow GHOST 4.09 use with MSVC 2005

	@date	2010

	@author
	Rylie Pavlik
	<rylie@ryliepavlik.com> and <rylie@ryliepavlik.com>
	https://ryliepavlik.com/
	Iowa State University Virtual Reality Applications Center
	Human-Computer Interaction Graduate Program
*/
// Copyright 2010, Iowa State University
// SPDX-License-Identifier: BSL-1.0

#pragma once

#include <vector>
using std::vector;

// Disable dll export that depends on the SGI STL implementation
#undef GHOST_EXTRA_TEMPLATE_DECLARATIONS
