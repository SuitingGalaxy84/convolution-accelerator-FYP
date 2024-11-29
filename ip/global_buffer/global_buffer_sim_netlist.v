// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
// Date        : Fri Nov 29 16:35:14 2024
// Host        : ThisIsALaptop running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               h:/Desktop/FYP/vivado_sim/convolution-accelerator-FYP/convolution-accelerator-FYP.gen/sources_1/ip/global_buffer/global_buffer_sim_netlist.v
// Design      : global_buffer
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu2cg-sbva484-1-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "global_buffer,blk_mem_gen_v8_4_4,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2021.1" *) 
(* NotValidForBitStream *)
module global_buffer
   (clka,
    rsta,
    wea,
    addra,
    dina,
    douta,
    clkb,
    rstb,
    web,
    addrb,
    dinb,
    doutb,
    rsta_busy,
    rstb_busy);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA RST" *) input rsta;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [9:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [15:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [15:0]douta;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTB, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clkb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB RST" *) input rstb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB WE" *) input [0:0]web;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR" *) input [9:0]addrb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DIN" *) input [15:0]dinb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT" *) output [15:0]doutb;
  output rsta_busy;
  output rstb_busy;

  wire [9:0]addra;
  wire [9:0]addrb;
  wire clka;
  wire clkb;
  wire [15:0]dina;
  wire [15:0]dinb;
  wire [15:0]douta;
  wire [15:0]doutb;
  wire rsta;
  wire rsta_busy;
  wire rstb;
  wire rstb_busy;
  wire [0:0]wea;
  wire [0:0]web;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [9:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [9:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [15:0]NLW_U0_s_axi_rdata_UNCONNECTED;
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
  (* C_COUNT_18K_BRAM = "1" *) 
  (* C_COUNT_36K_BRAM = "0" *) 
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
  (* C_EN_SAFETY_CKT = "1" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     2.122356 mW" *) 
  (* C_FAMILY = "zynquplus" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "0" *) 
  (* C_HAS_ENB = "0" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "1" *) 
  (* C_HAS_RSTB = "1" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "global_buffer.mem" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "2" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "1024" *) 
  (* C_READ_DEPTH_B = "1024" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "16" *) 
  (* C_READ_WIDTH_B = "16" *) 
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
  (* C_WRITE_MODE_A = "NO_CHANGE" *) 
  (* C_WRITE_MODE_B = "NO_CHANGE" *) 
  (* C_WRITE_WIDTH_A = "16" *) 
  (* C_WRITE_WIDTH_B = "16" *) 
  (* C_XDEVICEFAMILY = "zynquplus" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  global_buffer_blk_mem_gen_v8_4_4 U0
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .clkb(clkb),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb(dinb),
        .douta(douta),
        .doutb(doutb),
        .eccpipece(1'b0),
        .ena(1'b0),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[9:0]),
        .regcea(1'b0),
        .regceb(1'b0),
        .rsta(rsta),
        .rsta_busy(rsta_busy),
        .rstb(rstb),
        .rstb_busy(rstb_busy),
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
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[15:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb(1'b0),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(wea),
        .web(web));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2021.1"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
sbNGmomEbP78s1hfxgX3P1Jo01EKJk0i0C7iGpF+Yibr9EK0s4mcIifHDN/ag4jpPwW3bPllMHvn
U8AEY3mO8hCXVVoilrcRuCaEna/98GycCzy4G7FnYMfowsJb5k9ifRdE2jnurzeTLFbupUSpDF0H
Rl3Ci3DTGeExAZZ9UQE=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
zZZZoIprBFYfDWmCCcduELBM7HU98/+rvP9g8+y1mYyD3r3HEDm4ZwehwZvPoYWqoGXYoFqWZh3h
utt0abIfUW9/oF2vJ9hXn7nArtcm/Eui18rPYqp3aj/AItPNVXojk9zp7uFZLPTqcyig5v3Jtenl
qPnLi1Z84ZCW7NIRw6Y0bgmw6z26E8VPbYrZHs+0YW8Sztjo6CdIrQeEL5WBDolA0aHoKHWRZyFs
l5eRDmBAolj2uF07t/3eY3J7cYJmEDaoZ0TR1qcz25VFNu0OlcrEJ19IT+QdAxTah4jqJtknGZrT
6lUMwDZ7dBQwF1EuaE6p90gGNERhGAsbHLdvaw==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
KUbz0Iu2faeWqD6HFeuGLtSOAlqZmpKCCJfzym8tkcWUUNgNMn2mYvx6PTM7j4tyig8JdUG3uZYs
NfPgAsNXQtTI7b19u9CkMks9jR+oEzX1rW7QtTvSj/nHZLg2smoFwuB5Ieb7/B8IIs1NTUrIz6Rc
itLQVG+L+GMziamsrx4=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
G7XYdRx9VGclyxTEtwMG+rjJHV8bfBxEGdkcN82UL3koN3Dt0M5AWkzEvHcskt1W0hTOjyYgmvYj
/p70w1nz96tlg226+e4UubpRmBH9QXBBX6UmqIwSiHj9H+XI1yNfTIdlwBKGQvfzwCAMwBwrrrGL
/804k5Ux3RhWRvwezZB4+sj9DFm4akREVXmNpfeqjI2X02LU/MxWMUbKxvjJnD9YxikAAO6ccTd6
8DKv76V76MEFVyXc7E2FeQDToW3lqkRTa6MTpIXbYSekRihQC+qPVuhPUneA4kepvQDfgFYE8/Ir
gu5gK+s/qNfuXhJUAqyLjslrUcY4+XD9ckpSvQ==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
YXkYRXpUPv/tETnwnThdQ46UaPmI23lN9vrxHQjIOhq3WNJCuz7TYZK9hyzSdo6k0U6QE9ihQy2L
rYZg68RGbrK8bzlcnQ41r18LZb4GYlAn9PH7IrF1B+aHm3578doOZHf8wzUE2s+d1aHQIn6VIZjL
14pCTAjErJfMO13fgX6h8sgxb4GFC3eIORmkrq2J/fB9HALyh/qdGiLi7DejMfmdsssbOcPQTZUh
6Belf7fHTkIEr9B44rFZgMyrMVx4N9p0XpXD3JPe7Xeg6a3jxdqxHATaMuLdIa4s+ZiAz1TRx0EO
FFihCnLLb7weBBITQyTIncRL817BrF/ZXZD8Yw==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2021_01", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
g7FbNw1ywd4TBNHq8OmK/4zoKI/t7vKmyT8R8SeiyUtKywhn0/7DZ/lV0Lf4IhY8X5MYsKtOQ5l6
DIl3fxtOhxpi8NHn9Nw3Nfb8NnS38Zuy6DSpwOL0f/GSmUSf2/YdB5Ben6xibQT0Oy//oBl5/1kR
pV5fWjj8WRgI6cnmfyj3g1MxepxPu1A/UHxlm1/i9yUHHi114N/hEQ0iujjrn6GxfZSiJUVF+r6c
rnxD//eOAl/YaxhdU/KhUkfsMn+MxtA5m6hTYYE0bnze8rpmEU5UGYKyY0p8KUs+MgsdTe+m/7gV
HSf6puBqQmEa1qksRfl742aL9B9y169or7Jp9Q==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
kd1A2zIphLxXB0RyfHIqLkHXfWl0n38vROERuDghYrhK0ItcWGEP0XBrri6k1VZCSPYwiSu//pM6
83BfcPKbk09/A+ksvDIa3xS8Tg7DJK2AS+0pdnzBSjVWh+QD+glA3Hjk6LG9OMbjXyqD3hnMKacA
VRMwxKktV+KT5NXj5a7fMxXjo9exc0xM+woUJiSYs8onoUSwfBeH5/xhUy+iu+w0/OOydQE2LXZ0
1y+RObiz5C22dD4GGCfuvUCGAthYpUf633ZxRYN45mmAn5PxPsH4o+l2GhH/50Gu/VPVoAWDhgXQ
e93oPri++HinkK2uvDhDl4PI9HtRkq11Ky3uXQ==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
gDrrFgXHVyBo+Cn0bYn+SOSOCXPg7besukY6l0JmA/nu4gap105Wxbg11c7TJZ9ctHVLc5DXAxr+
EIvFpAIepoZBREtMjTlaIdNJ8k1nUpwAv2jaQeseq1TudTjugV1jtOYYk0RKd88z/6SJ8t9urDW0
yKqsfEWU3PwGcUGHOWtTn2hfAceNznmEIFWLmFmzSQJ1hQNdsIQn3jHnfMVYu8cAz5xvPVQWYyJW
pMHXhNYk6GyAjIshh991slb1g01K1ilR2tKD1EmxH5WGrX9BEUqBjHQo6uluC/d3mvcEQ5nJ1v+P
hIlj4qzUQT1wXjpk6d/BvNx7LyWmj5iq35dzNm+cdhfGwaFGG//vgmB6D/dFfs2BYSjHsa6VlpVM
7e2OgoFenuG9p1SVPI6gAs2MuFtnDKfxW7jS3RGhvsquS3tg1iFCDH/OU7E5aWfY7twF3yyN6G10
l72RZw62DfNoCdyUMG9sA8nc4qf6dEhyrr5S6XxpJhoBDJvkeq0TCUQZ

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
XR7vRF1m+9DS2Pv4r/O4uHwmvtXkChnKbsJCYczn1dvkZbcZSbBm/2UH78dXUaNorOh9XAuCvSjb
ER73y7e0anAfaIf1tJ9Y9pIb8EuNxGS/Pqdvg36cWarwGac9tsscdv/HWfb5Z+qWEk0/uFcLI7pH
CZO7fF2/ONQjA0NtUFBjW4idlx8WrySIuJgDs4jyGkMhbHR3U/ghF1YhMhwgwsbbcptfC1XLrIqQ
OecZnZu8E2hyc5eK/ccYdKcHnXoL55z1p5amI6Fuvz0wKTz2QQ/mwXodfGjEC1ZRWwTn7zCFM91M
qrA1Is49i6pSa7/VICjgn8ULMT1oKGfJLPm7hg==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 27632)
`pragma protect data_block
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
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
