# I don't think the constraints in this file are necessarily needed in our implementation. 
# this looks like the target file in the project, which means that it may contain constraints built through the GUI during debugging

# The first constraint looks like it was a file not initially set, but created by the program or the user during the debugging process. It
# looks like the set_false_path is ignoring some sort of timing violation. There is probably no timing violation between the two clocks
# because of a bridge put to synchronize the two signals, but this probably still throws some sort of error, and then saying 
# "set_false_path" basically ignores the timing violation in a later step of the compilation. 
set_false_path -from [get_clocks adc_clk] -to [get_clocks dac_clk_out]

# I think this might set the DNA port as a particular location in the current design... 
set_property LOC DNA_PORT_X0Y0 [get_cells i_hk/i_DNA]
