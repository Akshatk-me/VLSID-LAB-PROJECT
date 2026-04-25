// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
// Date        : Tue Apr 14 22:52:47 2026
// Host        : akshatk running 64-bit Arch Linux
// Command     : write_verilog -force -mode funcsim {/home/akshatk/Acads/Elec Stuff/VLSI Design
//               Lab/CourseProject/project/RV32I_SHA256_SoC.gen/sources_1/ip/blk_mem_gen_0/blk_mem_gen_0_sim_netlist.v}
// Design      : blk_mem_gen_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_gen_0,blk_mem_gen_v8_4_4,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2020.2" *) 
(* NotValidForBitStream *)
module blk_mem_gen_0
   (clka,
    ena,
    wea,
    addra,
    dina,
    douta);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [9:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [31:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [31:0]douta;

  wire [9:0]addra;
  wire clka;
  wire [31:0]dina;
  wire [31:0]douta;
  wire ena;
  wire [0:0]wea;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_rsta_busy_UNCONNECTED;
  wire NLW_U0_rstb_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [31:0]NLW_U0_doutb_UNCONNECTED;
  wire [9:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [9:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [31:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "10" *) 
  (* C_ADDRB_WIDTH = "10" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "0" *) 
  (* C_COUNT_36K_BRAM = "1" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "0" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     3.1309 mW" *) 
  (* C_FAMILY = "zynq" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "1" *) 
  (* C_HAS_ENB = "0" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "1" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "0" *) 
  (* C_HAS_RSTB = "0" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "blk_mem_gen_0.mem" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "0" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "1024" *) 
  (* C_READ_DEPTH_B = "1024" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "32" *) 
  (* C_READ_WIDTH_B = "32" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "0" *) 
  (* C_USE_BYTE_WEB = "0" *) 
  (* C_USE_DEFAULT_DATA = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "1" *) 
  (* C_WEB_WIDTH = "1" *) 
  (* C_WRITE_DEPTH_A = "1024" *) 
  (* C_WRITE_DEPTH_B = "1024" *) 
  (* C_WRITE_MODE_A = "READ_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "32" *) 
  (* C_WRITE_WIDTH_B = "32" *) 
  (* C_XDEVICEFAMILY = "zynq" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  blk_mem_gen_0_blk_mem_gen_v8_4_4 U0
       (.addra(addra),
        .addrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .clka(clka),
        .clkb(1'b0),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(douta),
        .doutb(NLW_U0_doutb_UNCONNECTED[31:0]),
        .eccpipece(1'b0),
        .ena(ena),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[9:0]),
        .regcea(1'b0),
        .regceb(1'b0),
        .rsta(1'b0),
        .rsta_busy(NLW_U0_rsta_busy_UNCONNECTED),
        .rstb(1'b0),
        .rstb_busy(NLW_U0_rstb_busy_UNCONNECTED),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[9:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[31:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb(1'b0),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(wea),
        .web(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2020.2"
`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="cds_rsa_key", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=64)
`pragma protect key_block
QGLtnqZzRetDH6gCWT4Js6wuLlZfrNx/VJp3sfR2NF+cxypO5AxN0oDKLJJtmdrtE/ueNDg+Qf7Z
TqBNRojORA==

`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
B6Ger3hRvfjHkaJ+W8639Kl3TzC9TogLuklOXEiMNdc4Im+DjEUzxb3DKlzu0VW3zxZqjJ3+wsW/
LnRmPCESi5Y9eRJaLFXg79EMfoj4X+nTdHAP6yCfltBADKegZ12gpnB/8ey5yn2KA74LUtPC7jna
iyjqSfsWLGnz6UdXzwk=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
BX+DxgMPRyZbYojCUR9Sk8Lq+3ZigBz4yMFHQkmurfdfDzyTPJCE827eGiPyTenK1QPVhEtf9g06
0BFXq/0COPuU1BWJwdkz1c4dE6/exDwhvEh+hPx3vRY6z8fDEf6aGVIXrHDvrmddehe7yMSIpo+k
aXHR06EEdfHCFY4TggYwhcJVXjkE+ApsVuyfmEfPmYjo8hCWyQyBsUWIOY03q1+MvUjjsmTwgs9g
fh5MY9ToaLfoJxPKdCpsqrBX4LJ+VDGFlAqIcqHTE2jCmPiToZAFXB7fzf1wDjFCBlJyFVDBGi0i
m+CouLSb7X1mvVhdDZgNrZDJMV688Bu3o54vew==

`pragma protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
DaIU/Ddc8USbZ2mURzujJDWDH1JbHl5tFVOOQ2aVaUPIA71yyE38OXVLEtF8rNmujYH30nEeQ+FV
LVJ16aaHw+iiuaqorTM3K5KLohVlN+WlcEtSXHuPNHjw8ddqtzpaX7pH1zqZH+YmfCL5oaNLqDH4
rkBnUl0/Gm/hzSwKjYhXGQFYQ+gGP99OjXakzrAqZzp/Iq4gt+Z5902/JV9thd/isHQImJ0QyK8M
EKM579iPAfXGes2mbiNYHcvDmSPYmW1zlhOE++N1EKeea7j/msnKeyhlC+hGE4Xfn4TVvqgQexCT
rp/wS/MosY6WH1aKFQlFH2hEppA7KXUaQlvG+w==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
XmWoAt4X8hrCJ5yTyug4ajJW5UhfkLNibzjihWzZ4Cr9hQSvWZoTc8rjGsLPbz6Le+/9iI5KxecS
eR0wiAO+G2IkwhZgVBeZdKoFnlnTVAyLjk9wMAFXNyJZM6b1NDbfXlPcUsC6JePvPlwwdWknkSsC
r3KvgkWAS+O3xvRmaNw=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Hw3Y+rShKrXiUViyNU1/O2qv6TgheLHBnFMj1i9MUGrHYqh9pLfLYUgWR7S2vj4jv4S+Ks0BpP4p
dKEqVAFmTCfQNEUHaVcFPkOHgig6L4mhLY6HUUKJoRgiQepgLi/W3V+ZZPQSQFkB3CU4MsJzhXvR
yLcpDriZy8cnAHD87Zi5DrNGBzj3kigJeM0du6lCQbxtF5aEdoaNP+YTnIFtcqYhoYnswQlYt0sV
HKgFA8VzqzL5WYnpH7+1IKmFkJBHkyqHCa9wPK0qCKnxkuDj70YzPVqQ+cocdKU+/gNdpCOdZlci
F2HTxrgfrXndJru3TiDqu4UavqAe0MNuFp3t0w==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
XPVggoWL6aXz+MpODTOZhEUQDa0vfEnUDaYeEHXm2vGyqKJujN2c/FFAFBeBYdJATLsIsQ+BqoPc
pBbcFYXDBfOtFIW2dH6Y1OoD65KyJ/hAq8coa21kFgq4hFat5vzZ2iIfkCpTUr4vDZO7Xne8cZO9
WsHffoTCt5rS59wWm2b8I5R8Eh2TUbQg3RCyrcnD66cvcEnlXe1CNMQ4/loVJpA4IBinBf820Wjc
vw2fZbGI0jXC+ACSHOviH63Xwmn+aRV5Ppkup7IYoon/ieKapRQeASu3TTY37xSBXiInSdtMTzJ6
+4GfO4eSHVriCk/sWbuTBzfRzoSShrnHjzz5LA==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2020_08", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
L78XuiswVcgO2gtebzL7SA9BC/jJGAM0v6S9pzmyqL+QYzRneiYeGyDmsW33jEVVSTuNjTXkBLY7
yTOKQruatwe4V0OLi6174saSAmPgerSV1GyLP7KhmusLV/N61avC9TPam+tekhKeE0tds4EnJ3et
4JdLh+SE4Z4pcuqCjB5MFneIYKKWDx7siU6oesAQtoSJOesfMchX63MhOjOHFP/ch+1gHv3T45hg
IGF7V7TrdREVE4f9631tlVJ1o2Dypsmo/76Itz5WCGlTMjAnWXN8IXxKN+PZ3dyt1wjrZm2P/td+
xiGszFnSLrRvw/HferwtSmRx8q0fiHZ88roGTw==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
kDX5kq2QEe25429T6vQqBCFvV1McKTJRYfK99ymVNK2GGvGLXSzgwJHwB2fj9rM0wme3zYYY0vQR
x+9F4L7KLlOVY6qY3LB59uDzyXBI3mMZaS905HXHJkdZHWtQWpfHhl27LqL+8FSluaD6F+KFfYOV
CwIOVuCIp/XjxFXpNBik7YiPt4kHOlDA97IXNLnYUn/g1csGqeNWce4UTne50ggWvLYGbTFGmTjT
N67TpUiGRVRCSv8Tax72GWFIMFZk3Tlp68ZUSQEybZMWX1U9XdMdtxfvNGhf8mi5jQJ2SupSzKu4
T/+53IN9T8aLePAiGBKKG1ZBj4y1ZyYA7XYvjw==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 27936)
`pragma protect data_block
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
DwR8Guo2
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
