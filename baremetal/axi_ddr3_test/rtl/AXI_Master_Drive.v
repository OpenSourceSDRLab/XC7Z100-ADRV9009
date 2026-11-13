`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/12 19:13:48
// Design Name: 
// Module Name: AXI_Master_Drive
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module AXI_Master_Drive(
    input                   aclk                   ,
    input                   aresetn                ,
    input                   i_init_calib_complete   ,
    output reg    [3 :0]    M_AXI_AWID              ,
    output reg    [29:0]	M_AXI_AWADDR            ,
    output reg    [7 :0]	M_AXI_AWLEN             ,
    output reg    [2 :0]	M_AXI_AWSIZE            ,           
    output reg    [1 :0]	M_AXI_AWBURST           ,           
    output reg    [0 :0]	M_AXI_AWLOCK            ,              
    output reg    [3 :0]	M_AXI_AWCACHE           ,          
    output reg    [2 :0]	M_AXI_AWPROT            ,                  
    output reg    [3 :0]	M_AXI_AWQOS             ,         
    output reg              M_AXI_AWVALID           ,                 
    input 			        M_AXI_AWREADY           ,   
    output reg    [255:0]	M_AXI_WDATA             ,                 
    output reg    [31:0]	M_AXI_WSTRB             ,             
    output reg    			M_AXI_WLAST             ,       
    output reg    			M_AXI_WVALID            ,   
    input			        M_AXI_WREADY            ,  
    input [3 :0]			M_AXI_BID               ,       
    input [1 :0]			M_AXI_BRESP             ,   
    input			        M_AXI_BVALID            ,       
    output	reg      		M_AXI_BREADY            ,  
    output  reg	  [3 :0]	M_AXI_ARID              ,       
    output  reg	  [29:0]	M_AXI_ARADDR            ,   
    output  reg	  [7 :0]	M_AXI_ARLEN             ,
    output  reg	  [2 :0]	M_AXI_ARSIZE            ,   
    output  reg	  [1 :0]	M_AXI_ARBURST           ,       
    output  reg	  [0 :0]	M_AXI_ARLOCK            ,       
    output  reg	  [3 :0]	M_AXI_ARCACHE           ,       
    output  reg	  [2 :0]	M_AXI_ARPROT            ,       
    output  reg	  [3 :0]	M_AXI_ARQOS             ,   
    output	reg      		M_AXI_ARVALID           ,   
    input			        M_AXI_ARREADY           ,  
    input [3 :0]			M_AXI_RID               ,       
    input [255:0]			M_AXI_RDATA             ,       
    input [1 :0]			M_AXI_RRESP             ,       
    input			        M_AXI_RLAST             ,       
    input			        M_AXI_RVALID            ,       
    output			   reg  M_AXI_RREADY                      
);


localparam                  P_ST_INIT   =   0   ,
                            P_ST_IDLE   =   1   ,
                            P_ST_WRITE  =   2   ,
                            P_ST_READ   =   3   ;

localparam                  P_LEN       =   256  ;

reg  [7 :0]                 r_st_current        ;
reg  [7 :0]                 r_st_next           ;
reg  [15:0]                 r_st_cnt            ;

reg  [15:0]                 r_read_cnt;

wire                        w_aw_act            ;
wire                        w_w_act             ;
wire                        w_br_act            ;
wire                        w_ar_act            ;
wire                        w_r_act             ;

assign w_aw_act      = M_AXI_AWVALID & M_AXI_AWREADY   ;
assign w_w_act       = M_AXI_WVALID  & M_AXI_WREADY    ;
assign w_br_act      = M_AXI_BVALID  & M_AXI_BREADY    ;
assign w_ar_act      = M_AXI_ARVALID & M_AXI_ARREADY   ;
assign w_r_act       = M_AXI_RVALID  & M_AXI_RREADY    ;


always@(posedge aclk)
begin
    if(!aresetn)
        r_st_current <= P_ST_IDLE;
    else
        r_st_current <= r_st_next;    
end


always@(*)
begin
    case(r_st_current)
        P_ST_INIT   : r_st_next <= i_init_calib_complete ? P_ST_IDLE : P_ST_INIT;
        P_ST_IDLE   : r_st_next <= P_ST_WRITE;
        P_ST_WRITE  : r_st_next <= w_br_act     ? P_ST_READ : P_ST_WRITE;
        P_ST_READ   : r_st_next <= r_read_cnt == P_LEN - 1 && w_r_act  ? P_ST_IDLE : P_ST_READ;
        default     : r_st_next <= P_ST_IDLE;
    endcase
end

always@(posedge aclk)
begin
    if(!aresetn)
        r_st_cnt <= 'd0;
    else if(r_st_current != r_st_next)
        r_st_cnt <= 'd0;
    else 
        r_st_cnt <= r_st_cnt + 1;
end

always@(posedge aclk)
begin
    if(!aresetn) begin
        M_AXI_AWID       <= 'd0;
        M_AXI_AWADDR     <= 'd0;
        M_AXI_AWLEN      <= 'd0;
        M_AXI_AWSIZE     <= 'd0;
        M_AXI_AWBURST    <= 'd0;
        M_AXI_AWLOCK     <= 'd0;
        M_AXI_AWCACHE    <= 'd0;
        M_AXI_AWPROT     <= 'd0;
        M_AXI_AWQOS      <= 'd0;
        M_AXI_AWVALID    <= 'd0;
    end else if(w_aw_act) begin
        M_AXI_AWID       <= 'd0;
        M_AXI_AWADDR     <= 'd0;
        M_AXI_AWLEN      <= 'd0;
        M_AXI_AWSIZE     <= 'd0;
        M_AXI_AWBURST    <= 'd0;
        M_AXI_AWLOCK     <= 'd0;
        M_AXI_AWCACHE    <= 'd0;
        M_AXI_AWPROT     <= 'd0;
        M_AXI_AWQOS      <= 'd0;
        M_AXI_AWVALID    <= 'd0;
    end else if(r_st_current == P_ST_WRITE && r_st_cnt == 0) begin
        M_AXI_AWID       <= 'd0;
        M_AXI_AWADDR     <= 'd0;
        M_AXI_AWLEN      <= P_LEN - 1;
        M_AXI_AWSIZE     <= 3'b101;
        M_AXI_AWBURST    <= 'd1;
        M_AXI_AWLOCK     <= 'd0;
        M_AXI_AWCACHE    <= 4'b0010;
        M_AXI_AWPROT     <= 'd0;
        M_AXI_AWQOS      <= 'd0;
        M_AXI_AWVALID    <= 'd1;
    end 
end

always@(posedge aclk)
begin
    if(!aresetn)
        M_AXI_WDATA <= 'd0;
    else if(M_AXI_WDATA == P_LEN - 1 && w_w_act)
        M_AXI_WDATA <= 'd0;
    else if(w_w_act)
        M_AXI_WDATA <= M_AXI_WDATA + 1;
    else 
        M_AXI_WDATA <= M_AXI_WDATA;
end

always@(posedge aclk)
begin
    if(!aresetn)
        M_AXI_WVALID <= 'd0;
    else if(M_AXI_WDATA == P_LEN - 1 && w_w_act)
        M_AXI_WVALID <= 'd0;
    else if(w_aw_act)       
        M_AXI_WVALID <= 'd1;
    else 
        M_AXI_WVALID <= M_AXI_WVALID;
end

always@(posedge aclk)
begin
    if(!aresetn)
        M_AXI_WLAST <= 'd0;
    else if(M_AXI_WDATA == P_LEN - 1 && w_w_act)
        M_AXI_WLAST <= 'd0;
    else if(M_AXI_WDATA == P_LEN - 2)   
        M_AXI_WLAST <= 'd1;
    else 
        M_AXI_WLAST <= M_AXI_WLAST;
end

always@(*)
begin
    M_AXI_WSTRB = 32'hffffffff;
end

always@(posedge aclk)
begin
    if(!aresetn)
        M_AXI_BREADY <= 'd0;
    else if(w_br_act)
        M_AXI_BREADY <= 'd0;
    else if(M_AXI_WLAST)
        M_AXI_BREADY <= 'd1;
    else 
        M_AXI_BREADY <= M_AXI_BREADY;
end

always@(posedge aclk)
begin
    if(!aresetn) begin
        M_AXI_ARID     <= 'd0;
        M_AXI_ARADDR   <= 'd0;
        M_AXI_ARLEN    <= 'd0;
        M_AXI_ARSIZE   <= 'd0;
        M_AXI_ARBURST  <= 'd0;
        M_AXI_ARLOCK   <= 'd0;
        M_AXI_ARCACHE  <= 'd0;
        M_AXI_ARPROT   <= 'd0;
        M_AXI_ARQOS    <= 'd0;
        M_AXI_ARVALID  <= 'd0;
    end else if(w_ar_act) begin
        M_AXI_ARID     <= 'd0;
        M_AXI_ARADDR   <= 'd0;
        M_AXI_ARLEN    <= 'd0;
        M_AXI_ARSIZE   <= 'd0;
        M_AXI_ARBURST  <= 'd0;
        M_AXI_ARLOCK   <= 'd0;
        M_AXI_ARCACHE  <= 'd0;
        M_AXI_ARPROT   <= 'd0;
        M_AXI_ARQOS    <= 'd0;
        M_AXI_ARVALID  <= 'd0;
    end else if(r_st_current == P_ST_READ && r_st_cnt == 0) begin
        M_AXI_ARID     <= 'd0;
        M_AXI_ARADDR   <= 'd0;
        M_AXI_ARLEN    <= P_LEN - 1;
        M_AXI_ARSIZE   <= 3'b101;
        M_AXI_ARBURST  <= 'd1;
        M_AXI_ARLOCK   <= 'd0;
        M_AXI_ARCACHE  <= 4'b0010;
        M_AXI_ARPROT   <= 'd0;
        M_AXI_ARQOS    <= 'd0;
        M_AXI_ARVALID  <= 'd1;
    end 
end

always@(posedge aclk)
begin
    if(!aresetn)
        M_AXI_RREADY <= 'd0;
    else if(r_read_cnt == P_LEN - 1 && w_r_act)
        M_AXI_RREADY <= 'd0;
    else if(w_ar_act)
        M_AXI_RREADY <= 'd1;
    else 
        M_AXI_RREADY <= M_AXI_RREADY;
end


always@(posedge aclk)
begin
    if(!aresetn)
        r_read_cnt <= 'd0;
    else if(r_read_cnt == P_LEN - 1 && w_r_act)
        r_read_cnt <= 'd0;
    else if(w_r_act)
        r_read_cnt <= r_read_cnt + 1;
    else 
        r_read_cnt <= r_read_cnt;
end
endmodule
