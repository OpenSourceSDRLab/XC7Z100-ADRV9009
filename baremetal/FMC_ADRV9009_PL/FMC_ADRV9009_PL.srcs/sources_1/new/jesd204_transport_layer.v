module jesd204_transport_layer(
	input 	        rxclk         ,
	input 	        txclk         ,
	input 	        tx_samp_clk ,

//tx_data
	input 	[15:0]	tx1_idata     ,
	input 	[15:0]	tx1_qdata     ,
	input 	[15:0]	tx2_idata     ,
	input 	[15:0]	tx2_qdata     ,
	output	 [127:0]txdata        ,
	input 	 			  txready       ,
//orx_data
	output  reg [15:0]	orx1_idata    ,
	output  reg [15:0]	orx1_qdata    ,
	output  reg [15:0]	orx2_idata    ,
	output  reg [15:0]	orx2_qdata    ,
  input 	[63:0]  orxdata       ,
	input 				  orxvalid      ,
//rx_data
	output  reg [15:0]	rx1_idata     ,
	output  reg [15:0]	rx1_qdata     ,
	output  reg [15:0]	rx2_idata     ,
	output  reg [15:0]	rx2_qdata     ,
	input 	[63:0]	rxdata        ,
	input 				  rxvalid       
);


wire	[15:0]	 txlane0;
wire 	[15:0]	 txlane1;
wire	[15:0]	 txlane2;
wire 	[15:0]	 txlane3;
wire 			     tx_full;
wire 			     tx_empty;
wire 	[63:0]	 tx_samp_1;
wire	[63:0]	 tx_samp_2;
wire 	[63:0]	 rx_samp_1;
wire 	[63:0] 	 rx_samp_2;

wire 			rx_full;
wire 			rx_empty;

assign txlane0 = tx1_idata;
assign txlane1 = tx1_qdata;
assign txlane2 = tx2_idata;
assign txlane3 = tx2_qdata;

txdatafifo64to128 txdatafifo64to128_inst (
  .wr_clk(tx_samp_clk),                   // input wire wr_clk
  .rd_clk(txclk),                           // input wire rd_clk
  .din({txlane3,txlane2,txlane1,txlane0}),  // input wire [63 : 0] din
  .wr_en((~tx_full)&(txready==1'b1)),       // input wire wr_en
  .rd_en(~tx_empty),                        // input wire rd_en
  .dout({tx_samp_1,tx_samp_2}),             // output wire [127 : 0] dout
  .full(tx_full),                           // output wire full
  .empty(tx_empty)                          // output wire empty
);

assign txdata[31:0] = {tx_samp_2[7:0],tx_samp_2[15:8],tx_samp_1[7:0],tx_samp_1[15:8]};
assign txdata[63:32] = {tx_samp_2[23:16],tx_samp_2[31:24],tx_samp_1[23:16],tx_samp_1[31:24]};
assign txdata[95:64] = {tx_samp_2[39:32],tx_samp_2[47:40],tx_samp_1[39:32],tx_samp_1[47:40]};
assign txdata[127:96] = {tx_samp_2[55:48],tx_samp_2[63:56],tx_samp_1[55:48],tx_samp_1[63:56]};

//ML=44
// assign rx_samp_1[15:0] = {rxdata[7:0],rxdata[15:8]}; //i1
// assign rx_samp_2[15:0] = {rxdata[23:16],rxdata[31:24]};//i2
// assign rx_samp_1[31:16] = {rxdata[39:32],rxdata[47:40]};//Q1
// assign rx_samp_2[31:16] = {rxdata[55:48],rxdata[63:56]};//Q2
// assign rx_samp_1[47:32] = {rxdata[71:64],rxdata[79:72]};//c2 i1
// assign rx_samp_2[47:32] = {rxdata[87:80],rxdata[95:88]};//c2 i2
// assign rx_samp_1[63:48] = {rxdata[103:96],rxdata[111:104]};//c2 q1
// assign rx_samp_2[63:48] = {rxdata[119:112],rxdata[127:120]};//c2 q2

// rxdatafifo128to64 rxdatafifo128to64_inst (
//   .wr_clk(rxclk),  // input wire wr_clk
//   .rd_clk(txrx_samp_clk),  // input wire rd_clk
//   .din({rx_samp_1,rx_samp_2}),        // input wire [127 : 0] din
//   .wr_en(rxvalid),    // input wire wr_en
//   .rd_en(~rx_empty),    // input wire rd_en
//   .dout({rx2_qdata,rx2_idata,rx1_qdata,rx1_idata}),      // output wire [63 : 0] dout
//   .full(rx_full),      // output wire full
//   .empty(rx_empty)    // output wire empty
// );

//ML=42

//jesd204_transport_layer demapper
always @(posedge rxclk)
if(rxvalid)
  begin
    rx1_idata <= {rxdata[ 7: 0],rxdata[15: 8]};
    rx1_qdata <= {rxdata[23:16],rxdata[31:24]};
    rx2_idata <= {rxdata[39:32],rxdata[47:40]};
    rx2_qdata <= {rxdata[55:48],rxdata[63:56]};
  end
else
  begin
    rx1_idata <=16'd0;
    rx1_qdata <=16'd0;
    rx2_idata <=16'd0;
    rx2_qdata <=16'd0;
  end


always @(posedge rxclk)
if(orxvalid)
  begin
    orx1_idata <= {orxdata[ 7: 0],orxdata[15: 8]};
    orx1_qdata <= {orxdata[23:16],orxdata[31:24]};
    orx2_idata <= {orxdata[39:32],orxdata[47:40]};
    orx2_qdata <= {orxdata[55:48],orxdata[63:56]};
  end
else
  begin
    orx1_idata <=16'd0;
    orx1_qdata <=16'd0;
    orx2_idata <=16'd0;
    orx2_qdata <=16'd0;
  end

endmodule
