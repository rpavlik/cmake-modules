// Original Author:
// 2009-2021, Rylie Pavlik <rylie.pavlik@collabora.com> <rylie@ryliepavlik.com>
// https://ryliepavlik.com/
//
// Copyright 2021, Collabora, Ltd.
// Copyright 2009-2010, Iowa State University
//
// SPDX-License-Identifier: BSL-1.0

// Small header computed by CMake to set up boost test.
// include AFTER #define BOOST_TEST_MODULE whatever
// but before any other boost test includes.

// Using the Boost UTF dynamic library

#define BOOST_TEST_DYN_LINK
#include <boost/test/unit_test.hpp>

