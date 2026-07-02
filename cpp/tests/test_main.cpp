#include <doctest/doctest.h>

#include "lib.hpp"

TEST_CASE("add") { CHECK(add(2, 3) == 5); }
