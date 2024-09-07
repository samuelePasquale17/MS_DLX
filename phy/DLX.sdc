###################################################################

# Created by write_sdc on Sat Jun 15 00:17:59 2024

###################################################################
set sdc_version 2.1

set_units -time ns -resistance MOhm -capacitance fF -voltage V -current mA
set_wire_load_model -name 5K_hvratio_1_4 -library NangateOpenCellLibrary
create_clock [get_ports Clk]  -name CLK  -period 2  -waveform {0 1}
set_max_delay 2  -from [list [get_ports Rst] [get_ports Clk] [get_ports {DATA_IRAM[31]}]       \
[get_ports {DATA_IRAM[30]}] [get_ports {DATA_IRAM[29]}] [get_ports             \
{DATA_IRAM[28]}] [get_ports {DATA_IRAM[27]}] [get_ports {DATA_IRAM[26]}]       \
[get_ports {DATA_IRAM[25]}] [get_ports {DATA_IRAM[24]}] [get_ports             \
{DATA_IRAM[23]}] [get_ports {DATA_IRAM[22]}] [get_ports {DATA_IRAM[21]}]       \
[get_ports {DATA_IRAM[20]}] [get_ports {DATA_IRAM[19]}] [get_ports             \
{DATA_IRAM[18]}] [get_ports {DATA_IRAM[17]}] [get_ports {DATA_IRAM[16]}]       \
[get_ports {DATA_IRAM[15]}] [get_ports {DATA_IRAM[14]}] [get_ports             \
{DATA_IRAM[13]}] [get_ports {DATA_IRAM[12]}] [get_ports {DATA_IRAM[11]}]       \
[get_ports {DATA_IRAM[10]}] [get_ports {DATA_IRAM[9]}] [get_ports              \
{DATA_IRAM[8]}] [get_ports {DATA_IRAM[7]}] [get_ports {DATA_IRAM[6]}]          \
[get_ports {DATA_IRAM[5]}] [get_ports {DATA_IRAM[4]}] [get_ports               \
{DATA_IRAM[3]}] [get_ports {DATA_IRAM[2]}] [get_ports {DATA_IRAM[1]}]          \
[get_ports {DATA_IRAM[0]}] [get_ports {DATA_OUT_DRAM[31]}] [get_ports          \
{DATA_OUT_DRAM[30]}] [get_ports {DATA_OUT_DRAM[29]}] [get_ports                \
{DATA_OUT_DRAM[28]}] [get_ports {DATA_OUT_DRAM[27]}] [get_ports                \
{DATA_OUT_DRAM[26]}] [get_ports {DATA_OUT_DRAM[25]}] [get_ports                \
{DATA_OUT_DRAM[24]}] [get_ports {DATA_OUT_DRAM[23]}] [get_ports                \
{DATA_OUT_DRAM[22]}] [get_ports {DATA_OUT_DRAM[21]}] [get_ports                \
{DATA_OUT_DRAM[20]}] [get_ports {DATA_OUT_DRAM[19]}] [get_ports                \
{DATA_OUT_DRAM[18]}] [get_ports {DATA_OUT_DRAM[17]}] [get_ports                \
{DATA_OUT_DRAM[16]}] [get_ports {DATA_OUT_DRAM[15]}] [get_ports                \
{DATA_OUT_DRAM[14]}] [get_ports {DATA_OUT_DRAM[13]}] [get_ports                \
{DATA_OUT_DRAM[12]}] [get_ports {DATA_OUT_DRAM[11]}] [get_ports                \
{DATA_OUT_DRAM[10]}] [get_ports {DATA_OUT_DRAM[9]}] [get_ports                 \
{DATA_OUT_DRAM[8]}] [get_ports {DATA_OUT_DRAM[7]}] [get_ports                  \
{DATA_OUT_DRAM[6]}] [get_ports {DATA_OUT_DRAM[5]}] [get_ports                  \
{DATA_OUT_DRAM[4]}] [get_ports {DATA_OUT_DRAM[3]}] [get_ports                  \
{DATA_OUT_DRAM[2]}] [get_ports {DATA_OUT_DRAM[1]}] [get_ports                  \
{DATA_OUT_DRAM[0]}]]  -to [list [get_ports {ADDR_IRAM[31]}] [get_ports {ADDR_IRAM[30]}] [get_ports  \
{ADDR_IRAM[29]}] [get_ports {ADDR_IRAM[28]}] [get_ports {ADDR_IRAM[27]}]       \
[get_ports {ADDR_IRAM[26]}] [get_ports {ADDR_IRAM[25]}] [get_ports             \
{ADDR_IRAM[24]}] [get_ports {ADDR_IRAM[23]}] [get_ports {ADDR_IRAM[22]}]       \
[get_ports {ADDR_IRAM[21]}] [get_ports {ADDR_IRAM[20]}] [get_ports             \
{ADDR_IRAM[19]}] [get_ports {ADDR_IRAM[18]}] [get_ports {ADDR_IRAM[17]}]       \
[get_ports {ADDR_IRAM[16]}] [get_ports {ADDR_IRAM[15]}] [get_ports             \
{ADDR_IRAM[14]}] [get_ports {ADDR_IRAM[13]}] [get_ports {ADDR_IRAM[12]}]       \
[get_ports {ADDR_IRAM[11]}] [get_ports {ADDR_IRAM[10]}] [get_ports             \
{ADDR_IRAM[9]}] [get_ports {ADDR_IRAM[8]}] [get_ports {ADDR_IRAM[7]}]          \
[get_ports {ADDR_IRAM[6]}] [get_ports {ADDR_IRAM[5]}] [get_ports               \
{ADDR_IRAM[4]}] [get_ports {ADDR_IRAM[3]}] [get_ports {ADDR_IRAM[2]}]          \
[get_ports {ADDR_IRAM[1]}] [get_ports {ADDR_IRAM[0]}] [get_ports               \
{DATA_IN_DRAM[31]}] [get_ports {DATA_IN_DRAM[30]}] [get_ports                  \
{DATA_IN_DRAM[29]}] [get_ports {DATA_IN_DRAM[28]}] [get_ports                  \
{DATA_IN_DRAM[27]}] [get_ports {DATA_IN_DRAM[26]}] [get_ports                  \
{DATA_IN_DRAM[25]}] [get_ports {DATA_IN_DRAM[24]}] [get_ports                  \
{DATA_IN_DRAM[23]}] [get_ports {DATA_IN_DRAM[22]}] [get_ports                  \
{DATA_IN_DRAM[21]}] [get_ports {DATA_IN_DRAM[20]}] [get_ports                  \
{DATA_IN_DRAM[19]}] [get_ports {DATA_IN_DRAM[18]}] [get_ports                  \
{DATA_IN_DRAM[17]}] [get_ports {DATA_IN_DRAM[16]}] [get_ports                  \
{DATA_IN_DRAM[15]}] [get_ports {DATA_IN_DRAM[14]}] [get_ports                  \
{DATA_IN_DRAM[13]}] [get_ports {DATA_IN_DRAM[12]}] [get_ports                  \
{DATA_IN_DRAM[11]}] [get_ports {DATA_IN_DRAM[10]}] [get_ports                  \
{DATA_IN_DRAM[9]}] [get_ports {DATA_IN_DRAM[8]}] [get_ports {DATA_IN_DRAM[7]}] \
[get_ports {DATA_IN_DRAM[6]}] [get_ports {DATA_IN_DRAM[5]}] [get_ports         \
{DATA_IN_DRAM[4]}] [get_ports {DATA_IN_DRAM[3]}] [get_ports {DATA_IN_DRAM[2]}] \
[get_ports {DATA_IN_DRAM[1]}] [get_ports {DATA_IN_DRAM[0]}] [get_ports         \
{ADDR_DRAM[31]}] [get_ports {ADDR_DRAM[30]}] [get_ports {ADDR_DRAM[29]}]       \
[get_ports {ADDR_DRAM[28]}] [get_ports {ADDR_DRAM[27]}] [get_ports             \
{ADDR_DRAM[26]}] [get_ports {ADDR_DRAM[25]}] [get_ports {ADDR_DRAM[24]}]       \
[get_ports {ADDR_DRAM[23]}] [get_ports {ADDR_DRAM[22]}] [get_ports             \
{ADDR_DRAM[21]}] [get_ports {ADDR_DRAM[20]}] [get_ports {ADDR_DRAM[19]}]       \
[get_ports {ADDR_DRAM[18]}] [get_ports {ADDR_DRAM[17]}] [get_ports             \
{ADDR_DRAM[16]}] [get_ports {ADDR_DRAM[15]}] [get_ports {ADDR_DRAM[14]}]       \
[get_ports {ADDR_DRAM[13]}] [get_ports {ADDR_DRAM[12]}] [get_ports             \
{ADDR_DRAM[11]}] [get_ports {ADDR_DRAM[10]}] [get_ports {ADDR_DRAM[9]}]        \
[get_ports {ADDR_DRAM[8]}] [get_ports {ADDR_DRAM[7]}] [get_ports               \
{ADDR_DRAM[6]}] [get_ports {ADDR_DRAM[5]}] [get_ports {ADDR_DRAM[4]}]          \
[get_ports {ADDR_DRAM[3]}] [get_ports {ADDR_DRAM[2]}] [get_ports               \
{ADDR_DRAM[1]}] [get_ports {ADDR_DRAM[0]}] [get_ports RW_DRAM]]
