// -----------------------------------------------------------------------------
// Copyright (c) OpenSourceSDRLab
// https://www.opensourcesdrlab.com
// -----------------------------------------------------------------------------
// File   : tb_jesd204b_adc_dac_top.v
// Testbench for jesd204b_adc_dac_top
// -----------------------------------------------------------------------------
`timescale  1ns/1ps

module tb_jesd204b_adc_dac_top( );

reg fpga_gc_clk;
wire[3:0] rxn_in,rxp_in;
wire[3:0] txn_out,txp_out;
wire fpga_gc_clk_n,fpga_gc_clk_p;
wire cpll_refclk_n,cpll_refclk_p;
wire qpll_refclk_n,qpll_refclk_p;
reg  jesd204b_reset;
reg  sysref;
reg  axi_lite_clk;
reg  axi_lite_rstn;

assign rxp_in = txp_out;
assign rxn_in = txn_out;

initial begin 
	fpga_gc_clk =0;
end

always #4.069 fpga_gc_clk = ~fpga_gc_clk;

assign fpga_gc_clk_p = fpga_gc_clk;
assign fpga_gc_clk_n = ~fpga_gc_clk;

assign cpll_refclk_p = fpga_gc_clk;
assign cpll_refclk_n = ~fpga_gc_clk;

assign qpll_refclk_p = fpga_gc_clk;
assign qpll_refclk_n = ~fpga_gc_clk;

initial begin 
	jesd204b_reset = 1'b1;
	repeat(8000) @(posedge fpga_gc_clk);
	jesd204b_reset <= 1'b0;
end

initial begin 
	sysref =0;
	repeat(16000) @(posedge fpga_gc_clk);
	sysref <=1'b1;
	@(posedge fpga_gc_clk);
	@(posedge fpga_gc_clk);
	@(posedge fpga_gc_clk);
	sysref <= 1'b0;
end

initial begin 
	axi_lite_clk =0;
	axi_lite_rstn=0;
	repeat(1000) @(posedge axi_lite_clk);
	axi_lite_rstn <= 1'b1;
end

always #5 axi_lite_clk = ~axi_lite_clk;


jesd204b_adc_dac_top inst_jesd204b_adc_dac_top
	(
		.fpga_gc_clk_n  (fpga_gc_clk_n),
		.fpga_gc_clk_p  (fpga_gc_clk_p),
		.jesd204b_reset (jesd204b_reset),
		.sysref_p       (sysref),
		.sysref_n 		(~sysref),
		.rxn_in         (rxn_in),
		.rxp_in         (rxp_in),
		.txn_out        (txn_out),
		.txp_out        (txp_out),
		.cpll_refclk_n  (cpll_refclk_n),
		.cpll_refclk_p  (cpll_refclk_p),
		.qpll_refclk_n  (qpll_refclk_n),
		.qpll_refclk_p  (qpll_refclk_p),
		.axi_lite_clk 	(axi_lite_clk),
		.axi_lite_rstn 	(axi_lite_rstn)
	);

endmodule
