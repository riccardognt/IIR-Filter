# Design and implementation of an IIR Filter
The main goal of the project is to design an IIR filter with these specifications:
- Order N = 2
- Number of bits nb = 14
- Cut-off frequency fc = 2KHz
- Sampling frequency of the samples to process fs = 10 kHz
- Maximum Total Harmonic Distortion THD = -30 dB

The entire project is divided in 3 Assignments each one covers a different part of the implementation process.

## Assignment 1: Reference model development
In this section the coefficients for the second order filter have been calculated through a simple Matlab code. More in detail Matlab calculates these coefficients first with a floating point arithmetic, then a quantization step has been performed to prepare these coefficients to be implemented in a digital design working in fixed point.
After that a fixed point model has been developed as a C program, reducing the precision of the multiplications for reaching a maximum THD (Total Harmonic Distortion) of -30 dB.

## Assignment 2: VLSI implementation
## Assignment 3: Advanced architecture development
