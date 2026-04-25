#include <stdint.h>

// ----- Memory Map Definitions -----
#define UART_BASE 0x20000000
#define GPIO_BASE 0x20001000

// UART Registers (from uart_mmio_wrapper)
#define UART_DATA ((volatile uint32_t *)(UART_BASE + 0x00))
#define UART_STATUS ((volatile uint32_t *)(UART_BASE + 0x04))
#define UART_BAUD ((volatile uint32_t *)(UART_BASE + 0x08))

// GPIO Registers (from gpio.v)
#define GPIO_DIR ((volatile uint32_t *)(GPIO_BASE + 0x00))
#define GPIO_IN ((volatile uint32_t *)(GPIO_BASE + 0x04))
#define GPIO_OUT ((volatile uint32_t *)(GPIO_BASE + 0x08))

// Dummy trap handler since crt0.S expects it
void __attribute__((interrupt("machine"))) trap_handler(void) {
  // We are using polling for this test, so we ignore interrupts.
}

// Helper to print a single character
void uart_putc(char c) {
  // Bit 0 of STATUS is tx_busy. Wait until it is 0.
  while ((*UART_STATUS & 0x01) != 0)
    ;
  *UART_DATA = c;
}

int main() {
  // 1. Setup GPIO: Set lower 16 bits as output, upper 16 as input
  *GPIO_DIR = 0x0000FFFF;

  // 2. Setup UART Baud Rate
  *UART_BAUD = 868; // 115200 @ 100MHz

  // 3. Test GPIO Output
  *GPIO_OUT = 0xAAAA; // Write a recognizable pattern to the output pins

  // 4. Test UART TX
  uart_putc('H');
  uart_putc('I');
  uart_putc('\n');

  // 5. Infinite Echo & GPIO Mirror Loop
  while (1) {
    // Read GPIO inputs (upper 16 bits) and mirror them to the outputs (lower 16
    // bits)
    uint32_t in_val = *GPIO_IN;
    *GPIO_OUT = (in_val >> 16);

    // Check if UART RX has data (rx_valid is Bit 1 of STATUS)
    if (*UART_STATUS & 0x02) {
      // Reading from UART_DATA gets the byte AND clears the RX interrupt/valid
      // flag
      char rx_char = (char)(*UART_DATA);

      // Echo it back!
      uart_putc(rx_char);
    }
  }

  return 0;
}
