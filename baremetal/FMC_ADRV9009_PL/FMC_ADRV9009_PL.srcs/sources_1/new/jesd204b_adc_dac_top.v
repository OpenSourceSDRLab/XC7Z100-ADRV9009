`timescale  1ns/1ps
`timescale 1ns / 1ps

module jesd204b_adc_dac_top
(
  input                   sysref_p,         //SYSREF from AD9528 clock chip to FPGA (P)  
  input                   sysref_n,         //SYSREF from AD9528 clock chip to FPGA (N)   
  input 	                cpll_refclk_n,    //transceiver reference clock, differential input       
  input 	                cpll_refclk_p,    //transceiver reference clock, differential input           

  input                   tx_sync_p,        //SYNC signal (P)     AK17
  input                   tx_sync_n,        //SYNC signal (N)     AK18
  output                  rx_sync_p,        //SYNC signal (P)     AH19
  output                  rx_sync_n,        //SYNC signal (N)     AJ19

  output                  orx_sync_p,       //SYNC signal (P)     T29
  output                  orx_sync_n,       //SYNC signal (N)     U29

  input	        [3:0]	    rxn_in,
  input         [3:0]	    rxp_in,
  output 	      [3:0]	    txn_out,
  output 	      [3:0]	    txp_out,

  output                  spi0_clk,          //SPI clock          
  input                   spi0_miso,         //9009---->FPGA    
  output                  spi0_mosi,         //FPGA---->9009     
  output                  spi0_cs_9009,      //ADRV9009 chip select       
  output                  spi0_cs_9528,      //AD9528 chip select       

  inout                   ad9528_reset_b,
  inout                   ad9528_sysref_req,
  inout                   adrv9009_tx1_enable,
  inout                   adrv9009_tx2_enable,
  inout                   adrv9009_rx1_enable,
  inout                   adrv9009_rx2_enable,
  inout                   adrv9009_test,
  inout                   adrv9009_reset_b,
  inout                   adrv9009_gpint
);

//clock
wire            cpll_refclk;
wire            txoutclk;
wire            tx_samp_clk;
wire            rx_samp_clk;
wire            fpga_gc_clk;


//sync
wire            tx_sync;
wire            rx_sync;
wire            orx_sync;
wire            orx_en;
wire            sysref;

//valid
wire            rx_tvalid;
wire            orx_tvalid;

//rx_data
wire  [63:0]    rx_tdata;
wire  [63:0]    orx_tdata;
wire  [15:0]		orx1_idata;
wire  [15:0]		orx1_qdata;
wire  [15:0]		orx2_idata;
wire  [15:0]		orx2_qdata;
wire  [15:0]		rx1_idata;
wire  [15:0]		rx1_qdata;
wire  [15:0]		rx2_idata;
wire  [15:0]		rx2_qdata;

//tx_data
wire            tx_tready;
wire  [127:0]   tx_tdata;
wire  [15:0]		tx1_idata;
wire  [15:0]		tx1_qdata;
wire  [15:0]		tx2_idata;
wire  [15:0]		tx2_qdata;

//gpio
wire  [18:0]    rf1_gpio_t;
wire  [18:0]    rf1_gpio_i;
wire  [18:0]    rf1_gpio_o;
wire  [63:0]    GPIO_O;
wire  [63:0]    GPIO_I;
wire  [63:0]    GPIO_T;

//sys
wire            fclk_resetn;
wire            fclk_100m;
wire            jesd204b_reset;

//axi lite
wire            up_rack;
wire [15:0]     up_raddr;
wire [31:0]     up_rdata;
wire            up_rreq;
wire            up_wack;
wire [15:0]     up_waddr;
wire [31:0]     up_wdata;
wire            up_wreq;


////////////////////////////////single-ended / differential conversion/////////////////////////////////////////////////////
 IBUFDS i_ibufds_tx_sync        
 (           
    .I  (tx_sync_p  ),
    .IB (tx_sync_n  ),
    .O  (tx_sync    )
 );
    
  OBUFDS i_obufds_rx_sync       
  (        
    .I  (rx_sync    ),
    .O  (rx_sync_p  ),
    .OB (rx_sync_n  )
  );  

  OBUFDS i_obufds_orx_sync         
  (        
    .I  (orx_sync   ),
    .O  (orx_sync_p ),
    .OB (orx_sync_n )
  );  

  //gc_clk is a copy of REF_CLK
  BUFG i_bufg_ref_clk (
    .I      (cpll_refclk    ),
    .O      (fpga_gc_clk    )
  );

  IBUFDS_GTE2 i_ibufds_ref_clk2 (
    .CEB  (1'b0             ),
    .I    (cpll_refclk_p    ),
    .IB   (cpll_refclk_n    ),
    .O    (cpll_refclk      )
  );
  
  IBUFDS i_ibufds_sysref (
    .I    (sysref_p     ),
    .IB   (sysref_n     ),
    .O    (sysref       )
  );


 ad_iobuf #(.DATA_WIDTH(9)) i_iobuf (
    .dio_t ({GPIO_T[8:0]}),
    .dio_i ({GPIO_O[8:0]}),
    .dio_o ({GPIO_I[8:0]}),
    .dio_p ({ ad9528_reset_b,       // 8
              ad9528_sysref_req,    // 7
              adrv9009_tx1_enable,  // 6
              adrv9009_tx2_enable,  // 5
              adrv9009_rx1_enable,  // 4
              adrv9009_rx2_enable,  // 3
              adrv9009_test,        // 2
              adrv9009_reset_b,     // 1
              adrv9009_gpint       // 0
              })); 

