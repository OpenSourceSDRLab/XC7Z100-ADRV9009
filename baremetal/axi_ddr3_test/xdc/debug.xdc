set_property IOSTANDARD LVCMOS33 [get_ports led]
set_property PACKAGE_PIN AE18 [get_ports led]


set_property IOSTANDARD LVCMOS33 [get_ports i_rst]
set_property PACKAGE_PIN AJ18 [get_ports i_rst]



create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 4096 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list u_mig_7series_0/u_mig_7series_0_mig/u_ddr3_infrastructure/u_bufg_clkdiv0_0]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 2 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {s_axi_arburst[0]} {s_axi_arburst[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 4 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {s_axi_rid[0]} {s_axi_rid[1]} {s_axi_rid[2]} {s_axi_rid[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 32 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {s_axi_wstrb[0]} {s_axi_wstrb[1]} {s_axi_wstrb[2]} {s_axi_wstrb[3]} {s_axi_wstrb[4]} {s_axi_wstrb[5]} {s_axi_wstrb[6]} {s_axi_wstrb[7]} {s_axi_wstrb[8]} {s_axi_wstrb[9]} {s_axi_wstrb[10]} {s_axi_wstrb[11]} {s_axi_wstrb[12]} {s_axi_wstrb[13]} {s_axi_wstrb[14]} {s_axi_wstrb[15]} {s_axi_wstrb[16]} {s_axi_wstrb[17]} {s_axi_wstrb[18]} {s_axi_wstrb[19]} {s_axi_wstrb[20]} {s_axi_wstrb[21]} {s_axi_wstrb[22]} {s_axi_wstrb[23]} {s_axi_wstrb[24]} {s_axi_wstrb[25]} {s_axi_wstrb[26]} {s_axi_wstrb[27]} {s_axi_wstrb[28]} {s_axi_wstrb[29]} {s_axi_wstrb[30]} {s_axi_wstrb[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 8 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {s_axi_awlen[0]} {s_axi_awlen[1]} {s_axi_awlen[2]} {s_axi_awlen[3]} {s_axi_awlen[4]} {s_axi_awlen[5]} {s_axi_awlen[6]} {s_axi_awlen[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 256 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {s_axi_wdata[0]} {s_axi_wdata[1]} {s_axi_wdata[2]} {s_axi_wdata[3]} {s_axi_wdata[4]} {s_axi_wdata[5]} {s_axi_wdata[6]} {s_axi_wdata[7]} {s_axi_wdata[8]} {s_axi_wdata[9]} {s_axi_wdata[10]} {s_axi_wdata[11]} {s_axi_wdata[12]} {s_axi_wdata[13]} {s_axi_wdata[14]} {s_axi_wdata[15]} {s_axi_wdata[16]} {s_axi_wdata[17]} {s_axi_wdata[18]} {s_axi_wdata[19]} {s_axi_wdata[20]} {s_axi_wdata[21]} {s_axi_wdata[22]} {s_axi_wdata[23]} {s_axi_wdata[24]} {s_axi_wdata[25]} {s_axi_wdata[26]} {s_axi_wdata[27]} {s_axi_wdata[28]} {s_axi_wdata[29]} {s_axi_wdata[30]} {s_axi_wdata[31]} {s_axi_wdata[32]} {s_axi_wdata[33]} {s_axi_wdata[34]} {s_axi_wdata[35]} {s_axi_wdata[36]} {s_axi_wdata[37]} {s_axi_wdata[38]} {s_axi_wdata[39]} {s_axi_wdata[40]} {s_axi_wdata[41]} {s_axi_wdata[42]} {s_axi_wdata[43]} {s_axi_wdata[44]} {s_axi_wdata[45]} {s_axi_wdata[46]} {s_axi_wdata[47]} {s_axi_wdata[48]} {s_axi_wdata[49]} {s_axi_wdata[50]} {s_axi_wdata[51]} {s_axi_wdata[52]} {s_axi_wdata[53]} {s_axi_wdata[54]} {s_axi_wdata[55]} {s_axi_wdata[56]} {s_axi_wdata[57]} {s_axi_wdata[58]} {s_axi_wdata[59]} {s_axi_wdata[60]} {s_axi_wdata[61]} {s_axi_wdata[62]} {s_axi_wdata[63]} {s_axi_wdata[64]} {s_axi_wdata[65]} {s_axi_wdata[66]} {s_axi_wdata[67]} {s_axi_wdata[68]} {s_axi_wdata[69]} {s_axi_wdata[70]} {s_axi_wdata[71]} {s_axi_wdata[72]} {s_axi_wdata[73]} {s_axi_wdata[74]} {s_axi_wdata[75]} {s_axi_wdata[76]} {s_axi_wdata[77]} {s_axi_wdata[78]} {s_axi_wdata[79]} {s_axi_wdata[80]} {s_axi_wdata[81]} {s_axi_wdata[82]} {s_axi_wdata[83]} {s_axi_wdata[84]} {s_axi_wdata[85]} {s_axi_wdata[86]} {s_axi_wdata[87]} {s_axi_wdata[88]} {s_axi_wdata[89]} {s_axi_wdata[90]} {s_axi_wdata[91]} {s_axi_wdata[92]} {s_axi_wdata[93]} {s_axi_wdata[94]} {s_axi_wdata[95]} {s_axi_wdata[96]} {s_axi_wdata[97]} {s_axi_wdata[98]} {s_axi_wdata[99]} {s_axi_wdata[100]} {s_axi_wdata[101]} {s_axi_wdata[102]} {s_axi_wdata[103]} {s_axi_wdata[104]} {s_axi_wdata[105]} {s_axi_wdata[106]} {s_axi_wdata[107]} {s_axi_wdata[108]} {s_axi_wdata[109]} {s_axi_wdata[110]} {s_axi_wdata[111]} {s_axi_wdata[112]} {s_axi_wdata[113]} {s_axi_wdata[114]} {s_axi_wdata[115]} {s_axi_wdata[116]} {s_axi_wdata[117]} {s_axi_wdata[118]} {s_axi_wdata[119]} {s_axi_wdata[120]} {s_axi_wdata[121]} {s_axi_wdata[122]} {s_axi_wdata[123]} {s_axi_wdata[124]} {s_axi_wdata[125]} {s_axi_wdata[126]} {s_axi_wdata[127]} {s_axi_wdata[128]} {s_axi_wdata[129]} {s_axi_wdata[130]} {s_axi_wdata[131]} {s_axi_wdata[132]} {s_axi_wdata[133]} {s_axi_wdata[134]} {s_axi_wdata[135]} {s_axi_wdata[136]} {s_axi_wdata[137]} {s_axi_wdata[138]} {s_axi_wdata[139]} {s_axi_wdata[140]} {s_axi_wdata[141]} {s_axi_wdata[142]} {s_axi_wdata[143]} {s_axi_wdata[144]} {s_axi_wdata[145]} {s_axi_wdata[146]} {s_axi_wdata[147]} {s_axi_wdata[148]} {s_axi_wdata[149]} {s_axi_wdata[150]} {s_axi_wdata[151]} {s_axi_wdata[152]} {s_axi_wdata[153]} {s_axi_wdata[154]} {s_axi_wdata[155]} {s_axi_wdata[156]} {s_axi_wdata[157]} {s_axi_wdata[158]} {s_axi_wdata[159]} {s_axi_wdata[160]} {s_axi_wdata[161]} {s_axi_wdata[162]} {s_axi_wdata[163]} {s_axi_wdata[164]} {s_axi_wdata[165]} {s_axi_wdata[166]} {s_axi_wdata[167]} {s_axi_wdata[168]} {s_axi_wdata[169]} {s_axi_wdata[170]} {s_axi_wdata[171]} {s_axi_wdata[172]} {s_axi_wdata[173]} {s_axi_wdata[174]} {s_axi_wdata[175]} {s_axi_wdata[176]} {s_axi_wdata[177]} {s_axi_wdata[178]} {s_axi_wdata[179]} {s_axi_wdata[180]} {s_axi_wdata[181]} {s_axi_wdata[182]} {s_axi_wdata[183]} {s_axi_wdata[184]} {s_axi_wdata[185]} {s_axi_wdata[186]} {s_axi_wdata[187]} {s_axi_wdata[188]} {s_axi_wdata[189]} {s_axi_wdata[190]} {s_axi_wdata[191]} {s_axi_wdata[192]} {s_axi_wdata[193]} {s_axi_wdata[194]} {s_axi_wdata[195]} {s_axi_wdata[196]} {s_axi_wdata[197]} {s_axi_wdata[198]} {s_axi_wdata[199]} {s_axi_wdata[200]} {s_axi_wdata[201]} {s_axi_wdata[202]} {s_axi_wdata[203]} {s_axi_wdata[204]} {s_axi_wdata[205]} {s_axi_wdata[206]} {s_axi_wdata[207]} {s_axi_wdata[208]} {s_axi_wdata[209]} {s_axi_wdata[210]} {s_axi_wdata[211]} {s_axi_wdata[212]} {s_axi_wdata[213]} {s_axi_wdata[214]} {s_axi_wdata[215]} {s_axi_wdata[216]} {s_axi_wdata[217]} {s_axi_wdata[218]} {s_axi_wdata[219]} {s_axi_wdata[220]} {s_axi_wdata[221]} {s_axi_wdata[222]} {s_axi_wdata[223]} {s_axi_wdata[224]} {s_axi_wdata[225]} {s_axi_wdata[226]} {s_axi_wdata[227]} {s_axi_wdata[228]} {s_axi_wdata[229]} {s_axi_wdata[230]} {s_axi_wdata[231]} {s_axi_wdata[232]} {s_axi_wdata[233]} {s_axi_wdata[234]} {s_axi_wdata[235]} {s_axi_wdata[236]} {s_axi_wdata[237]} {s_axi_wdata[238]} {s_axi_wdata[239]} {s_axi_wdata[240]} {s_axi_wdata[241]} {s_axi_wdata[242]} {s_axi_wdata[243]} {s_axi_wdata[244]} {s_axi_wdata[245]} {s_axi_wdata[246]} {s_axi_wdata[247]} {s_axi_wdata[248]} {s_axi_wdata[249]} {s_axi_wdata[250]} {s_axi_wdata[251]} {s_axi_wdata[252]} {s_axi_wdata[253]} {s_axi_wdata[254]} {s_axi_wdata[255]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 8 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {s_axi_arlen[0]} {s_axi_arlen[1]} {s_axi_arlen[2]} {s_axi_arlen[3]} {s_axi_arlen[4]} {s_axi_arlen[5]} {s_axi_arlen[6]} {s_axi_arlen[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 30 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {s_axi_awaddr[0]} {s_axi_awaddr[1]} {s_axi_awaddr[2]} {s_axi_awaddr[3]} {s_axi_awaddr[4]} {s_axi_awaddr[5]} {s_axi_awaddr[6]} {s_axi_awaddr[7]} {s_axi_awaddr[8]} {s_axi_awaddr[9]} {s_axi_awaddr[10]} {s_axi_awaddr[11]} {s_axi_awaddr[12]} {s_axi_awaddr[13]} {s_axi_awaddr[14]} {s_axi_awaddr[15]} {s_axi_awaddr[16]} {s_axi_awaddr[17]} {s_axi_awaddr[18]} {s_axi_awaddr[19]} {s_axi_awaddr[20]} {s_axi_awaddr[21]} {s_axi_awaddr[22]} {s_axi_awaddr[23]} {s_axi_awaddr[24]} {s_axi_awaddr[25]} {s_axi_awaddr[26]} {s_axi_awaddr[27]} {s_axi_awaddr[28]} {s_axi_awaddr[29]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 4 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {s_axi_awqos[0]} {s_axi_awqos[1]} {s_axi_awqos[2]} {s_axi_awqos[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 4 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {s_axi_bid[0]} {s_axi_bid[1]} {s_axi_bid[2]} {s_axi_bid[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 2 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {s_axi_awburst[0]} {s_axi_awburst[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 4 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {s_axi_arqos[0]} {s_axi_arqos[1]} {s_axi_arqos[2]} {s_axi_arqos[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 30 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {s_axi_araddr[0]} {s_axi_araddr[1]} {s_axi_araddr[2]} {s_axi_araddr[3]} {s_axi_araddr[4]} {s_axi_araddr[5]} {s_axi_araddr[6]} {s_axi_araddr[7]} {s_axi_araddr[8]} {s_axi_araddr[9]} {s_axi_araddr[10]} {s_axi_araddr[11]} {s_axi_araddr[12]} {s_axi_araddr[13]} {s_axi_araddr[14]} {s_axi_araddr[15]} {s_axi_araddr[16]} {s_axi_araddr[17]} {s_axi_araddr[18]} {s_axi_araddr[19]} {s_axi_araddr[20]} {s_axi_araddr[21]} {s_axi_araddr[22]} {s_axi_araddr[23]} {s_axi_araddr[24]} {s_axi_araddr[25]} {s_axi_araddr[26]} {s_axi_araddr[27]} {s_axi_araddr[28]} {s_axi_araddr[29]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 256 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {s_axi_rdata[0]} {s_axi_rdata[1]} {s_axi_rdata[2]} {s_axi_rdata[3]} {s_axi_rdata[4]} {s_axi_rdata[5]} {s_axi_rdata[6]} {s_axi_rdata[7]} {s_axi_rdata[8]} {s_axi_rdata[9]} {s_axi_rdata[10]} {s_axi_rdata[11]} {s_axi_rdata[12]} {s_axi_rdata[13]} {s_axi_rdata[14]} {s_axi_rdata[15]} {s_axi_rdata[16]} {s_axi_rdata[17]} {s_axi_rdata[18]} {s_axi_rdata[19]} {s_axi_rdata[20]} {s_axi_rdata[21]} {s_axi_rdata[22]} {s_axi_rdata[23]} {s_axi_rdata[24]} {s_axi_rdata[25]} {s_axi_rdata[26]} {s_axi_rdata[27]} {s_axi_rdata[28]} {s_axi_rdata[29]} {s_axi_rdata[30]} {s_axi_rdata[31]} {s_axi_rdata[32]} {s_axi_rdata[33]} {s_axi_rdata[34]} {s_axi_rdata[35]} {s_axi_rdata[36]} {s_axi_rdata[37]} {s_axi_rdata[38]} {s_axi_rdata[39]} {s_axi_rdata[40]} {s_axi_rdata[41]} {s_axi_rdata[42]} {s_axi_rdata[43]} {s_axi_rdata[44]} {s_axi_rdata[45]} {s_axi_rdata[46]} {s_axi_rdata[47]} {s_axi_rdata[48]} {s_axi_rdata[49]} {s_axi_rdata[50]} {s_axi_rdata[51]} {s_axi_rdata[52]} {s_axi_rdata[53]} {s_axi_rdata[54]} {s_axi_rdata[55]} {s_axi_rdata[56]} {s_axi_rdata[57]} {s_axi_rdata[58]} {s_axi_rdata[59]} {s_axi_rdata[60]} {s_axi_rdata[61]} {s_axi_rdata[62]} {s_axi_rdata[63]} {s_axi_rdata[64]} {s_axi_rdata[65]} {s_axi_rdata[66]} {s_axi_rdata[67]} {s_axi_rdata[68]} {s_axi_rdata[69]} {s_axi_rdata[70]} {s_axi_rdata[71]} {s_axi_rdata[72]} {s_axi_rdata[73]} {s_axi_rdata[74]} {s_axi_rdata[75]} {s_axi_rdata[76]} {s_axi_rdata[77]} {s_axi_rdata[78]} {s_axi_rdata[79]} {s_axi_rdata[80]} {s_axi_rdata[81]} {s_axi_rdata[82]} {s_axi_rdata[83]} {s_axi_rdata[84]} {s_axi_rdata[85]} {s_axi_rdata[86]} {s_axi_rdata[87]} {s_axi_rdata[88]} {s_axi_rdata[89]} {s_axi_rdata[90]} {s_axi_rdata[91]} {s_axi_rdata[92]} {s_axi_rdata[93]} {s_axi_rdata[94]} {s_axi_rdata[95]} {s_axi_rdata[96]} {s_axi_rdata[97]} {s_axi_rdata[98]} {s_axi_rdata[99]} {s_axi_rdata[100]} {s_axi_rdata[101]} {s_axi_rdata[102]} {s_axi_rdata[103]} {s_axi_rdata[104]} {s_axi_rdata[105]} {s_axi_rdata[106]} {s_axi_rdata[107]} {s_axi_rdata[108]} {s_axi_rdata[109]} {s_axi_rdata[110]} {s_axi_rdata[111]} {s_axi_rdata[112]} {s_axi_rdata[113]} {s_axi_rdata[114]} {s_axi_rdata[115]} {s_axi_rdata[116]} {s_axi_rdata[117]} {s_axi_rdata[118]} {s_axi_rdata[119]} {s_axi_rdata[120]} {s_axi_rdata[121]} {s_axi_rdata[122]} {s_axi_rdata[123]} {s_axi_rdata[124]} {s_axi_rdata[125]} {s_axi_rdata[126]} {s_axi_rdata[127]} {s_axi_rdata[128]} {s_axi_rdata[129]} {s_axi_rdata[130]} {s_axi_rdata[131]} {s_axi_rdata[132]} {s_axi_rdata[133]} {s_axi_rdata[134]} {s_axi_rdata[135]} {s_axi_rdata[136]} {s_axi_rdata[137]} {s_axi_rdata[138]} {s_axi_rdata[139]} {s_axi_rdata[140]} {s_axi_rdata[141]} {s_axi_rdata[142]} {s_axi_rdata[143]} {s_axi_rdata[144]} {s_axi_rdata[145]} {s_axi_rdata[146]} {s_axi_rdata[147]} {s_axi_rdata[148]} {s_axi_rdata[149]} {s_axi_rdata[150]} {s_axi_rdata[151]} {s_axi_rdata[152]} {s_axi_rdata[153]} {s_axi_rdata[154]} {s_axi_rdata[155]} {s_axi_rdata[156]} {s_axi_rdata[157]} {s_axi_rdata[158]} {s_axi_rdata[159]} {s_axi_rdata[160]} {s_axi_rdata[161]} {s_axi_rdata[162]} {s_axi_rdata[163]} {s_axi_rdata[164]} {s_axi_rdata[165]} {s_axi_rdata[166]} {s_axi_rdata[167]} {s_axi_rdata[168]} {s_axi_rdata[169]} {s_axi_rdata[170]} {s_axi_rdata[171]} {s_axi_rdata[172]} {s_axi_rdata[173]} {s_axi_rdata[174]} {s_axi_rdata[175]} {s_axi_rdata[176]} {s_axi_rdata[177]} {s_axi_rdata[178]} {s_axi_rdata[179]} {s_axi_rdata[180]} {s_axi_rdata[181]} {s_axi_rdata[182]} {s_axi_rdata[183]} {s_axi_rdata[184]} {s_axi_rdata[185]} {s_axi_rdata[186]} {s_axi_rdata[187]} {s_axi_rdata[188]} {s_axi_rdata[189]} {s_axi_rdata[190]} {s_axi_rdata[191]} {s_axi_rdata[192]} {s_axi_rdata[193]} {s_axi_rdata[194]} {s_axi_rdata[195]} {s_axi_rdata[196]} {s_axi_rdata[197]} {s_axi_rdata[198]} {s_axi_rdata[199]} {s_axi_rdata[200]} {s_axi_rdata[201]} {s_axi_rdata[202]} {s_axi_rdata[203]} {s_axi_rdata[204]} {s_axi_rdata[205]} {s_axi_rdata[206]} {s_axi_rdata[207]} {s_axi_rdata[208]} {s_axi_rdata[209]} {s_axi_rdata[210]} {s_axi_rdata[211]} {s_axi_rdata[212]} {s_axi_rdata[213]} {s_axi_rdata[214]} {s_axi_rdata[215]} {s_axi_rdata[216]} {s_axi_rdata[217]} {s_axi_rdata[218]} {s_axi_rdata[219]} {s_axi_rdata[220]} {s_axi_rdata[221]} {s_axi_rdata[222]} {s_axi_rdata[223]} {s_axi_rdata[224]} {s_axi_rdata[225]} {s_axi_rdata[226]} {s_axi_rdata[227]} {s_axi_rdata[228]} {s_axi_rdata[229]} {s_axi_rdata[230]} {s_axi_rdata[231]} {s_axi_rdata[232]} {s_axi_rdata[233]} {s_axi_rdata[234]} {s_axi_rdata[235]} {s_axi_rdata[236]} {s_axi_rdata[237]} {s_axi_rdata[238]} {s_axi_rdata[239]} {s_axi_rdata[240]} {s_axi_rdata[241]} {s_axi_rdata[242]} {s_axi_rdata[243]} {s_axi_rdata[244]} {s_axi_rdata[245]} {s_axi_rdata[246]} {s_axi_rdata[247]} {s_axi_rdata[248]} {s_axi_rdata[249]} {s_axi_rdata[250]} {s_axi_rdata[251]} {s_axi_rdata[252]} {s_axi_rdata[253]} {s_axi_rdata[254]} {s_axi_rdata[255]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 4 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {s_axi_awid[0]} {s_axi_awid[1]} {s_axi_awid[2]} {s_axi_awid[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 4 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list {s_axi_arid[0]} {s_axi_arid[1]} {s_axi_arid[2]} {s_axi_arid[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 1 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list AXI_Master_Drive_u0/i_init_calib_complete]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 1 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list s_axi_arready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 1 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list s_axi_arvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 1 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list s_axi_awready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 1 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list s_axi_awvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 1 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list s_axi_bready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 1 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list s_axi_bvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 1 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list s_axi_rlast]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
set_property port_width 1 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list s_axi_rready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe24]
set_property port_width 1 [get_debug_ports u_ila_0/probe24]
connect_debug_port u_ila_0/probe24 [get_nets [list s_axi_rvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe25]
set_property port_width 1 [get_debug_ports u_ila_0/probe25]
connect_debug_port u_ila_0/probe25 [get_nets [list s_axi_wlast]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe26]
set_property port_width 1 [get_debug_ports u_ila_0/probe26]
connect_debug_port u_ila_0/probe26 [get_nets [list s_axi_wready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe27]
set_property port_width 1 [get_debug_ports u_ila_0/probe27]
connect_debug_port u_ila_0/probe27 [get_nets [list s_axi_wvalid]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets w_user_clk]
