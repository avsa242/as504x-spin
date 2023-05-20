# as5045-spin 
--------------

This is a P8X32A/Propeller, P2X8C4M64P/Propeller 2 driver object for the AS504x-series magnetic rotary position sensor/encoder.

**IMPORTANT**: This software is meant to be used with the [spin-standard-library](https://github.com/avsa242/spin-standard-library) (P8X32A) or [p2-spin-standard-library](https://github.com/avsa242/p2-spin-standard-library) (P2X8C4M64P). Please install the applicable library first before attempting to use this code, otherwise you will be missing several files required to build the project.


## Salient Features

* SSI (3-wire SPI work-alike; MISO only) connection at ~25kHz (P1, bytecode backend) or 1MHz (P1, PASM backend)
* Read absolute position (ADC word, degrees, or percentage of full rotation)
* Read status flags: linearity error, magnetic field range


## Hardware compatibility

* AS5040 (untested)
* AS5043 (untested)
* AS5045


## Requirements

P1/SPIN1:
* spin-standard-library

~~P2/SPIN2:~~
* ~~p2-spin-standard-library~~ _(not yet implemented)_


## Compiler Compatibility

| Processor | Language | Compiler               | Backend      | Status                |
|-----------|----------|------------------------|--------------|-----------------------|
| P1        | SPIN1    | FlexSpin (6.1.1)       | Bytecode     | OK                    |
| P1        | SPIN1    | FlexSpin (6.1.1)       | Native/PASM  | OK                    |
| P2        | SPIN2    | FlexSpin (6.1.1)       | NuCode       | Not yet implemented   |
| P2        | SPIN2    | FlexSpin (6.1.1)       | Native/PASM2 | Not yet implemented   |

(other versions or toolchains not listed are not supported, and _may or may not_ work)


## Limitations

* Very early in development - may malfunction, or outright fail to build
* Doesn't support one-time programming interface
