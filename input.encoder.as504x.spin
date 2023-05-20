{
    --------------------------------------------
    Filename: input.encoder.as504x.spin
    Author: Jesse Burt
    Description: AS504x-series magnetic encoders driver (AS5040, AS5043, AS5045)
    Copyright (c) 2023
    Started May 19, 2023
    Updated May 20, 2023
    See end of file for terms of use.
    --------------------------------------------
}

CON

    { encoder model symbols }
    AS5040      = 16                            ' equivalent to number of bits shifted out
    AS5043      = 16
    AS5045      = 18

    { magnetic field strength ranges }
    GREEN       = 0
    YELLOW      = 3
    RED         = 7

    { driver startup delay (can be overriden in the parent object's declaration of this object) }
    T_POR       = core.T_POR_SLOW

VAR

    long _CS
    long _encoder_res
    word _data_mask
    byte _model, _status

OBJ

{ decide: Bytecode SPI engine, or PASM? Default is PASM if BC isn't specified }
#ifdef AS504X_SPI_BC
    spi : "com.spi.25khz.nocog"                 ' BC I2C engine
#else
    spi : "com.spi.1mhz"                        ' PASM SPI engine (1MHz)
#endif
    core: "core.con.as504x"                     ' hw-specific low-level const's
    time: "time"                                ' Basic timing functions

PUB null()
' This is not a top-level object

PUB startx(CS_PIN, SCK_PIN, MISO_PIN): status
' Start using custom IO pins
'   CS_PIN: chip/slave-select (active low)
'   SCK_PIN: serial clock
'   MISO_PIN: master-in slave-out
'   Returns:
'       cog/core ID+1 on success
'       0 on failure
    if ( lookdown(CS_PIN: 0..31) and lookdown(SCK_PIN: 0..31) and lookdown(MISO_PIN: 0..31) )
        if ( status := spi.init(SCK_PIN, -1, MISO_PIN, core.SPI_MODE) )
            time.usleep(T_POR)                  ' wait for device startup
            _CS := CS_PIN                       ' copy i/o pin to hub var
            outa[_CS] := 1                      ' ensure the device isn't selected on startup
            dira[_CS] := 1
            set_model(AS5045)                   ' default to AS5045 settings
            return
    ' if this point is reached, something above failed
    ' Re-check I/O pin assignments, bus speed, connections, power
    ' Lastly - make sure you have at least one free core/cog
    return FALSE

PUB stop()
' Stop the driver
    spi.deinit()
    _CS := 0

PUB defaults()
' Set factory defaults
    set_model(AS5045)

PUB degrees_abs(): d
' Encoder position
'   Returns: milli-degrees
    return encoder_word2deg_abs( encoder_data() )

PUB encoder_data(): d | tmp
' Encoder ADC word
'   Returns:
'       unsigned 10-bit word (AS5040, AS5043)
'       u12 (AS5045)
    repeat                                      ' keep reading...
        outa[_CS] := 0
        tmp := spi.rdbits_msbf(_model)
        outa[_CS] := 1
    until (tmp & core.OCF_BITS)                 ' ...until the data is valid

    _status := (tmp & core.STATUS_MASK)
    return ((tmp >> core.DATA_LSB) & _data_mask)

PUB encoder_word2deg_abs(w): d
' Convert encoder ADC word to thousandths (0.001) of a degree
'   NOTE: set_model() must have been called prior to this method to ensure the scaling
'       is correct
'   NOTE: actual resolution is 0.087deg for AS5045, 0.351deg for AS5040 and AS5043
'   Returns:
'       absolute position in thousandths of a degree (example: 26806 == 26.806deg)
    return ((w * _encoder_res) / 1000)

PUB encoder_word2percent(w): p
' Convert encoder ADC word to hundredths of a percent of absolute position
'   NOTE: set_model() must have been called prior to this method to ensure the scaling
'       is correct
'   Returns:
'       absolute position in hundredths of a percent (example: 744 == 7.44%)
    return ((w * 1_0000) / _data_mask)

PUB linearity_error(): f
' Flag indicating a linearity error in the last measurement
'   Returns:
'       0: no error
'       1: magnetic field out of range
'   NOTE: This function only returns valid data if the device's One-Time-Programmable register
'       'CompEn' was clear during programming
    return ((_status & core.LIN_BITS) <> 0)

PUB mag_field_range(): s
' Range of magnetic field strength experienced by device
'   Returns:
'       GREEN (0): ~45milli-Tesla..75milli-Tesla (OK)
'       YELLOW (3): ~25mT..45mT or ~75mT..135mT (OK, but slightly reduced accuracy)
'       RED (7): < ~25mT or > ~135mT (not recommended)
'   NOTE: This function only returns valid data if the device's OTP register 'CompEn' was
'       set during programming
    return ((_status & core.MAG_FLD_BITS) >> core.MAG_FLD)

PUB percent(): p
' Percentage of one full revolution (absolute position)
'   Returns:
'       absolute position in hundredths of a percent
    return (encoder_word2percent( encoder_data() ))

PUB set_model(m): s
' Set specific model of AS504x
'   Valid values:
'       AS5040, AS5043 (16)
'       AS5045 (18)
'   Returns:
'       0: success
'       -1: invalid value
    s := 0
    if ( m == AS5040 )                          ' covers both AS5040 & AS5043 cases
        _data_mask := core.AS5040_ANGLE_MASK
        _encoder_res := core.AS5040_DEG_LSB     ' degrees per LSB * 1_000_000
    elseif ( m == AS5045 )
        _data_mask := core.AS5045_ANGLE_MASK
        _encoder_res := core.AS5045_DEG_LSB
    else
        return -1                               ' invalid choice

    _model := m

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

