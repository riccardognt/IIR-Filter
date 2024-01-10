//`timescale 1ns b0, b1a1b0, b2a1b1, a1b2, a1a2, a12a2

module tb_fir ();

   wire CLK_i;
   wire RST_n_i;
   wire [13:0] DIN_i;
   wire VIN_i;
   wire [13:0] B0_i;
   wire [13:0] B1_i;
   wire [13:0] B2_i;
   wire [13:0] B3_i;
   wire [13:0] A2_i;
   wire [13:0] A3_i;   
   wire [13:0] DOUT_i;
   wire VOUT_i;
   wire END_SIM_i;

   clk_gen CG(.END_SIM(END_SIM_i),
  	      .CLK(CLK_i),
	      .RST_n(RST_n_i));

   data_maker SM(.CLK(CLK_i),
	     .RST_n(RST_n_i),
		 .VOUT(VIN_i),
		 .DOUT(DIN_i),
		 .B0(B0_i),
		 .B1(B1_i),
		 .B2(B2_i),
		 .B3(B3_i),
		 .A2(A2_i),
		 .A3(A3_i),
		 .END_SIM(END_SIM_i));

   myIIR2 UUT(.CLK(CLK_i),
	     .RST_n(RST_n_i),
	     .DIN(DIN_i),
         .VIN(VIN_i),
	     .b0(B0_i),
		 .b1(B1_i),
		 .b2(B2_i),
		 .b3(B3_i),
		 .a2(A2_i),
		 .a3(A3_i),
         .DOUT(DOUT_i),
         .VOUT(VOUT_i));

   data_sink DS(.CLK(CLK_i),
		.RST_n(RST_n_i),
		.VIN(VOUT_i),
		.DIN(DOUT_i));   

endmodule

		   
