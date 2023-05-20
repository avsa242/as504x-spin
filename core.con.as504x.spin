{
    --------------------------------------------
    Filename: core.con.as504x.spin
    Author: Jesse Burt
    Description: AS504x-specific hardware constants
    Copyright (c) 2023
    Started May 19, 2023
    Updated May 20, 2023
    See end of file for terms of use.
    --------------------------------------------
}

CON

    { SPI Configuration }
    SPI_MAX_FREQ        = 1_000_000             ' device max SPI bus freq
    SPI_MODE            = 3                     ' 0..3

    { timings }
    T_POR_SLOW          = 80_000                ' MODE pin = 0
    T_POR_FAST          = 20_000                ' MODE pin = 1
    T_POR               = 80_000                ' startup time (usecs)


    { output data }
    AS5040_ANGLE_MASK   = $3ff                  ' unsigned 10-bit
    AS5043_ANGLE_MASK   = $3ff                  ' unsigned 10-bit
    AS5045_ANGLE_MASK   = $fff                  ' unsigned 12-bit

    AS5040_RANGE        = (1 << 10)
    AS5043_RANGE        = (1 << 10)
    AS5045_RANGE        = (1 << 12)

    AS5040_DEG_LSB      = 360_000000 / AS5040_RANGE
    AS5043_DEG_LSB      = 360_000000 / AS5043_RANGE
    AS5045_DEG_LSB      = 360_000000 / AS5045_RANGE

    DATA_LSB            = 5

    STATUS_MASK         = $3f
        OCF             = 5
        OCF_BITS        = (1 << OCF)
        COF             = 4
        COF_BITS        = (1 << COF)
        LIN             = 3
        LIN_BITS        = (1 << LIN)
        MAG_INC         = 2
        MAG_INC_BITS    = (1 << MAG_INC)
        MAG_DEC         = 1
        MAG_DEC_BITS    = (1 << MAG_DEC)
        MAG_FLD         = 1                     ' pseudo-field combining LIN | MAG_INC | MAG_DEC
        MAG_FLD_BITS    = (%111 << MAG_FLD)
        MAG             = 1                     ' pseudo-field combining MAG_INC | MAG_DEC
        MAG_BITS        = (%11 << MAG)
        PARITY          = 0

PUB null()
' This is not a top-level object

DAT
{
Copyright 2023 Jesse Burt

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
associated documentation files (the "Software"), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify, merge, publish, distribute,
sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or
substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT
OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
}

