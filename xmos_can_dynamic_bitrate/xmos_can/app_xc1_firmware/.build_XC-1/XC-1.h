#ifndef HAVE_PLATFORM_H
#define HAVE_PLATFORM_H

#include <xs1.h>

/*
 * Platform description header file.
 * Automatically generated from "C:\Program Files\XMOS\DesktopTools\10.4.2/configs\XC-1.xn".
 */

#ifdef __XC__
/* Core array declaration. */
extern core stdcore[4];
#endif

#ifdef __XC__
/* Service prototypes. */
/* none */
#endif

#if !defined(__ASSEMBLER__)
#define PORT_CLOCKLED_0 on stdcore[0]: XS1_PORT_4A
#define PORT_CLOCKLED_1 on stdcore[0]: XS1_PORT_4B
#define PORT_CLOCKLED_2 on stdcore[0]: XS1_PORT_4C
#define PORT_CLOCKLED_SELG on stdcore[0]: XS1_PORT_1E
#define PORT_CLOCKLED_SELR on stdcore[0]: XS1_PORT_1F
#define PORT_BUTTON on stdcore[0]: XS1_PORT_4D
#define PORT_UART_TX on stdcore[0]: XS1_PORT_1H
#define PORT_UART_RX on stdcore[0]: XS1_PORT_1I
#define PORT_SPEAKER on stdcore[0]: XS1_PORT_1K
#define PORT_BUTTONLED on stdcore[0]: XS1_PORT_8D
#else
#define PORT_CLOCKLED_0 XS1_PORT_4A
#define PORT_CLOCKLED_1 XS1_PORT_4B
#define PORT_CLOCKLED_2 XS1_PORT_4C
#define PORT_CLOCKLED_SELG XS1_PORT_1E
#define PORT_CLOCKLED_SELR XS1_PORT_1F
#define PORT_BUTTON XS1_PORT_4D
#define PORT_UART_TX XS1_PORT_1H
#define PORT_UART_RX XS1_PORT_1I
#define PORT_SPEAKER XS1_PORT_1K
#define PORT_BUTTONLED XS1_PORT_8D
#endif


/* Reference frequency definition. */
#define PLATFORM_REFERENCE_HZ 100000000
#define PLATFORM_REFERENCE_KHZ 100000
#define PLATFORM_REFERENCE_MHZ 100

#endif /* HAVE_PLATFORM_H */

