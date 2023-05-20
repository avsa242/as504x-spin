{
    --------------------------------------------
    Filename: AS504X-Demo.spin
    Author: Jesse Burt
    Description: Demo of the AS504x encoder driver
    Copyright (c) 2023
    Started May 19, 2023
    Updated May 20, 2023
    See end of file for terms of use.
    --------------------------------------------
}

CON

    _clkmode    = cfg#_clkmode
    _xinfreq    = cfg#_xinfreq

' -- User-defined constants
    SER_BAUD    = 115_200
    LED         = cfg#LED1

    { SPI configuration }
    CS_PIN      = 16
    SCK_PIN     = 17
    MISO_PIN    = 18
' --

OBJ

    cfg:        "boardcfg.flip"
    ser:        "com.serial.terminal.ansi"
    time:       "time"
    encoder:    "input.encoder.as504x"

PUB main() | angle, pos_per

    setup()
    encoder.set_model(encoder.AS5045)
    repeat
        angle := encoder.degrees_abs()
        pos_per := encoder.percent()
        ser.pos_xy(0, 3)
        ser.printf2(@"%3.3d.%03.3ddeg\n\r", (angle/1000), (angle//1000))
        ser.printf2(@"%3.3d.%02.2d%% of full turn", (pos_per/100), (pos_per//100))

PUB setup()

    ser.start(SER_BAUD)
    time.msleep(30)
    ser.clear
    ser.strln(string("Serial terminal started"))

    if ( encoder.startx(CS_PIN, SCK_PIN, MISO_PIN) )
        ser.strln(@"AS504x driver started")
    else
        ser.strln(@"AS504x driver failed to start - halting")
        repeat


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