design_1_wrapper    design_1_wrapper_u
(     
    .GPIO_I                 (GPIO_I),      
    .GPIO_O                 (GPIO_O),      
    .GPIO_T                 (GPIO_T),      
    .SPI0_MISO_I            (spi0_miso),      
    .SPI0_MOSI_O            (spi0_mosi),      
    .SPI0_SCLK_O            (spi0_clk),      
    .SPI0_SS1_O             (spi0_cs_9009),      
    .SPI0_SS_O              (spi0_cs_9528),          
    .fclk_100m              (fclk_100m),      
    .fclk_resetn            (fclk_resetn),      
    .fpga_gc_clk            (fpga_gc_clk),     
    .jesd204b_reset         (jesd204b_reset),      
    .qpll_refclk            (cpll_refclk),   
    .rx_sync                (rx_sync),      
    .rx_tdata               (rx_tdata),      
    .rx_tvalid              (rx_tvalid), 
    .orx_sync               (orx_sync),      
    .orx_tdata              (orx_tdata),      
    .orx_tvalid             (orx_tvalid),     
    .rxn_in                 (rxn_in),      
    .rx_samp_clk            (rx_samp_clk),      
    .rxp_in                 (rxp_in),      
    .sysref                 (sysref), 
    .tx_sync                (tx_sync),     
    .tx_tdata               (tx_tdata),      
    .tx_tready              (tx_tready),      
    .txn_out                (txn_out),    

    .txoutclk               (txoutclk),     
    .txp_out                (txp_out),      
    .tx_samp_clk            (tx_samp_clk),      
    .up_rack                (up_rack),     
    .up_raddr               (up_raddr),      
    .up_rdata               (up_rdata),      
    .up_rreq                (up_rreq),      
    .up_wack                (up_wack),      
    .up_waddr               (up_waddr),      
    .up_wdata               (up_wdata),      
    .up_wreq                (up_wreq)
);                     


  axi_lite_drv axi_lite_drv(
    .axi_gp_clk       (fclk_100m      ),//global
    .axi_rst_n        (fclk_resetn  ),
    
    .up_rack          (up_rack),
    .up_raddr         (up_raddr),
    .up_rdata         (up_rdata),
    .up_rreq          (up_rreq),
    .up_wack          (up_wack),
    .up_waddr         (up_waddr),
    .up_wdata         (up_wdata),
    .up_wreq          (up_wreq),
    
    .mtime_start      (        ),//register out
    .phase            (        ),
    .rf_mode          (        ),
    .jesd204_reset    (jesd204b_reset  ),
    .rf1_gpio_t       (         ),
    .rf1_gpio_o       (         ),
    .rf1_gpio_i       (         ),
    .sdr_info         (         ),//register in
    .config_done      (         )
  );



jesd204_transport_layer   jesd204_transport_layer_u
(
	.rxclk         (rx_samp_clk),
	.txclk         (txoutclk),
	.tx_samp_clk   (tx_samp_clk),
	.tx1_idata     (tx1_idata),
	.tx1_qdata     (tx1_qdata),
	.tx2_idata     (tx2_idata),
	.tx2_qdata     (tx2_qdata),
  .txdata        (tx_tdata ),
	.txready       (tx_tready),

	.orxdata       (orx_tdata),
	.orxvalid      (orx_tvalid),	
	.orx1_idata    (orx1_idata),
	.orx1_qdata    (orx1_qdata),
	.orx2_idata    (orx2_idata),
	.orx2_qdata    (orx2_qdata),

	.rxvalid       (rx_tvalid),
  .rxdata        (rx_tdata ),
	.rx1_idata     (rx1_idata),
	.rx1_qdata     (rx1_qdata),
	.rx2_idata     (rx2_idata),
	.rx2_qdata     (rx2_qdata)
);


assign tx2_idata = tx1_idata;
assign tx2_qdata = tx1_qdata;

dds_gen_wave   dds_gen_wave_u 
(
  .aclk                 (tx_samp_clk          ),  // input wire aclk
  .m_axis_data_tvalid   (     ),                    // output wire m_axis_data_tvalid
  .m_axis_data_tdata    ({tx1_idata,tx1_qdata   })  // output wire [31 : 0] m_axis_data_tdata
);


ila_adc ila_rx_inst (
  .clk(rx_samp_clk),        // input wire clk
  .probe0({
    rx1_idata ,
    rx2_idata ,
    rx1_qdata ,
    rx2_qdata ,
    rx_tvalid ,
    sysref    
  })                   // input wire [127:0] probe0
);

ila_adc ila_tx_inst (
  .clk(tx_samp_clk),        // input wire clk
  .probe0({
    tx1_idata ,
    tx2_idata ,
    tx1_qdata ,
    tx2_qdata ,
    tx_tready ,
    sysref    
  })                   // input wire [127:0] probe0
);


endmodule
