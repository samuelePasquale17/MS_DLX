analyze -library WORK -format vhdl {000-constants.vhd}
analyze -library WORK -format vhdl {000-myTypes.vhd}
analyze -library WORK -format vhdl {b.b-SHIFTER.vhd}
analyze -library WORK -format vhdl {b.c-iv.vhd}
analyze -library WORK -format vhdl {b.c-nd2.vhd}
analyze -library WORK -format vhdl {b.b-mux21.vhd}
analyze -library WORK -format vhdl {b.b-mux4n1.vhd}
analyze -library WORK -format vhdl {b.b-mux71.vhd}
analyze -library WORK -format vhdl {b.b-muxn1.vhd}
analyze -library WORK -format vhdl {b.b-muxn31.vhd}
analyze -library WORK -format vhdl {b.c-nand3N.vhd}
analyze -library WORK -format vhdl {b.c-nand4N.vhd}
analyze -library WORK -format vhdl {b.b-FA.vhd}
analyze -library WORK -format vhdl {b.b-RCA.vhd}
analyze -library WORK -format vhdl {b.b-carry_select_block.vhd}
analyze -library WORK -format vhdl {b.b-sum_generator.vhd}
analyze -library WORK -format vhdl {b.b-g_block.vhd}
analyze -library WORK -format vhdl {b.b-pg_block.vhd}
analyze -library WORK -format vhdl {b.b-pg_network.vhd}
analyze -library WORK -format vhdl {b.b-carry_generator_sparse_tree.vhd}
analyze -library WORK -format vhdl {b.b-carry_generator.vhd}
analyze -library WORK -format vhdl {b.b-P4_adder.vhd}
analyze -library WORK -format vhdl {b.a-RegN.vhd}
analyze -library WORK -format vhdl {b.a-registerfile.vhd}
analyze -library WORK -format vhdl {b.a-SIGEXT.vhd}
analyze -library WORK -format vhdl {b.b-LOGICALS.vhd}
analyze -library WORK -format vhdl {b.b-JUMP_UNIT.vhd}
analyze -library WORK -format vhdl {b.a-zeroDetector.vhd}
analyze -library WORK -format vhdl {b.b-SUMSUB.vhd}
analyze -library WORK -format vhdl {b.b-COMPARATOR.vhd}
analyze -library WORK -format vhdl {a.b-LUT_CU.vhd}
analyze -library WORK -format vhdl {a.b-CU_FETCH_STAGE.vhd}
analyze -library WORK -format vhdl {004-CU_HW.vhd}
analyze -library WORK -format vhdl {b.a-ALU.vhd}
analyze -library WORK -format vhdl {003-DATAPATH.vhd}
analyze -library WORK -format vhdl {002-DLX_DP_CU.vhd}
elaborate DLX_DP_CU -architecture rtl -library work
set_wire_load_model -name 5K_hvratio_1_4
create_clock -name "CLK" -period 2 {"Clk"}
set_max_delay 2 -from [all_inputs] -to [all_outputs]
compile -map_effort high
report_timing > reportTiming.rpt
report_power > reportPower.rpt
report_area > reportArea.rpt
write -hierarchy -f verilog -output dlx.v
write_sdc DLX.sdc


