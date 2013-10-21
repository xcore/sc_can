#ifndef CAN_UTILS_H_
#define CAN_UTILS_H_
#include <print.h>
unsigned super_pattern(unsigned &m);
void can_utils_print_frame(can_frame f, char prepend[]);
void can_utils_make_random_frame(can_frame &f, unsigned &x);
int can_utils_equal(can_frame &a, can_frame &b);
#endif /* CAN_UTILS_H_ */
