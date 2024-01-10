//`timescale 1ns

module tb_fir_fm4 ();

   wire CLK_i;
   wire RST_n_i;
   wire [13:0] DIN_i;
   wire VIN_i;
   wire [13:0] B0_i;
   wire [13:0] B1_i;
   wire [13:0] B2_i;
   wire [13:0] A1_i;
   wire [13:0] A2_i;   
   wire [13:0] DOUT_i;
   wire VOUT_i;
   wire END_SIM_i;

   clk_gen_fm4 CG(.END_SIM(END_SIM_i),
  	      .CLK(CLK_i),
	      .RST_n(RST_n_i));

   data_maker_new SM(.CLK(CLK_i),
	         .RST_n(RST_n_i),
		 .VOUT(VIN_i),
		 .DOUT(DIN_i),
		 .B0(B0_i),
		 .B1(B1_i),
		 .B2(B2_i),
		 .A1(A1_i),
		 .A2(A2_i),
		 .END_SIM(END_SIM_i));

   myIIR2 UUT(.CLK(CLK_i),
	     .RST_n(RST_n_i),
	     .DIN(DIN_i),
         .VIN(VIN_i),
	     .b0(B0_i),
	     .b1(B1_i),
	     .b2(B2_i),
		 .a1(A1_i),
		 .a2(A2_i),
         .DOUT(DOUT_i),
         .VOUT(VOUT_i));

   data_sink_fm4 DS(.CLK(CLK_i),
		.RST_n(RST_n_i),
		.VIN(VOUT_i),
		.DIN(DOUT_i));   

endmodule

		   
