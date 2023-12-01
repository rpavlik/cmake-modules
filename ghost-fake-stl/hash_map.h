/**	@file
	@brief	Fake header to allow GHOST 4.09 use with MSVC 2005

	@date	2012

	@author
	Rylie Pavlik
	<rylie@ryliepavlik.com> and <rylie@ryliepavlik.com>
	https://ryliepavlik.com/
	Iowa State University Virtual Reality Applications Center
	Human-Computer Interaction Graduate Program
*/
// Copyright 2012, Iowa State University
// SPDX-License-Identifier: BSL-1.0

#pragma once

#include <hash_map>
//using stdext::hash_map;

template<typename Key>
class hash;
template<typename Key>
class equal_to;

template<typename Key, typename Val, typename HashFcn, typename EqualKey, typename Alloc>
class hash_map;

template<typename Key, typename Val>
class hash_map<Key, Val, hash<Key>, equal_to<Val> > : public stdext::hash_map<Key, Val> {};
