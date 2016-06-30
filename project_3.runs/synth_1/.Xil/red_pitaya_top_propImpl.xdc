set_property SRC_FILE_INFO {cfile:c:/Users/Christina/Documents/UROP/FPGAs/red_pitaya_fpga_blink_example/project_3/project_3.srcs/sources_1/bd/system/ip/system_processing_system7_0_0/system_processing_system7_0_0.xdc rfile:../../../project_3.srcs/sources_1/bd/system/ip/system_processing_system7_0_0/system_processing_system7_0_0.xdc id:1 order:EARLY scoped_inst:i_ps/system_i/system_i/processing_system7_0/inst} [current_design]
set_property SRC_FILE_INFO {cfile:C:/Users/Christina/Documents/UROP/FPGAs/red_pitaya_fpga_blink_example/project_3/project_3.srcs/constrs_1/red_pitaya.xdc rfile:../../../project_3.srcs/constrs_1/red_pitaya.xdc id:2} [current_design]
set_property SRC_FILE_INFO {cfile:C:/Users/Christina/Documents/UROP/FPGAs/red_pitaya_fpga_blink_example/project_3/project_3.srcs/constrs_1/red_pitaya_top.xdc rfile:../../../project_3.srcs/constrs_1/red_pitaya_top.xdc id:3} [current_design]
set_property src_info {type:SCOPED_XDC file:1 line:21 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter clk_fpga_2 0.6
set_property src_info {type:SCOPED_XDC file:1 line:24 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter clk_fpga_3 0.15
set_property src_info {type:SCOPED_XDC file:1 line:27 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter clk_fpga_1 0.12
set_property src_info {type:SCOPED_XDC file:1 line:30 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter clk_fpga_0 0.24
set_property src_info {type:XDC file:2 line:18 export:INPUT save:INPUT read:READ} [current_design]
set_property IOB TRUE [get_ports {adc_dat_a_i[*]}]
set_property src_info {type:XDC file:2 line:37 export:INPUT save:INPUT read:READ} [current_design]
set_property IOB TRUE [get_ports {adc_dat_b_i[*]}]
set_property src_info {type:XDC file:2 line:122 export:INPUT save:INPUT read:READ} [current_design]
set_property IOB TRUE [get_ports {dac_pwm_o[*]}]
set_property src_info {type:XDC file:2 line:136 export:INPUT save:INPUT read:READ} [current_design]
set_property LOC XADC_X0Y0 [get_cells i_analog/XADC_inst]
set_property src_info {type:XDC file:3 line:2 export:INPUT save:INPUT read:READ} [current_design]
set_property LOC DNA_PORT_X0Y0 [get_cells i_hk/i_DNA]
