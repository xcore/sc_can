
#include "CanIncludes.h"

extern int alignTable[];

void initAlignTable() {
	int aligned = QUANTA_TOTAL - QUANTA_PHASE2;

	for (int zeros = 0; zeros < 33; zeros++) {
		alignTable[zeros] = QUANTA_TOTAL;
	}

	for (int zeros = 1; zeros < 32; zeros++) {
		if (zeros < aligned) {
			// Edge is late, in the propagation delay segment need to extend the bit time
			int phaseError = aligned - zeros;
			if (phaseError <= QUANTA_SJW) {
				// Maximum compensation allowed by spec
				alignTable[zeros] = QUANTA_TOTAL + phaseError;
			}
		} else if (zeros > aligned) {
			// Edge is early, in the propagation delay segment need to reduce the bit time
			int phaseError = zeros - aligned;
			if (phaseError <= QUANTA_SJW) {
				// Maximum compensate allowed by spec
				alignTable[zeros] = QUANTA_TOTAL - phaseError;
			}
		}
	}

	/*
	 * Used when starting the RX state machine in order to align to the sample time
	 * in one instruction
	 */
	alignTable[33] = QUANTA_TOTAL - QUANTA_PHASE2;
}
