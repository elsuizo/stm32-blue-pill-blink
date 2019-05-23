/* -------------------------------------------------------------------------
@file main.c

@date 05/23/19 10:05:26
@author Martin Noblia
@email mnoblia@disroot.org

@brief

@detail

Licence:
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or (at
your option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
---------------------------------------------------------------------------*/
#include <libopencm3/stm32/rcc.h>
#include <libopencm3/stm32/gpio.h>

int main(void) {
   rcc_periph_clock_enable(RCC_GPIOC);
   gpio_set_mode(GPIOC, GPIO_MODE_OUTPUT_2_MHZ, GPIO_CNF_OUTPUT_PUSHPULL, GPIO13);
   gpio_set(GPIOC, GPIO13);
   while(1) {
      /* wait a little bit */
      for (int i = 0; i < 800000; i++) {
         __asm__("nop");
      }
      gpio_toggle(GPIOC, GPIO13);
   }
}


