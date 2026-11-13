`timescale 1ns / 1ps
module axi_lite_drv(
//global
input             axi_gp_clk,
input             axi_rst_n,
  // AXI Lite Master Interface connections
input               up_wreq,
input  [15:0]       up_waddr,
input  [31:0]       up_wdata,
output reg          up_wack,
 
input               up_rreq,
input  [15:0]       up_raddr,
output reg  [31:0]  up_rdata,
output reg          up_rack,
//register out
output reg          mtime_start,
output reg [11:0]   phase,
output reg [3:0]    rf_mode,
output reg          jesd204_reset,

input  [14:0]       rf1_gpio_i,
output reg [14:0]   rf1_gpio_o,
output reg [14:0]   rf1_gpio_t,
//register in
input  [31:0]       sdr_info,
output reg          config_done
);
// Register Interface
always @(posedge axi_gp_clk) begin
  if (axi_rst_n == 1'b0) begin
    up_wack <= 1'b0;
  end else begin
    up_wack <= up_wreq;
  end
end    
     
always @(posedge axi_gp_clk) begin
  if (axi_rst_n == 1'b0) begin
    up_rack <= 'd0;
  end else begin
    up_rack <= up_rreq;
  end
end

//write register
always @ (posedge axi_gp_clk or negedge axi_rst_n)
if(!axi_rst_n)
  begin
    mtime_start<=1'b0;
    phase<=12'd128;
    rf_mode<=4'd0;
    jesd204_reset<=1'b1;
    config_done<=1'b0;
    rf1_gpio_t<=15'hefff;//input
    rf1_gpio_o<=15'd0;    
  end
else if(up_wreq)
  begin
    case(up_waddr[15:2])
      7'd1 :mtime_start   <=up_wdata[0];
      7'd2 :jesd204_reset <=up_wdata[0];
      7'd3 :phase         <=up_wdata[11:0];
      7'd8 :rf_mode       <=up_wdata[3:0];
      7'd9 :config_done   <=up_wdata[0];
      7'd73:rf1_gpio_t    <=up_wdata[14:0];
      7'd75:rf1_gpio_o    <=up_wdata[14:0];
    endcase
  end
else
  begin end
  
//read register

always @ (posedge axi_gp_clk or negedge axi_rst_n)
  if(!axi_rst_n) begin
      up_rdata<=32'd0;
  end else if(up_rreq)
    begin
      case(up_raddr[15:2])
        7'd0    : up_rdata <= sdr_info;
        7'd1    : up_rdata <= mtime_start;
        7'd2    : up_rdata <= jesd204_reset;
        7'd3    : up_rdata <= phase;
        7'd8    : up_rdata <= rf_mode;
        7'd73   : up_rdata <= rf1_gpio_t;
        7'd75   : up_rdata <= rf1_gpio_i;      
        default : up_rdata <= 32'haabbccdd;
      endcase
    end
  else 
     up_rdata <= up_rdata;
      
endmodule