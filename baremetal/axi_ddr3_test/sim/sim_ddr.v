`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/17 23:07:26
// Design Name: 
// Module Name: sim_ddr
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


module sim_ddr();
reg clk,clk_p,rst;
initial begin
    clk = 0;
    clk_p = 1;
    rst = 1;
    #1000;
    rst = 0;
end
always #5 clk = ~clk;
assign clk_p = ~clk;
wire w_user_clk;
wire w_user_rst;
wire w_mmcm_locked;      
wire init_calib_complete;
wire [3:0]			s_axi_awid                  ; 
wire [29:0]			s_axi_awaddr                ;     
wire [7:0]			s_axi_awlen                 ;     
wire [2:0]			s_axi_awsize                ;     
wire [1:0]			s_axi_awburst               ;     
wire [0:0]			s_axi_awlock                ;     
wire [3:0]			s_axi_awcache               ;     
wire [2:0]			s_axi_awprot                ;         
wire [3:0]			s_axi_awqos                 ; 
wire 			    s_axi_awvalid               ; 
wire 			    s_axi_awready               ;     
wire [63:0]			s_axi_wdata ;    
wire [31:0]			s_axi_wstrb     ;        
wire 			s_axi_wlast         ;    
wire 			s_axi_wvalid        ;        
wire 			s_axi_wready        ;        
wire  [3:0]			s_axi_bid       ;    
wire  [1:0]			s_axi_bresp     ;    
wire 			s_axi_bvalid        ;    
wire 			s_axi_bready        ;    
wire [3:0]			s_axi_arid      ;    
wire [29:0]			s_axi_araddr    ;        
wire [7:0]			s_axi_arlen     ;    
wire [2:0]			s_axi_arsize    ;    
wire [1:0]			s_axi_arburst   ;        
wire [0:0]			s_axi_arlock    ;        
wire [3:0]			s_axi_arcache   ;    
wire [2:0]			s_axi_arprot    ;        
wire [3:0]			s_axi_arqos     ;    
wire 			s_axi_arvalid       ;    
wire 			s_axi_arready       ;    
wire  [3:0]			s_axi_rid       ;    
wire  [63:0]			s_axi_rdata ;    
wire  [1:0]			s_axi_rresp     ;        
wire 			s_axi_rlast         ;    
wire 			s_axi_rvalid        ;    
wire 			s_axi_rready        ;   


AXI_Master_Drive AXI_Master_Drive_u0(
    .i_clk                          (w_user_clk                 ),
    .i_rst                          (rst                       ),
    .i_init_calib_complete          (init_calib_complete        ),
    .m_axi_awid                     (s_axi_awid                 ),
    .m_axi_awaddr                   (s_axi_awaddr               ),
    .m_axi_awlen                    (s_axi_awlen                ),
    .m_axi_awsize                   (s_axi_awsize               ),           
    .m_axi_awburst                  (s_axi_awburst              ),           
    .m_axi_awlock                   (s_axi_awlock               ),              
    .m_axi_awcache                  (s_axi_awcache              ),          
    .m_axi_awprot                   (s_axi_awprot               ),                  
    .m_axi_awqos                    (s_axi_awqos                ),         
    .m_axi_awvalid                  (s_axi_awvalid              ),                 
    .m_axi_awready                  (s_axi_awready              ),   
    .m_axi_wdata                    (s_axi_wdata                ),                 
    .m_axi_wstrb                    (s_axi_wstrb                ),             
    .m_axi_wlast                    (s_axi_wlast                ),       
    .m_axi_wvalid                   (s_axi_wvalid               ),   
    .m_axi_wready                   (s_axi_wready               ),  
    .m_axi_bid                      (s_axi_bid                  ),       
    .m_axi_bresp                    (s_axi_bresp                ),   
    .m_axi_bvalid                   (s_axi_bvalid               ),       
    .m_axi_bready                   (s_axi_bready               ),  
    .m_axi_arid                     (s_axi_arid                 ),       
    .m_axi_araddr                   (s_axi_araddr               ),   
    .m_axi_arlen                    (s_axi_arlen                ),
    .m_axi_arsize                   (s_axi_arsize               ),   
    .m_axi_arburst                  (s_axi_arburst              ),       
    .m_axi_arlock                   (s_axi_arlock               ),       
    .m_axi_arcache                  (s_axi_arcache              ),       
    .m_axi_arprot                   (s_axi_arprot               ),       
    .m_axi_arqos                    (s_axi_arqos                ),   
    .m_axi_arvalid                  (s_axi_arvalid              ),   
    .m_axi_arready                  (s_axi_arready              ),  
    .m_axi_rid                      (s_axi_rid                  ),       
    .m_axi_rdata                    (s_axi_rdata                ),       
    .m_axi_rresp                    (s_axi_rresp                ),       
    .m_axi_rlast                    (s_axi_rlast                ),       
    .m_axi_rvalid                   (s_axi_rvalid               ),       
    .m_axi_rready                   (s_axi_rready               )           
);

mig_7series_0 u_mig_7series_0 (
.ddr3_addr                      (ddr3_addr                  ),  // output [14:0]		ddr3_addr
.ddr3_ba                        (ddr3_ba                    ),  // output [2:0]		ddr3_ba
.ddr3_cas_n                     (ddr3_cas_n                 ),  // output			ddr3_cas_n
.ddr3_ck_n                      (ddr3_ck_n                  ),  // output [0:0]		ddr3_ck_n
.ddr3_ck_p                      (ddr3_ck_p                  ),  // output [0:0]		ddr3_ck_p
.ddr3_cke                       (ddr3_cke                   ),  // output [0:0]		ddr3_cke
.ddr3_ras_n                     (ddr3_ras_n                 ),  // output			ddr3_ras_n
.ddr3_reset_n                   (ddr3_reset_n               ),  // output			ddr3_reset_n
.ddr3_we_n                      (ddr3_we_n                  ),  // output			ddr3_we_n
.ddr3_dq                        (ddr3_dq                    ),  // inout [31:0]		ddr3_dq
.ddr3_dqs_n                     (ddr3_dqs_n                 ),  // inout [3:0]		ddr3_dqs_n
.ddr3_dqs_p                     (ddr3_dqs_p                 ),  // inout [3:0]		ddr3_dqs_p
.ddr3_cs_n                      (ddr3_cs_n                  ),  // output [0:0]		ddr3_cs_n
.ddr3_dm                        (ddr3_dm                    ),  // output [3:0]		ddr3_dm
.ddr3_odt                       (ddr3_odt                   ),  // output [0:0]		ddr3_odt
.init_calib_complete            (init_calib_complete        ),  // output			init_calib_complete
.ui_clk                         (w_user_clk                 ),  // output			ui_clk
.ui_clk_sync_rst                (w_user_rst                 ),  // output			ui_clk_sync_rst
.mmcm_locked                    (w_mmcm_locked              ),  // output			mmcm_locked
.aresetn                        (~w_user_rst                ),  // input			aresetn
.app_sr_req                     (0                          ),  // input			app_sr_req
.app_ref_req                    (0                          ),  // input			app_ref_req
.app_zq_req                     (0                          ),  // input			app_zq_req
.app_sr_active                  (                           ),  // output			app_sr_active
.app_ref_ack                    (                           ),  // output			app_ref_ack
.app_zq_ack                     (                           ),  // output			app_zq_ack
.s_axi_awid                     (s_axi_awid                 ),  // input [3:0]			s_axi_awid
.s_axi_awaddr                   (s_axi_awaddr               ),  // input [29:0]			s_axi_awaddr
.s_axi_awlen                    (s_axi_awlen                ),  // input [7:0]			s_axi_awlen
.s_axi_awsize                   (s_axi_awsize               ),  // input [2:0]			s_axi_awsize
.s_axi_awburst                  (s_axi_awburst              ),  // input [1:0]			s_axi_awburst
.s_axi_awlock                   (s_axi_awlock               ),  // input [0:0]			s_axi_awlock
.s_axi_awcache                  (s_axi_awcache              ),  // input [3:0]			s_axi_awcache
.s_axi_awprot                   (s_axi_awprot               ),  // input [2:0]			s_axi_awprot
.s_axi_awqos                    (s_axi_awqos                ),  // input [3:0]			s_axi_awqos
.s_axi_awvalid                  (s_axi_awvalid              ),  // input			s_axi_awvalid
.s_axi_awready                  (s_axi_awready              ),  // output			s_axi_awready
.s_axi_wdata                    (s_axi_wdata                ),  // input [255:0]			s_axi_wdata
.s_axi_wstrb                    (s_axi_wstrb                ),  // input [31:0]			s_axi_wstrb
.s_axi_wlast                    (s_axi_wlast                ),  // input			s_axi_wlast
.s_axi_wvalid                   (s_axi_wvalid               ),  // input			s_axi_wvalid
.s_axi_wready                   (s_axi_wready               ),  // output			s_axi_wready
.s_axi_bid                      (s_axi_bid                  ),  // output [3:0]			s_axi_bid
.s_axi_bresp                    (s_axi_bresp                ),  // output [1:0]			s_axi_bresp
.s_axi_bvalid                   (s_axi_bvalid               ),  // output			s_axi_bvalid
.s_axi_bready                   (s_axi_bready               ),  // input			s_axi_bready
.s_axi_arid                     (s_axi_arid                 ),  // input [3:0]			s_axi_arid
.s_axi_araddr                   (s_axi_araddr               ),  // input [29:0]			s_axi_araddr
.s_axi_arlen                    (s_axi_arlen                ),  // input [7:0]			s_axi_arlen
.s_axi_arsize                   (s_axi_arsize               ),  // input [2:0]			s_axi_arsize
.s_axi_arburst                  (s_axi_arburst              ),  // input [1:0]			s_axi_arburst
.s_axi_arlock                   (s_axi_arlock               ),  // input [0:0]			s_axi_arlock
.s_axi_arcache                  (s_axi_arcache              ),  // input [3:0]			s_axi_arcache
.s_axi_arprot                   (s_axi_arprot               ),  // input [2:0]			s_axi_arprot
.s_axi_arqos                    (s_axi_arqos                ),  // input [3:0]			s_axi_arqos
.s_axi_arvalid                  (s_axi_arvalid              ),  // input			s_axi_arvalid
.s_axi_arready                  (s_axi_arready              ),  // output			s_axi_arready
.s_axi_rid                      (s_axi_rid                  ),  // output [3:0]			s_axi_rid
.s_axi_rdata                    (s_axi_rdata                ),  // output [255:0]			s_axi_rdata
.s_axi_rresp                    (s_axi_rresp                ),  // output [1:0]			s_axi_rresp
.s_axi_rlast                    (s_axi_rlast                ),  // output			s_axi_rlast
.s_axi_rvalid                   (s_axi_rvalid               ),  // output			s_axi_rvalid
.s_axi_rready                   (s_axi_rready               ),  // input			s_axi_rready
.sys_clk_p                      (clk_p               ),  // input				sys_clk_p
.sys_clk_n                      (clk               ),  // input				sys_clk_n
.sys_rst                        (0                      )   // input sys_rst

);
endmodule
