verdiSetActWin -dock widgetDock_<Message>
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
simSetSimulator "-vcssv" -exec "/home/student/Documents/hon_070/proj_dir/simv" \
           -args
debImport "-dbdir" "/home/student/Documents/hon_070/proj_dir/simv.daidir"
debLoadSimResult \
           /home/student/Documents/hon_070/proj_dir/axi_interconnect_2x8_tb.fsdb
wvCreateWindow
verdiSetActWin -win $_nWave2
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/_vcs_msglog"
wvGetSignalSetScope -win $_nWave2 "/tb_axi_interconnect_wrap_2x8/unnamed\$\$_0"
wvGetSignalSetScope -win $_nWave2 "/_vcs_unit__215913630"
wvGetSignalSetScope -win $_nWave2 "/tb_axi_interconnect_wrap_2x8/unnamed\$\$_0"
wvGetSignalSetScope -win $_nWave2 \
           "/tb_axi_interconnect_wrap_2x8/unnamed\$\$_0/unnamed\$\$_1/unnamed\$\$_2"
wvGetSignalSetScope -win $_nWave2 \
           "/tb_axi_interconnect_wrap_2x8/unnamed\$\$_0/unnamed\$\$_1"
wvGetSignalSetScope -win $_nWave2 "/tb_axi_interconnect_wrap_2x8/unnamed\$\$_0"
wvGetSignalSetScope -win $_nWave2 "/tb_axi_interconnect_wrap_2x8/dut"
wvSetPosition -win $_nWave2 {("G1" 27)}
wvSetPosition -win $_nWave2 {("G1" 27)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/tb_axi_interconnect_wrap_2x8/dut/m00_axi_arlen\[7:0\]} \
{/tb_axi_interconnect_wrap_2x8/dut/m00_axi_awaddr\[31:0\]} \
{/tb_axi_interconnect_wrap_2x8/dut/m00_axi_rdata\[31:0\]} \
{/tb_axi_interconnect_wrap_2x8/dut/m00_axi_wdata\[31:0\]} \
{/tb_axi_interconnect_wrap_2x8/dut/m01_axi_araddr\[31:0\]} \
{/tb_axi_interconnect_wrap_2x8/dut/m01_axi_awaddr\[31:0\]} \
{/tb_axi_interconnect_wrap_2x8/dut/m01_axi_rdata\[31:0\]} \
{/tb_axi_interconnect_wrap_2x8/dut/m01_axi_wdata\[31:0\]} \
{/tb_axi_interconnect_wrap_2x8/dut/m02_axi_rdata\[31:0\]} \
{/tb_axi_interconnect_wrap_2x8/dut/m02_axi_wdata\[31:0\]} \
{/tb_axi_interconnect_wrap_2x8/dut/m03_axi_awaddr\[31:0\]} \
{/tb_axi_interconnect_wrap_2x8/dut/m03_axi_rdata\[31:0\]} \
{/tb_axi_interconnect_wrap_2x8/dut/m03_axi_wdata\[31:0\]} \
{/tb_axi_interconnect_wrap_2x8/dut/m04_axi_awaddr\[31:0\]} \
{/tb_axi_interconnect_wrap_2x8/dut/m04_axi_rdata\[31:0\]} \
{/tb_axi_interconnect_wrap_2x8/dut/m04_axi_wdata\[31:0\]} \
{/tb_axi_interconnect_wrap_2x8/dut/m05_axi_awaddr\[31:0\]} \
{/tb_axi_interconnect_wrap_2x8/dut/m05_axi_rdata\[31:0\]} \
{/tb_axi_interconnect_wrap_2x8/dut/m05_axi_wdata\[31:0\]} \
{/tb_axi_interconnect_wrap_2x8/dut/m06_axi_awaddr\[31:0\]} \
{/tb_axi_interconnect_wrap_2x8/dut/m06_axi_rdata\[31:0\]} \
{/tb_axi_interconnect_wrap_2x8/dut/m06_axi_wdata\[31:0\]} \
{/tb_axi_interconnect_wrap_2x8/dut/m07_axi_awaddr\[31:0\]} \
{/tb_axi_interconnect_wrap_2x8/dut/m07_axi_rdata\[31:0\]} \
{/tb_axi_interconnect_wrap_2x8/dut/m07_axi_wdata\[31:0\]} \
{/tb_axi_interconnect_wrap_2x8/dut/s00_axi_awaddr\[31:0\]} \
{/tb_axi_interconnect_wrap_2x8/dut/s00_axi_rdata\[31:0\]} \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 \
           18 19 20 21 22 23 24 25 26 27 )} 
wvSetPosition -win $_nWave2 {("G1" 27)}
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvSelectSignal -win $_nWave2 {( "G1" 27 )} 
wvSelectSignal -win $_nWave2 {( "G1" 25 )} 
wvSelectSignal -win $_nWave2 {( "G1" 24 )} 
wvSelectSignal -win $_nWave2 {( "G1" 23 )} 
wvSelectSignal -win $_nWave2 {( "G1" 22 )} 
wvScrollDown -win $_nWave2 0
wvScrollUp -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollUp -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollUp -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollUp -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollUp -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollUp -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollUp -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollUp -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvZoomAll -win $_nWave2
wvZoomAll -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvSelectSignal -win $_nWave2 {( "G1" 3 )} 
wvSelectSignal -win $_nWave2 {( "G1" 4 )} 
wvSelectSignal -win $_nWave2 {( "G1" 3 )} 
wvSetCursor -win $_nWave2 282594.281416 -snap {("G1" 4)}
wvSelectSignal -win $_nWave2 {( "G1" 4 )} 
wvSelectSignal -win $_nWave2 {( "G1" 5 )} 
wvSelectSignal -win $_nWave2 {( "G1" 6 )} 
wvSelectSignal -win $_nWave2 {( "G1" 7 )} 
wvSelectSignal -win $_nWave2 {( "G1" 8 )} 
wvSetCursor -win $_nWave2 405255.108602 -snap {("G1" 8)}
wvSetCursor -win $_nWave2 551634.880270 -snap {("G1" 8)}
wvSelectSignal -win $_nWave2 {( "G1" 7 )} 
wvSelectSignal -win $_nWave2 {( "G1" 8 )} 
wvSelectSignal -win $_nWave2 {( "G1" 9 )} 
wvSetCursor -win $_nWave2 614659.504183 -snap {("G1" 9)}
wvSelectSignal -win $_nWave2 {( "G1" 10 )} 
wvSelectSignal -win $_nWave2 {( "G1" 11 )} 
wvSelectSignal -win $_nWave2 {( "G1" 12 )} 
wvSelectSignal -win $_nWave2 {( "G1" 11 )} 
wvSelectSignal -win $_nWave2 {( "G1" 12 )} 
wvSelectSignal -win $_nWave2 {( "G1" 13 )} 
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvSelectSignal -win $_nWave2 {( "G1" 14 )} 
wvSelectSignal -win $_nWave2 {( "G1" 15 )} 
wvSelectSignal -win $_nWave2 {( "G1" 16 )} 
wvScrollDown -win $_nWave2 7
wvScrollUp -win $_nWave2 3
wvSelectSignal -win $_nWave2 {( "G1" 17 )} 
wvSelectSignal -win $_nWave2 {( "G1" 18 )} 
wvSelectSignal -win $_nWave2 {( "G1" 19 )} 
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
verdiDockWidgetMaximize -dock windowDock_nWave_2
wvZoomAll -win $_nWave2
verdiCaptureWindow -win $_Verdi_1
verdiCloseDialog -win $_Verdi_1 -widget capturePreview
