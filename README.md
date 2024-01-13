# Important Notes
This is a team project for the course of Integrated System Architecture held in the Electronic Engineering Master's degree program of Politecnico di Torino.
The project was not originally developed making use of GitHub, it has been uploaded by myself subsequently.
For a better understanding of the code, the design flow and the conclusions the reader can have a look to the IIR_design.pdf report.
Many thanks to my colleagues Othman and Roberto for their contribution to this project.

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
In this section the architecture of the IIR filter has been developed in VHDL by placing the proper number of registers, adders, multipliers and logic then the results obtained through the Questasim simulation of the architecture have been compared with the ones of the C model to check their equality.
Furthermore the architecture has been synthetized using Synopsys Design Compiler at different clock frequencies (maximum clock frequency Fmax and Fmax/4) in order to appreciate the differences in terms of occupied area and amount of time to complete the simulation then at Fmax/4 the switching activity has been computed in order to estimate the power consumption.
As a final step the Place&Route of the design has been performed making use of Cadence Innovus.

## Assignment 3: Advanced architecture development
In this last section the previous model and architecture have been changed in order to implement the J-look-ahead technique which in practice adds new components to the architecture allowing the designer to use retiming and pipelining to further optimize the throughput
