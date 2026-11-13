module ddr3_top(
    input               i_clk_200m_p    ,
    input               i_clk_200m_n    ,
    output [14:0]		ddr3_addr       ,
    output [2:0]		ddr3_ba         ,    
    output			    ddr3_cas_n      ,    
    output [0:0]		ddr3_ck_n       ,    
    output [0:0]		ddr3_ck_p       ,        
    output [0:0]		ddr3_cke        ,    
    output			    ddr3_ras_n      ,    
    output			    ddr3_reset_n    ,    
    output			    ddr3_we_n       ,    
    inout  [31:0]		ddr3_dq         ,
    inout  [3:0]		ddr3_dqs_n      ,    
    inout  [3:0]		ddr3_dqs_p      ,    
    output [0:0]		ddr3_cs_n       ,    
    output [3:0]		ddr3_dm         ,
    output [0:0]		ddr3_odt        ,
    input           i_rst           ,
    output              led 
);
    
wire w_user_clk;
wire w_user_rst;
wire w_mmcm_locked;      
wire init_calib_complete;
(* mark_debug = "true" *)wire [3:0]		   	s_axi_awid                    ; 
(* mark_debug = "true" *)wire [29:0]			s_axi_awaddr                  ;     
(* mark_debug = "true" *)wire [7:0]			  s_axi_awlen                   ;     
(* mark_debug = "true" *)wire [2:0]			  s_axi_awsize                  ;     
(* mark_debug = "true" *)wire [1:0]			  s_axi_awburst                 ;     
(* mark_debug = "true" *)wire [0:0]			  s_axi_awlock                  ;     
(* mark_debug = "true" *)wire [3:0]			  s_axi_awcache                 ;     
(* mark_debug = "true" *)wire [2:0]			  s_axi_awprot                  ;         
(* mark_debug = "true" *)wire [3:0]			  s_axi_awqos                   ; 
(* mark_debug = "true" *)wire 			      s_axi_awvalid                 ; 
(* mark_debug = "true" *)wire 			      s_axi_awready                 ;     
(* mark_debug = "true" *)wire [255:0]	    s_axi_wdata                   ;    
(* mark_debug = "true" *)wire [31:0]			s_axi_wstrb                   ;        
(* mark_debug = "true" *)wire 			      s_axi_wlast                   ;    
(* mark_debug = "true" *)wire 			      s_axi_wvalid                  ;        
(* mark_debug = "true" *)wire 			      s_axi_wready                  ;        
(* mark_debug = "true" *)wire  [3:0]			s_axi_bid                     ;    
(* mark_debug = "true" *)wire  [1:0]			s_axi_bresp                   ;    
(* mark_debug = "true" *)wire 			      s_axi_bvalid                  ;    
(* mark_debug = "true" *)wire 			      s_axi_bready                  ;    
(* mark_debug = "true" *)wire [3:0]		   	s_axi_arid                    ;    
(* mark_debug = "true" *)wire [29:0]			s_axi_araddr                  ;        
(* mark_debug = "true" *)wire [7:0]		    s_axi_arlen                   ;    
(* mark_debug = "true" *)wire [2:0]		    s_axi_arsize                  ;    
(* mark_debug = "true" *)wire [1:0]		    s_axi_arburst                 ;        
(* mark_debug = "true" *)wire [0:0]		    s_axi_arlock                  ;        
(* mark_debug = "true" *)wire [3:0]		    s_axi_arcache                 ;    
(* mark_debug = "true" *)wire [2:0]		    s_axi_arprot                  ;        
(* mark_debug = "true" *)wire [3:0]		    s_axi_arqos                   ;    
(* mark_debug = "true" *)wire 			      s_axi_arvalid               ;    
(* mark_debug = "true" *)wire 			      s_axi_arready               ;    
(* mark_debug = "true" *)wire  [3:0]			s_axi_rid                   ;    
(* mark_debug = "true" *)wire  [255:0]		s_axi_rdata                 ;    
(* mark_debug = "true" *)wire  [1:0]			s_axi_rresp                 ;        
(* mark_debug = "true" *)wire 			      s_axi_rlast                 ;    
(* mark_debug = "true" *)wire 			      s_axi_rvalid                ;    
(* mark_debug = "true" *)wire 			      s_axi_rready                ;   
wire            w_vio_rst                   ; 
assign    led = init_calib_complete;    



vio_0 vio_0 (
  .clk                              (w_user_clk                 ),                // input wire clk
  .probe_out0                       (w_vio_rst                  )  // output wire [0 : 0] probe_out0
);

AXI_Master_Drive AXI_Master_Drive_u0(
    .aclk                           (w_user_clk                 ),
    .aresetn                        (w_vio_rst                  ),
    .i_init_calib_complete          (init_calib_complete        ),
    .M_AXI_AWID                     (s_axi_awid                 ),
    .M_AXI_AWADDR                   (s_axi_awaddr               ),
    .M_AXI_AWLEN                    (s_axi_awlen                ),
    .M_AXI_AWSIZE                   (s_axi_awsize               ),           
    .M_AXI_AWBURST                  (s_axi_awburst              ),           
    .M_AXI_AWLOCK                   (s_axi_awlock               ),              
    .M_AXI_AWCACHE                  (s_axi_awcache              ),          
    .M_AXI_AWPROT                   (s_axi_awprot               ),                  
    .M_AXI_AWQOS                    (s_axi_awqos                ),         
    .M_AXI_AWVALID                  (s_axi_awvalid              ),                 
    .M_AXI_AWREADY                  (s_axi_awready              ),   
    .M_AXI_WDATA                    (s_axi_wdata                ),                 
    .M_AXI_WSTRB                    (s_axi_wstrb                ),             
    .M_AXI_WLAST                    (s_axi_wlast                ),       
    .M_AXI_WVALID                   (s_axi_wvalid               ),   
    .M_AXI_WREADY                   (s_axi_wready               ),  
    .M_AXI_BID                      (s_axi_bid                  ),       
    .M_AXI_BRESP                    (s_axi_bresp                ),   
    .M_AXI_BVALID                   (s_axi_bvalid               ),       
    .M_AXI_BREADY                   (s_axi_bready               ),  
    .M_AXI_ARID                     (s_axi_arid                 ),       
    .M_AXI_ARADDR                   (s_axi_araddr               ),   
    .M_AXI_ARLEN                    (s_axi_arlen                ),
    .M_AXI_ARSIZE                   (s_axi_arsize               ),   
    .M_AXI_ARBURST                  (s_axi_arburst              ),       
    .M_AXI_ARLOCK                   (s_axi_arlock               ),       
    .M_AXI_ARCACHE                  (s_axi_arcache              ),       
    .M_AXI_ARPROT                   (s_axi_arprot               ),       
    .M_AXI_ARQOS                    (s_axi_arqos                ),   
    .M_AXI_ARVALID                  (s_axi_arvalid              ),   
    .M_AXI_ARREADY                  (s_axi_arready              ),  
    .M_AXI_RID                      (s_axi_rid                  ),       
    .M_AXI_RDATA                    (s_axi_rdata                ),       
    .M_AXI_RRESP                    (s_axi_rresp                ),       
    .M_AXI_RLAST                    (s_axi_rlast                ),       
    .M_AXI_RVALID                   (s_axi_rvalid               ),       
    .M_AXI_RREADY                   (s_axi_rready               )           
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
.sys_clk_p                      (i_clk_200m_p               ),  // input				sys_clk_p
.sys_clk_n                      (i_clk_200m_n               ),  // input				sys_clk_n
.sys_rst                        ('b1                      )   // input sys_rst
);
endmodule //ddr3_top
