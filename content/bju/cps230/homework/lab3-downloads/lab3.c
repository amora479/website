#include <stdio.h>
#include <assert.h>

/* [Homework Problem 2.64]
 * Return 1 when any odd bit of x equals 1; 0 otherwise.
 * Assume w=32.
 */
int any_odd_one(unsigned x) {
    /* TODO */
}

/* [Homework Problem 2.68]
 * Mask with least significant <n> bits set to 1
 * Examples: n = 6 --> 0x3F, n = 17 --> 0x1ffff
 * Assume 1 <= n <= w
 */
int lower_one_mask(int x) {
    /* TODO */
}

/* [Homework problem 2.66]
 * Generate mask indicating leftmost 1 in x.  Assume w=32.
 * E.g., 0xff00 -> 0x80000, and 0x6600 -> 0x4000
 * If x = 0, then return 0.
 */
int leftmost_one(unsigned x) {
    /* TODO */
}

int main() {
    printf("CpS 230 Lab 3: YOUR NAME (yrlogin)\n");

    /* trivial 2.64 tests */
    assert(any_odd_one(1) == 0);
    assert(any_odd_one(2) == 1);
    
    /* 2.68 tests from the book */
    assert(lower_one_mask(6) == 0x3f);      /* the book erroneously claims n=6 -> 0x2f (10_1111) instead of 0x3f (11_1111) */
    assert(lower_one_mask(17) == 0x1ffff);
    
    /* 2.66 tests from the book */
    assert(leftmost_one(0xff00) == 0x8000);
    assert(leftmost_one(0x6600) == 0x4000);

    /* Be sure to add at least 2 new tests for each function--think about edge cases! */

    return 0;
}
