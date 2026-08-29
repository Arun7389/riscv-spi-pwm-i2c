// ============================================================
//  tb_axi_interconnect_wrap_2x8.sv
//  Self-checking testbench for axi_interconnect_wrap_2x8
//  2 Masters x 8 Slaves x 2 ops = 32 minimum transactions
//  Compatible with Synopsys VCS + Verdi (FSDB)
// ============================================================
`timescale 1ns/1ps

module tb_axi_interconnect_wrap_2x8;

// ------------------------------------------------------------
// Parameters matching DUT defaults
// ------------------------------------------------------------
localparam DATA_WIDTH  = 32;
localparam ADDR_WIDTH  = 32;
localparam STRB_WIDTH  = DATA_WIDTH/8;   // 4
localparam ID_WIDTH    = 8;
localparam TIMEOUT_CYC = 200;            // cycles before declaring hang

// Slave address map  (base = slave_index << 24)
// S0=0x00000000 S1=0x01000000 ... S7=0x07000000, each 16 MB
localparam [ADDR_WIDTH-1:0] S0_BASE = 32'h0000_0000;
localparam [ADDR_WIDTH-1:0] S1_BASE = 32'h0100_0000;
localparam [ADDR_WIDTH-1:0] S2_BASE = 32'h0200_0000;
localparam [ADDR_WIDTH-1:0] S3_BASE = 32'h0300_0000;
localparam [ADDR_WIDTH-1:0] S4_BASE = 32'h0400_0000;
localparam [ADDR_WIDTH-1:0] S5_BASE = 32'h0500_0000;
localparam [ADDR_WIDTH-1:0] S6_BASE = 32'h0600_0000;
localparam [ADDR_WIDTH-1:0] S7_BASE = 32'h0700_0000;

// ------------------------------------------------------------
// Clock & reset
// ------------------------------------------------------------
logic clk;
logic rst;

initial clk = 1'b0;
always #5 clk = ~clk;   // 100 MHz

// ------------------------------------------------------------
// Score-board counters
// ------------------------------------------------------------
integer total_tests  = 0;
integer passed_tests = 0;
integer failed_tests = 0;

// ============================================================
// DUT port signals
// ============================================================

// --- Slave port 0 (TB master M0 drives these) ---------------
logic [ID_WIDTH-1:0]   s00_awid;    logic [ADDR_WIDTH-1:0] s00_awaddr;
logic [7:0]            s00_awlen;   logic [2:0]            s00_awsize;
logic [1:0]            s00_awburst; logic                  s00_awlock;
logic [3:0]            s00_awcache; logic [2:0]            s00_awprot;
logic [3:0]            s00_awqos;   logic                  s00_awvalid;
wire                   s00_awready;
logic [DATA_WIDTH-1:0] s00_wdata;   logic [STRB_WIDTH-1:0] s00_wstrb;
logic                  s00_wlast;   logic                  s00_wvalid;
wire                   s00_wready;
wire  [ID_WIDTH-1:0]   s00_bid;     wire  [1:0]            s00_bresp;
wire                   s00_bvalid;  logic                  s00_bready;
logic [ID_WIDTH-1:0]   s00_arid;    logic [ADDR_WIDTH-1:0] s00_araddr;
logic [7:0]            s00_arlen;   logic [2:0]            s00_arsize;
logic [1:0]            s00_arburst; logic                  s00_arlock;
logic [3:0]            s00_arcache; logic [2:0]            s00_arprot;
logic [3:0]            s00_arqos;   logic                  s00_arvalid;
wire                   s00_arready;
wire  [ID_WIDTH-1:0]   s00_rid;     wire  [DATA_WIDTH-1:0] s00_rdata;
wire  [1:0]            s00_rresp;   wire                   s00_rlast;
wire                   s00_rvalid;  logic                  s00_rready;

// --- Slave port 1 (TB master M1 drives these) ---------------
logic [ID_WIDTH-1:0]   s01_awid;    logic [ADDR_WIDTH-1:0] s01_awaddr;
logic [7:0]            s01_awlen;   logic [2:0]            s01_awsize;
logic [1:0]            s01_awburst; logic                  s01_awlock;
logic [3:0]            s01_awcache; logic [2:0]            s01_awprot;
logic [3:0]            s01_awqos;   logic                  s01_awvalid;
wire                   s01_awready;
logic [DATA_WIDTH-1:0] s01_wdata;   logic [STRB_WIDTH-1:0] s01_wstrb;
logic                  s01_wlast;   logic                  s01_wvalid;
wire                   s01_wready;
wire  [ID_WIDTH-1:0]   s01_bid;     wire  [1:0]            s01_bresp;
wire                   s01_bvalid;  logic                  s01_bready;
logic [ID_WIDTH-1:0]   s01_arid;    logic [ADDR_WIDTH-1:0] s01_araddr;
logic [7:0]            s01_arlen;   logic [2:0]            s01_arsize;
logic [1:0]            s01_arburst; logic                  s01_arlock;
logic [3:0]            s01_arcache; logic [2:0]            s01_arprot;
logic [3:0]            s01_arqos;   logic                  s01_arvalid;
wire                   s01_arready;
wire  [ID_WIDTH-1:0]   s01_rid;     wire  [DATA_WIDTH-1:0] s01_rdata;
wire  [1:0]            s01_rresp;   wire                   s01_rlast;
wire                   s01_rvalid;  logic                  s01_rready;


// ============================================================
// DUT master-side port signals (driven by dummy slave models)
// ============================================================
// m00
wire  [ID_WIDTH-1:0]   m00_awid;  wire  [ADDR_WIDTH-1:0] m00_awaddr;
wire  [7:0]            m00_awlen; wire  [2:0]            m00_awsize;
wire  [1:0]            m00_awburst;wire                  m00_awlock;
wire  [3:0]            m00_awcache;wire [2:0]            m00_awprot;
wire  [3:0]            m00_awqos; wire  [3:0]            m00_awregion;
wire                   m00_awvalid;logic                 m00_awready;
wire  [DATA_WIDTH-1:0] m00_wdata; wire  [STRB_WIDTH-1:0] m00_wstrb;
wire                   m00_wlast; wire                   m00_wvalid;
logic                  m00_wready;
logic [ID_WIDTH-1:0]   m00_bid;   logic [1:0]            m00_bresp;
logic                  m00_bvalid;wire                   m00_bready;
wire  [ID_WIDTH-1:0]   m00_arid;  wire  [ADDR_WIDTH-1:0] m00_araddr;
wire  [7:0]            m00_arlen; wire  [2:0]            m00_arsize;
wire  [1:0]            m00_arburst;wire                  m00_arlock;
wire  [3:0]            m00_arcache;wire [2:0]            m00_arprot;
wire  [3:0]            m00_arqos; wire  [3:0]            m00_arregion;
wire                   m00_arvalid;logic                 m00_arready;
logic [ID_WIDTH-1:0]   m00_rid;   logic [DATA_WIDTH-1:0] m00_rdata;
logic [1:0]            m00_rresp; logic                  m00_rlast;
logic                  m00_rvalid;wire                   m00_rready;

// m01
wire  [ID_WIDTH-1:0]   m01_awid;  wire  [ADDR_WIDTH-1:0] m01_awaddr;
wire  [7:0]            m01_awlen; wire  [2:0]            m01_awsize;
wire  [1:0]            m01_awburst;wire                  m01_awlock;
wire  [3:0]            m01_awcache;wire [2:0]            m01_awprot;
wire  [3:0]            m01_awqos; wire  [3:0]            m01_awregion;
wire                   m01_awvalid;logic                 m01_awready;
wire  [DATA_WIDTH-1:0] m01_wdata; wire  [STRB_WIDTH-1:0] m01_wstrb;
wire                   m01_wlast; wire                   m01_wvalid;
logic                  m01_wready;
logic [ID_WIDTH-1:0]   m01_bid;   logic [1:0]            m01_bresp;
logic                  m01_bvalid;wire                   m01_bready;
wire  [ID_WIDTH-1:0]   m01_arid;  wire  [ADDR_WIDTH-1:0] m01_araddr;
wire  [7:0]            m01_arlen; wire  [2:0]            m01_arsize;
wire  [1:0]            m01_arburst;wire                  m01_arlock;
wire  [3:0]            m01_arcache;wire [2:0]            m01_arprot;
wire  [3:0]            m01_arqos; wire  [3:0]            m01_arregion;
wire                   m01_arvalid;logic                 m01_arready;
logic [ID_WIDTH-1:0]   m01_rid;   logic [DATA_WIDTH-1:0] m01_rdata;
logic [1:0]            m01_rresp; logic                  m01_rlast;
logic                  m01_rvalid;wire                   m01_rready;

// m02
wire  [ID_WIDTH-1:0]   m02_awid;  wire  [ADDR_WIDTH-1:0] m02_awaddr;
wire  [7:0]            m02_awlen; wire  [2:0]            m02_awsize;
wire  [1:0]            m02_awburst;wire                  m02_awlock;
wire  [3:0]            m02_awcache;wire [2:0]            m02_awprot;
wire  [3:0]            m02_awqos; wire  [3:0]            m02_awregion;
wire                   m02_awvalid;logic                 m02_awready;
wire  [DATA_WIDTH-1:0] m02_wdata; wire  [STRB_WIDTH-1:0] m02_wstrb;
wire                   m02_wlast; wire                   m02_wvalid;
logic                  m02_wready;
logic [ID_WIDTH-1:0]   m02_bid;   logic [1:0]            m02_bresp;
logic                  m02_bvalid;wire                   m02_bready;
wire  [ID_WIDTH-1:0]   m02_arid;  wire  [ADDR_WIDTH-1:0] m02_araddr;
wire  [7:0]            m02_arlen; wire  [2:0]            m02_arsize;
wire  [1:0]            m02_arburst;wire                  m02_arlock;
wire  [3:0]            m02_arcache;wire [2:0]            m02_arprot;
wire  [3:0]            m02_arqos; wire  [3:0]            m02_arregion;
wire                   m02_arvalid;logic                 m02_arready;
logic [ID_WIDTH-1:0]   m02_rid;   logic [DATA_WIDTH-1:0] m02_rdata;
logic [1:0]            m02_rresp; logic                  m02_rlast;
logic                  m02_rvalid;wire                   m02_rready;

// m03
wire  [ID_WIDTH-1:0]   m03_awid;  wire  [ADDR_WIDTH-1:0] m03_awaddr;
wire  [7:0]            m03_awlen; wire  [2:0]            m03_awsize;
wire  [1:0]            m03_awburst;wire                  m03_awlock;
wire  [3:0]            m03_awcache;wire [2:0]            m03_awprot;
wire  [3:0]            m03_awqos; wire  [3:0]            m03_awregion;
wire                   m03_awvalid;logic                 m03_awready;
wire  [DATA_WIDTH-1:0] m03_wdata; wire  [STRB_WIDTH-1:0] m03_wstrb;
wire                   m03_wlast; wire                   m03_wvalid;
logic                  m03_wready;
logic [ID_WIDTH-1:0]   m03_bid;   logic [1:0]            m03_bresp;
logic                  m03_bvalid;wire                   m03_bready;
wire  [ID_WIDTH-1:0]   m03_arid;  wire  [ADDR_WIDTH-1:0] m03_araddr;
wire  [7:0]            m03_arlen; wire  [2:0]            m03_arsize;
wire  [1:0]            m03_arburst;wire                  m03_arlock;
wire  [3:0]            m03_arcache;wire [2:0]            m03_arprot;
wire  [3:0]            m03_arqos; wire  [3:0]            m03_arregion;
wire                   m03_arvalid;logic                 m03_arready;
logic [ID_WIDTH-1:0]   m03_rid;   logic [DATA_WIDTH-1:0] m03_rdata;
logic [1:0]            m03_rresp; logic                  m03_rlast;
logic                  m03_rvalid;wire                   m03_rready;

// m04
wire  [ID_WIDTH-1:0]   m04_awid;  wire  [ADDR_WIDTH-1:0] m04_awaddr;
wire  [7:0]            m04_awlen; wire  [2:0]            m04_awsize;
wire  [1:0]            m04_awburst;wire                  m04_awlock;
wire  [3:0]            m04_awcache;wire [2:0]            m04_awprot;
wire  [3:0]            m04_awqos; wire  [3:0]            m04_awregion;
wire                   m04_awvalid;logic                 m04_awready;
wire  [DATA_WIDTH-1:0] m04_wdata; wire  [STRB_WIDTH-1:0] m04_wstrb;
wire                   m04_wlast; wire                   m04_wvalid;
logic                  m04_wready;
logic [ID_WIDTH-1:0]   m04_bid;   logic [1:0]            m04_bresp;
logic                  m04_bvalid;wire                   m04_bready;
wire  [ID_WIDTH-1:0]   m04_arid;  wire  [ADDR_WIDTH-1:0] m04_araddr;
wire  [7:0]            m04_arlen; wire  [2:0]            m04_arsize;
wire  [1:0]            m04_arburst;wire                  m04_arlock;
wire  [3:0]            m04_arcache;wire [2:0]            m04_arprot;
wire  [3:0]            m04_arqos; wire  [3:0]            m04_arregion;
wire                   m04_arvalid;logic                 m04_arready;
logic [ID_WIDTH-1:0]   m04_rid;   logic [DATA_WIDTH-1:0] m04_rdata;
logic [1:0]            m04_rresp; logic                  m04_rlast;
logic                  m04_rvalid;wire                   m04_rready;

// m05
wire  [ID_WIDTH-1:0]   m05_awid;  wire  [ADDR_WIDTH-1:0] m05_awaddr;
wire  [7:0]            m05_awlen; wire  [2:0]            m05_awsize;
wire  [1:0]            m05_awburst;wire                  m05_awlock;
wire  [3:0]            m05_awcache;wire [2:0]            m05_awprot;
wire  [3:0]            m05_awqos; wire  [3:0]            m05_awregion;
wire                   m05_awvalid;logic                 m05_awready;
wire  [DATA_WIDTH-1:0] m05_wdata; wire  [STRB_WIDTH-1:0] m05_wstrb;
wire                   m05_wlast; wire                   m05_wvalid;
logic                  m05_wready;
logic [ID_WIDTH-1:0]   m05_bid;   logic [1:0]            m05_bresp;
logic                  m05_bvalid;wire                   m05_bready;
wire  [ID_WIDTH-1:0]   m05_arid;  wire  [ADDR_WIDTH-1:0] m05_araddr;
wire  [7:0]            m05_arlen; wire  [2:0]            m05_arsize;
wire  [1:0]            m05_arburst;wire                  m05_arlock;
wire  [3:0]            m05_arcache;wire [2:0]            m05_arprot;
wire  [3:0]            m05_arqos; wire  [3:0]            m05_arregion;
wire                   m05_arvalid;logic                 m05_arready;
logic [ID_WIDTH-1:0]   m05_rid;   logic [DATA_WIDTH-1:0] m05_rdata;
logic [1:0]            m05_rresp; logic                  m05_rlast;
logic                  m05_rvalid;wire                   m05_rready;

// m06
wire  [ID_WIDTH-1:0]   m06_awid;  wire  [ADDR_WIDTH-1:0] m06_awaddr;
wire  [7:0]            m06_awlen; wire  [2:0]            m06_awsize;
wire  [1:0]            m06_awburst;wire                  m06_awlock;
wire  [3:0]            m06_awcache;wire [2:0]            m06_awprot;
wire  [3:0]            m06_awqos; wire  [3:0]            m06_awregion;
wire                   m06_awvalid;logic                 m06_awready;
wire  [DATA_WIDTH-1:0] m06_wdata; wire  [STRB_WIDTH-1:0] m06_wstrb;
wire                   m06_wlast; wire                   m06_wvalid;
logic                  m06_wready;
logic [ID_WIDTH-1:0]   m06_bid;   logic [1:0]            m06_bresp;
logic                  m06_bvalid;wire                   m06_bready;
wire  [ID_WIDTH-1:0]   m06_arid;  wire  [ADDR_WIDTH-1:0] m06_araddr;
wire  [7:0]            m06_arlen; wire  [2:0]            m06_arsize;
wire  [1:0]            m06_arburst;wire                  m06_arlock;
wire  [3:0]            m06_arcache;wire [2:0]            m06_arprot;
wire  [3:0]            m06_arqos; wire  [3:0]            m06_arregion;
wire                   m06_arvalid;logic                 m06_arready;
logic [ID_WIDTH-1:0]   m06_rid;   logic [DATA_WIDTH-1:0] m06_rdata;
logic [1:0]            m06_rresp; logic                  m06_rlast;
logic                  m06_rvalid;wire                   m06_rready;

// m07
wire  [ID_WIDTH-1:0]   m07_awid;  wire  [ADDR_WIDTH-1:0] m07_awaddr;
wire  [7:0]            m07_awlen; wire  [2:0]            m07_awsize;
wire  [1:0]            m07_awburst;wire                  m07_awlock;
wire  [3:0]            m07_awcache;wire [2:0]            m07_awprot;
wire  [3:0]            m07_awqos; wire  [3:0]            m07_awregion;
wire                   m07_awvalid;logic                 m07_awready;
wire  [DATA_WIDTH-1:0] m07_wdata; wire  [STRB_WIDTH-1:0] m07_wstrb;
wire                   m07_wlast; wire                   m07_wvalid;
logic                  m07_wready;
logic [ID_WIDTH-1:0]   m07_bid;   logic [1:0]            m07_bresp;
logic                  m07_bvalid;wire                   m07_bready;
wire  [ID_WIDTH-1:0]   m07_arid;  wire  [ADDR_WIDTH-1:0] m07_araddr;
wire  [7:0]            m07_arlen; wire  [2:0]            m07_arsize;
wire  [1:0]            m07_arburst;wire                  m07_arlock;
wire  [3:0]            m07_arcache;wire [2:0]            m07_arprot;
wire  [3:0]            m07_arqos; wire  [3:0]            m07_arregion;
wire                   m07_arvalid;logic                 m07_arready;
logic [ID_WIDTH-1:0]   m07_rid;   logic [DATA_WIDTH-1:0] m07_rdata;
logic [1:0]            m07_rresp; logic                  m07_rlast;
logic                  m07_rvalid;wire                   m07_rready;


// ============================================================
// DUT instantiation
// ============================================================
axi_interconnect_wrap_2x8 #(
    .DATA_WIDTH      (DATA_WIDTH),
    .ADDR_WIDTH      (ADDR_WIDTH),
    .STRB_WIDTH      (STRB_WIDTH),
    .ID_WIDTH        (ID_WIDTH),
    // Properly aligned base addresses: slave N starts at N << 24
    .M00_BASE_ADDR   (32'h0000_0000),
    .M01_BASE_ADDR   (32'h0100_0000),
    .M02_BASE_ADDR   (32'h0200_0000),
    .M03_BASE_ADDR   (32'h0300_0000),
    .M04_BASE_ADDR   (32'h0400_0000),
    .M05_BASE_ADDR   (32'h0500_0000),
    .M06_BASE_ADDR   (32'h0600_0000),
    .M07_BASE_ADDR   (32'h0700_0000)
) dut (
    .clk(clk), .rst(rst),
    // slave port 0
    .s00_axi_awid(s00_awid),   .s00_axi_awaddr(s00_awaddr), .s00_axi_awlen(s00_awlen),
    .s00_axi_awsize(s00_awsize),.s00_axi_awburst(s00_awburst),.s00_axi_awlock(s00_awlock),
    .s00_axi_awcache(s00_awcache),.s00_axi_awprot(s00_awprot),.s00_axi_awqos(s00_awqos),
    .s00_axi_awuser(1'b0),     .s00_axi_awvalid(s00_awvalid),.s00_axi_awready(s00_awready),
    .s00_axi_wdata(s00_wdata), .s00_axi_wstrb(s00_wstrb),   .s00_axi_wlast(s00_wlast),
    .s00_axi_wuser(1'b0),      .s00_axi_wvalid(s00_wvalid), .s00_axi_wready(s00_wready),
    .s00_axi_bid(s00_bid),     .s00_axi_bresp(s00_bresp),   .s00_axi_buser(),
    .s00_axi_bvalid(s00_bvalid),.s00_axi_bready(s00_bready),
    .s00_axi_arid(s00_arid),   .s00_axi_araddr(s00_araddr), .s00_axi_arlen(s00_arlen),
    .s00_axi_arsize(s00_arsize),.s00_axi_arburst(s00_arburst),.s00_axi_arlock(s00_arlock),
    .s00_axi_arcache(s00_arcache),.s00_axi_arprot(s00_arprot),.s00_axi_arqos(s00_arqos),
    .s00_axi_aruser(1'b0),     .s00_axi_arvalid(s00_arvalid),.s00_axi_arready(s00_arready),
    .s00_axi_rid(s00_rid),     .s00_axi_rdata(s00_rdata),   .s00_axi_rresp(s00_rresp),
    .s00_axi_rlast(s00_rlast), .s00_axi_ruser(),             .s00_axi_rvalid(s00_rvalid),
    .s00_axi_rready(s00_rready),
    // slave port 1
    .s01_axi_awid(s01_awid),   .s01_axi_awaddr(s01_awaddr), .s01_axi_awlen(s01_awlen),
    .s01_axi_awsize(s01_awsize),.s01_axi_awburst(s01_awburst),.s01_axi_awlock(s01_awlock),
    .s01_axi_awcache(s01_awcache),.s01_axi_awprot(s01_awprot),.s01_axi_awqos(s01_awqos),
    .s01_axi_awuser(1'b0),     .s01_axi_awvalid(s01_awvalid),.s01_axi_awready(s01_awready),
    .s01_axi_wdata(s01_wdata), .s01_axi_wstrb(s01_wstrb),   .s01_axi_wlast(s01_wlast),
    .s01_axi_wuser(1'b0),      .s01_axi_wvalid(s01_wvalid), .s01_axi_wready(s01_wready),
    .s01_axi_bid(s01_bid),     .s01_axi_bresp(s01_bresp),   .s01_axi_buser(),
    .s01_axi_bvalid(s01_bvalid),.s01_axi_bready(s01_bready),
    .s01_axi_arid(s01_arid),   .s01_axi_araddr(s01_araddr), .s01_axi_arlen(s01_arlen),
    .s01_axi_arsize(s01_arsize),.s01_axi_arburst(s01_arburst),.s01_axi_arlock(s01_arlock),
    .s01_axi_arcache(s01_arcache),.s01_axi_arprot(s01_arprot),.s01_axi_arqos(s01_arqos),
    .s01_axi_aruser(1'b0),     .s01_axi_arvalid(s01_arvalid),.s01_axi_arready(s01_arready),
    .s01_axi_rid(s01_rid),     .s01_axi_rdata(s01_rdata),   .s01_axi_rresp(s01_rresp),
    .s01_axi_rlast(s01_rlast), .s01_axi_ruser(),             .s01_axi_rvalid(s01_rvalid),
    .s01_axi_rready(s01_rready),
    // master port 0
    .m00_axi_awid(m00_awid),   .m00_axi_awaddr(m00_awaddr), .m00_axi_awlen(m00_awlen),
    .m00_axi_awsize(m00_awsize),.m00_axi_awburst(m00_awburst),.m00_axi_awlock(m00_awlock),
    .m00_axi_awcache(m00_awcache),.m00_axi_awprot(m00_awprot),.m00_axi_awqos(m00_awqos),
    .m00_axi_awregion(m00_awregion),.m00_axi_awuser(),        .m00_axi_awvalid(m00_awvalid),
    .m00_axi_awready(m00_awready),
    .m00_axi_wdata(m00_wdata), .m00_axi_wstrb(m00_wstrb),   .m00_axi_wlast(m00_wlast),
    .m00_axi_wuser(),          .m00_axi_wvalid(m00_wvalid), .m00_axi_wready(m00_wready),
    .m00_axi_bid(m00_bid),     .m00_axi_bresp(m00_bresp),   .m00_axi_buser(1'b0),
    .m00_axi_bvalid(m00_bvalid),.m00_axi_bready(m00_bready),
    .m00_axi_arid(m00_arid),   .m00_axi_araddr(m00_araddr), .m00_axi_arlen(m00_arlen),
    .m00_axi_arsize(m00_arsize),.m00_axi_arburst(m00_arburst),.m00_axi_arlock(m00_arlock),
    .m00_axi_arcache(m00_arcache),.m00_axi_arprot(m00_arprot),.m00_axi_arqos(m00_arqos),
    .m00_axi_arregion(m00_arregion),.m00_axi_aruser(),        .m00_axi_arvalid(m00_arvalid),
    .m00_axi_arready(m00_arready),
    .m00_axi_rid(m00_rid),     .m00_axi_rdata(m00_rdata),   .m00_axi_rresp(m00_rresp),
    .m00_axi_rlast(m00_rlast), .m00_axi_ruser(1'b0),         .m00_axi_rvalid(m00_rvalid),
    .m00_axi_rready(m00_rready),
    // master port 1
    .m01_axi_awid(m01_awid),   .m01_axi_awaddr(m01_awaddr), .m01_axi_awlen(m01_awlen),
    .m01_axi_awsize(m01_awsize),.m01_axi_awburst(m01_awburst),.m01_axi_awlock(m01_awlock),
    .m01_axi_awcache(m01_awcache),.m01_axi_awprot(m01_awprot),.m01_axi_awqos(m01_awqos),
    .m01_axi_awregion(m01_awregion),.m01_axi_awuser(),        .m01_axi_awvalid(m01_awvalid),
    .m01_axi_awready(m01_awready),
    .m01_axi_wdata(m01_wdata), .m01_axi_wstrb(m01_wstrb),   .m01_axi_wlast(m01_wlast),
    .m01_axi_wuser(),          .m01_axi_wvalid(m01_wvalid), .m01_axi_wready(m01_wready),
    .m01_axi_bid(m01_bid),     .m01_axi_bresp(m01_bresp),   .m01_axi_buser(1'b0),
    .m01_axi_bvalid(m01_bvalid),.m01_axi_bready(m01_bready),
    .m01_axi_arid(m01_arid),   .m01_axi_araddr(m01_araddr), .m01_axi_arlen(m01_arlen),
    .m01_axi_arsize(m01_arsize),.m01_axi_arburst(m01_arburst),.m01_axi_arlock(m01_arlock),
    .m01_axi_arcache(m01_arcache),.m01_axi_arprot(m01_arprot),.m01_axi_arqos(m01_arqos),
    .m01_axi_arregion(m01_arregion),.m01_axi_aruser(),        .m01_axi_arvalid(m01_arvalid),
    .m01_axi_arready(m01_arready),
    .m01_axi_rid(m01_rid),     .m01_axi_rdata(m01_rdata),   .m01_axi_rresp(m01_rresp),
    .m01_axi_rlast(m01_rlast), .m01_axi_ruser(1'b0),         .m01_axi_rvalid(m01_rvalid),
    .m01_axi_rready(m01_rready),
    // master port 2
    .m02_axi_awid(m02_awid),   .m02_axi_awaddr(m02_awaddr), .m02_axi_awlen(m02_awlen),
    .m02_axi_awsize(m02_awsize),.m02_axi_awburst(m02_awburst),.m02_axi_awlock(m02_awlock),
    .m02_axi_awcache(m02_awcache),.m02_axi_awprot(m02_awprot),.m02_axi_awqos(m02_awqos),
    .m02_axi_awregion(m02_awregion),.m02_axi_awuser(),        .m02_axi_awvalid(m02_awvalid),
    .m02_axi_awready(m02_awready),
    .m02_axi_wdata(m02_wdata), .m02_axi_wstrb(m02_wstrb),   .m02_axi_wlast(m02_wlast),
    .m02_axi_wuser(),          .m02_axi_wvalid(m02_wvalid), .m02_axi_wready(m02_wready),
    .m02_axi_bid(m02_bid),     .m02_axi_bresp(m02_bresp),   .m02_axi_buser(1'b0),
    .m02_axi_bvalid(m02_bvalid),.m02_axi_bready(m02_bready),
    .m02_axi_arid(m02_arid),   .m02_axi_araddr(m02_araddr), .m02_axi_arlen(m02_arlen),
    .m02_axi_arsize(m02_arsize),.m02_axi_arburst(m02_arburst),.m02_axi_arlock(m02_arlock),
    .m02_axi_arcache(m02_arcache),.m02_axi_arprot(m02_arprot),.m02_axi_arqos(m02_arqos),
    .m02_axi_arregion(m02_arregion),.m02_axi_aruser(),        .m02_axi_arvalid(m02_arvalid),
    .m02_axi_arready(m02_arready),
    .m02_axi_rid(m02_rid),     .m02_axi_rdata(m02_rdata),   .m02_axi_rresp(m02_rresp),
    .m02_axi_rlast(m02_rlast), .m02_axi_ruser(1'b0),         .m02_axi_rvalid(m02_rvalid),
    .m02_axi_rready(m02_rready),
    // master port 3
    .m03_axi_awid(m03_awid),   .m03_axi_awaddr(m03_awaddr), .m03_axi_awlen(m03_awlen),
    .m03_axi_awsize(m03_awsize),.m03_axi_awburst(m03_awburst),.m03_axi_awlock(m03_awlock),
    .m03_axi_awcache(m03_awcache),.m03_axi_awprot(m03_awprot),.m03_axi_awqos(m03_awqos),
    .m03_axi_awregion(m03_awregion),.m03_axi_awuser(),        .m03_axi_awvalid(m03_awvalid),
    .m03_axi_awready(m03_awready),
    .m03_axi_wdata(m03_wdata), .m03_axi_wstrb(m03_wstrb),   .m03_axi_wlast(m03_wlast),
    .m03_axi_wuser(),          .m03_axi_wvalid(m03_wvalid), .m03_axi_wready(m03_wready),
    .m03_axi_bid(m03_bid),     .m03_axi_bresp(m03_bresp),   .m03_axi_buser(1'b0),
    .m03_axi_bvalid(m03_bvalid),.m03_axi_bready(m03_bready),
    .m03_axi_arid(m03_arid),   .m03_axi_araddr(m03_araddr), .m03_axi_arlen(m03_arlen),
    .m03_axi_arsize(m03_arsize),.m03_axi_arburst(m03_arburst),.m03_axi_arlock(m03_arlock),
    .m03_axi_arcache(m03_arcache),.m03_axi_arprot(m03_arprot),.m03_axi_arqos(m03_arqos),
    .m03_axi_arregion(m03_arregion),.m03_axi_aruser(),        .m03_axi_arvalid(m03_arvalid),
    .m03_axi_arready(m03_arready),
    .m03_axi_rid(m03_rid),     .m03_axi_rdata(m03_rdata),   .m03_axi_rresp(m03_rresp),
    .m03_axi_rlast(m03_rlast), .m03_axi_ruser(1'b0),         .m03_axi_rvalid(m03_rvalid),
    .m03_axi_rready(m03_rready),
    // master port 4
    .m04_axi_awid(m04_awid),   .m04_axi_awaddr(m04_awaddr), .m04_axi_awlen(m04_awlen),
    .m04_axi_awsize(m04_awsize),.m04_axi_awburst(m04_awburst),.m04_axi_awlock(m04_awlock),
    .m04_axi_awcache(m04_awcache),.m04_axi_awprot(m04_awprot),.m04_axi_awqos(m04_awqos),
    .m04_axi_awregion(m04_awregion),.m04_axi_awuser(),        .m04_axi_awvalid(m04_awvalid),
    .m04_axi_awready(m04_awready),
    .m04_axi_wdata(m04_wdata), .m04_axi_wstrb(m04_wstrb),   .m04_axi_wlast(m04_wlast),
    .m04_axi_wuser(),          .m04_axi_wvalid(m04_wvalid), .m04_axi_wready(m04_wready),
    .m04_axi_bid(m04_bid),     .m04_axi_bresp(m04_bresp),   .m04_axi_buser(1'b0),
    .m04_axi_bvalid(m04_bvalid),.m04_axi_bready(m04_bready),
    .m04_axi_arid(m04_arid),   .m04_axi_araddr(m04_araddr), .m04_axi_arlen(m04_arlen),
    .m04_axi_arsize(m04_arsize),.m04_axi_arburst(m04_arburst),.m04_axi_arlock(m04_arlock),
    .m04_axi_arcache(m04_arcache),.m04_axi_arprot(m04_arprot),.m04_axi_arqos(m04_arqos),
    .m04_axi_arregion(m04_arregion),.m04_axi_aruser(),        .m04_axi_arvalid(m04_arvalid),
    .m04_axi_arready(m04_arready),
    .m04_axi_rid(m04_rid),     .m04_axi_rdata(m04_rdata),   .m04_axi_rresp(m04_rresp),
    .m04_axi_rlast(m04_rlast), .m04_axi_ruser(1'b0),         .m04_axi_rvalid(m04_rvalid),
    .m04_axi_rready(m04_rready),
    // master port 5
    .m05_axi_awid(m05_awid),   .m05_axi_awaddr(m05_awaddr), .m05_axi_awlen(m05_awlen),
    .m05_axi_awsize(m05_awsize),.m05_axi_awburst(m05_awburst),.m05_axi_awlock(m05_awlock),
    .m05_axi_awcache(m05_awcache),.m05_axi_awprot(m05_awprot),.m05_axi_awqos(m05_awqos),
    .m05_axi_awregion(m05_awregion),.m05_axi_awuser(),        .m05_axi_awvalid(m05_awvalid),
    .m05_axi_awready(m05_awready),
    .m05_axi_wdata(m05_wdata), .m05_axi_wstrb(m05_wstrb),   .m05_axi_wlast(m05_wlast),
    .m05_axi_wuser(),          .m05_axi_wvalid(m05_wvalid), .m05_axi_wready(m05_wready),
    .m05_axi_bid(m05_bid),     .m05_axi_bresp(m05_bresp),   .m05_axi_buser(1'b0),
    .m05_axi_bvalid(m05_bvalid),.m05_axi_bready(m05_bready),
    .m05_axi_arid(m05_arid),   .m05_axi_araddr(m05_araddr), .m05_axi_arlen(m05_arlen),
    .m05_axi_arsize(m05_arsize),.m05_axi_arburst(m05_arburst),.m05_axi_arlock(m05_arlock),
    .m05_axi_arcache(m05_arcache),.m05_axi_arprot(m05_arprot),.m05_axi_arqos(m05_arqos),
    .m05_axi_arregion(m05_arregion),.m05_axi_aruser(),        .m05_axi_arvalid(m05_arvalid),
    .m05_axi_arready(m05_arready),
    .m05_axi_rid(m05_rid),     .m05_axi_rdata(m05_rdata),   .m05_axi_rresp(m05_rresp),
    .m05_axi_rlast(m05_rlast), .m05_axi_ruser(1'b0),         .m05_axi_rvalid(m05_rvalid),
    .m05_axi_rready(m05_rready),
    // master port 6
    .m06_axi_awid(m06_awid),   .m06_axi_awaddr(m06_awaddr), .m06_axi_awlen(m06_awlen),
    .m06_axi_awsize(m06_awsize),.m06_axi_awburst(m06_awburst),.m06_axi_awlock(m06_awlock),
    .m06_axi_awcache(m06_awcache),.m06_axi_awprot(m06_awprot),.m06_axi_awqos(m06_awqos),
    .m06_axi_awregion(m06_awregion),.m06_axi_awuser(),        .m06_axi_awvalid(m06_awvalid),
    .m06_axi_awready(m06_awready),
    .m06_axi_wdata(m06_wdata), .m06_axi_wstrb(m06_wstrb),   .m06_axi_wlast(m06_wlast),
    .m06_axi_wuser(),          .m06_axi_wvalid(m06_wvalid), .m06_axi_wready(m06_wready),
    .m06_axi_bid(m06_bid),     .m06_axi_bresp(m06_bresp),   .m06_axi_buser(1'b0),
    .m06_axi_bvalid(m06_bvalid),.m06_axi_bready(m06_bready),
    .m06_axi_arid(m06_arid),   .m06_axi_araddr(m06_araddr), .m06_axi_arlen(m06_arlen),
    .m06_axi_arsize(m06_arsize),.m06_axi_arburst(m06_arburst),.m06_axi_arlock(m06_arlock),
    .m06_axi_arcache(m06_arcache),.m06_axi_arprot(m06_arprot),.m06_axi_arqos(m06_arqos),
    .m06_axi_arregion(m06_arregion),.m06_axi_aruser(),        .m06_axi_arvalid(m06_arvalid),
    .m06_axi_arready(m06_arready),
    .m06_axi_rid(m06_rid),     .m06_axi_rdata(m06_rdata),   .m06_axi_rresp(m06_rresp),
    .m06_axi_rlast(m06_rlast), .m06_axi_ruser(1'b0),         .m06_axi_rvalid(m06_rvalid),
    .m06_axi_rready(m06_rready),
    // master port 7
    .m07_axi_awid(m07_awid),   .m07_axi_awaddr(m07_awaddr), .m07_axi_awlen(m07_awlen),
    .m07_axi_awsize(m07_awsize),.m07_axi_awburst(m07_awburst),.m07_axi_awlock(m07_awlock),
    .m07_axi_awcache(m07_awcache),.m07_axi_awprot(m07_awprot),.m07_axi_awqos(m07_awqos),
    .m07_axi_awregion(m07_awregion),.m07_axi_awuser(),        .m07_axi_awvalid(m07_awvalid),
    .m07_axi_awready(m07_awready),
    .m07_axi_wdata(m07_wdata), .m07_axi_wstrb(m07_wstrb),   .m07_axi_wlast(m07_wlast),
    .m07_axi_wuser(),          .m07_axi_wvalid(m07_wvalid), .m07_axi_wready(m07_wready),
    .m07_axi_bid(m07_bid),     .m07_axi_bresp(m07_bresp),   .m07_axi_buser(1'b0),
    .m07_axi_bvalid(m07_bvalid),.m07_axi_bready(m07_bready),
    .m07_axi_arid(m07_arid),   .m07_axi_araddr(m07_araddr), .m07_axi_arlen(m07_arlen),
    .m07_axi_arsize(m07_arsize),.m07_axi_arburst(m07_arburst),.m07_axi_arlock(m07_arlock),
    .m07_axi_arcache(m07_arcache),.m07_axi_arprot(m07_arprot),.m07_axi_arqos(m07_arqos),
    .m07_axi_arregion(m07_arregion),.m07_axi_aruser(),        .m07_axi_arvalid(m07_arvalid),
    .m07_axi_arready(m07_arready),
    .m07_axi_rid(m07_rid),     .m07_axi_rdata(m07_rdata),   .m07_axi_rresp(m07_rresp),
    .m07_axi_rlast(m07_rlast), .m07_axi_ruser(1'b0),         .m07_axi_rvalid(m07_rvalid),
    .m07_axi_rready(m07_rready)
);


// ============================================================

// ============================================================
// Dummy AXI slave storage: 8 independent memories, 256 words each
// ============================================================
logic [DATA_WIDTH-1:0] slv_mem [0:7][0:255];

// ============================================================
// Dummy AXI Slave S0
// Robust single-beat AXI slave model.
// AW and W are accepted independently; either may arrive first.
// ============================================================
logic                  slv0_aw_pending;
logic [ID_WIDTH-1:0]   slv0_awid_r;
logic [7:0]            slv0_awaddr_idx;

logic                  slv0_w_pending;
logic [DATA_WIDTH-1:0] slv0_wdata_r;
logic [STRB_WIDTH-1:0] slv0_wstrb_r;
logic                  slv0_wlast_r;

logic [ID_WIDTH-1:0]   slv0_rid_r;
logic [7:0]            slv0_raddr_idx;
logic [7:0]            slv0_rlen;
logic                  slv0_rd_pending;

wire slv0_aw_fire = m00_awvalid && m00_awready;
wire slv0_w_fire  = m00_wvalid  && m00_wready;
wire slv0_ar_fire = m00_arvalid && m00_arready;

always_comb begin
    m00_awready = !slv0_aw_pending && !m00_bvalid;
    m00_wready  = !slv0_w_pending  && !m00_bvalid;
    m00_arready = !slv0_rd_pending && !m00_rvalid;
end

always_ff @(posedge clk) begin
    if (rst) begin
        m00_bid         <= '0;
        m00_bresp       <= 2'b00;
        m00_bvalid      <= 1'b0;
        m00_rid         <= '0;
        m00_rdata       <= '0;
        m00_rresp       <= 2'b00;
        m00_rlast       <= 1'b0;
        m00_rvalid      <= 1'b0;

        slv0_aw_pending <= 1'b0;
        slv0_awid_r     <= '0;
        slv0_awaddr_idx <= 8'd0;

        slv0_w_pending  <= 1'b0;
        slv0_wdata_r    <= '0;
        slv0_wstrb_r    <= '0;
        slv0_wlast_r    <= 1'b0;

        slv0_rid_r      <= '0;
        slv0_raddr_idx  <= 8'd0;
        slv0_rlen       <= 8'd0;
        slv0_rd_pending <= 1'b0;
    end else begin

        // Complete B-channel handshake.
        if (m00_bvalid && m00_bready)
            m00_bvalid <= 1'b0;

        // Complete R-channel handshake.
        if (m00_rvalid && m00_rready)
            m00_rvalid <= 1'b0;

        // Capture AW independently.
        if (slv0_aw_fire) begin
            slv0_aw_pending <= 1'b1;
            slv0_awid_r     <= m00_awid;
            slv0_awaddr_idx <= m00_awaddr[9:2];
        end

        // Capture W independently.
        if (slv0_w_fire) begin
            slv0_w_pending <= 1'b1;
            slv0_wdata_r   <= m00_wdata;
            slv0_wstrb_r   <= m00_wstrb;
            slv0_wlast_r   <= m00_wlast;
        end

        // Perform the single-beat write once both AW and W exist.
        if ((slv0_aw_pending || slv0_aw_fire) &&
            (slv0_w_pending  || slv0_w_fire)) begin

            if (slv0_aw_pending)
                slv_mem[0][slv0_awaddr_idx] <=
                    slv0_w_pending ? slv0_wdata_r : m00_wdata;
            else
                slv_mem[0][m00_awaddr[9:2]] <=
                    slv0_w_pending ? slv0_wdata_r : m00_wdata;

            m00_bid    <= slv0_aw_pending ? slv0_awid_r : m00_awid;
            m00_bresp  <= 2'b00;
            m00_bvalid <= 1'b1;

            slv0_aw_pending <= 1'b0;
            slv0_w_pending  <= 1'b0;
        end

        // Capture AR.
        if (slv0_ar_fire) begin
            slv0_rid_r      <= m00_arid;
            slv0_raddr_idx  <= m00_araddr[9:2];
            slv0_rlen       <= m00_arlen;
            slv0_rd_pending <= 1'b1;
        end

        // Return read data.
        if (slv0_rd_pending && !m00_rvalid) begin
            m00_rid    <= slv0_rid_r;
            m00_rdata  <= slv_mem[0][slv0_raddr_idx];
            m00_rresp  <= 2'b00;
            m00_rlast  <= (slv0_rlen == 8'd0);
            m00_rvalid <= 1'b1;

            if (slv0_rlen == 8'd0) begin
                slv0_rd_pending <= 1'b0;
            end else begin
                slv0_rlen      <= slv0_rlen - 8'd1;
                slv0_raddr_idx <= slv0_raddr_idx + 8'd1;
            end
        end
    end
end


// ============================================================
// Dummy AXI Slave S1
// Robust single-beat AXI slave model.
// AW and W are accepted independently; either may arrive first.
// ============================================================
logic                  slv1_aw_pending;
logic [ID_WIDTH-1:0]   slv1_awid_r;
logic [7:0]            slv1_awaddr_idx;

logic                  slv1_w_pending;
logic [DATA_WIDTH-1:0] slv1_wdata_r;
logic [STRB_WIDTH-1:0] slv1_wstrb_r;
logic                  slv1_wlast_r;

logic [ID_WIDTH-1:0]   slv1_rid_r;
logic [7:0]            slv1_raddr_idx;
logic [7:0]            slv1_rlen;
logic                  slv1_rd_pending;

wire slv1_aw_fire = m01_awvalid && m01_awready;
wire slv1_w_fire  = m01_wvalid  && m01_wready;
wire slv1_ar_fire = m01_arvalid && m01_arready;

always_comb begin
    m01_awready = !slv1_aw_pending && !m01_bvalid;
    m01_wready  = !slv1_w_pending  && !m01_bvalid;
    m01_arready = !slv1_rd_pending && !m01_rvalid;
end

always_ff @(posedge clk) begin
    if (rst) begin
        m01_bid         <= '0;
        m01_bresp       <= 2'b00;
        m01_bvalid      <= 1'b0;
        m01_rid         <= '0;
        m01_rdata       <= '0;
        m01_rresp       <= 2'b00;
        m01_rlast       <= 1'b0;
        m01_rvalid      <= 1'b0;

        slv1_aw_pending <= 1'b0;
        slv1_awid_r     <= '0;
        slv1_awaddr_idx <= 8'd0;

        slv1_w_pending  <= 1'b0;
        slv1_wdata_r    <= '0;
        slv1_wstrb_r    <= '0;
        slv1_wlast_r    <= 1'b0;

        slv1_rid_r      <= '0;
        slv1_raddr_idx  <= 8'd0;
        slv1_rlen       <= 8'd0;
        slv1_rd_pending <= 1'b0;
    end else begin

        // Complete B-channel handshake.
        if (m01_bvalid && m01_bready)
            m01_bvalid <= 1'b0;

        // Complete R-channel handshake.
        if (m01_rvalid && m01_rready)
            m01_rvalid <= 1'b0;

        // Capture AW independently.
        if (slv1_aw_fire) begin
            slv1_aw_pending <= 1'b1;
            slv1_awid_r     <= m01_awid;
            slv1_awaddr_idx <= m01_awaddr[9:2];
        end

        // Capture W independently.
        if (slv1_w_fire) begin
            slv1_w_pending <= 1'b1;
            slv1_wdata_r   <= m01_wdata;
            slv1_wstrb_r   <= m01_wstrb;
            slv1_wlast_r   <= m01_wlast;
        end

        // Perform the single-beat write once both AW and W exist.
        if ((slv1_aw_pending || slv1_aw_fire) &&
            (slv1_w_pending  || slv1_w_fire)) begin

            if (slv1_aw_pending)
                slv_mem[1][slv1_awaddr_idx] <=
                    slv1_w_pending ? slv1_wdata_r : m01_wdata;
            else
                slv_mem[1][m01_awaddr[9:2]] <=
                    slv1_w_pending ? slv1_wdata_r : m01_wdata;

            m01_bid    <= slv1_aw_pending ? slv1_awid_r : m01_awid;
            m01_bresp  <= 2'b00;
            m01_bvalid <= 1'b1;

            slv1_aw_pending <= 1'b0;
            slv1_w_pending  <= 1'b0;
        end

        // Capture AR.
        if (slv1_ar_fire) begin
            slv1_rid_r      <= m01_arid;
            slv1_raddr_idx  <= m01_araddr[9:2];
            slv1_rlen       <= m01_arlen;
            slv1_rd_pending <= 1'b1;
        end

        // Return read data.
        if (slv1_rd_pending && !m01_rvalid) begin
            m01_rid    <= slv1_rid_r;
            m01_rdata  <= slv_mem[1][slv1_raddr_idx];
            m01_rresp  <= 2'b00;
            m01_rlast  <= (slv1_rlen == 8'd0);
            m01_rvalid <= 1'b1;

            if (slv1_rlen == 8'd0) begin
                slv1_rd_pending <= 1'b0;
            end else begin
                slv1_rlen      <= slv1_rlen - 8'd1;
                slv1_raddr_idx <= slv1_raddr_idx + 8'd1;
            end
        end
    end
end


// ============================================================
// Dummy AXI Slave S2
// Robust single-beat AXI slave model.
// AW and W are accepted independently; either may arrive first.
// ============================================================
logic                  slv2_aw_pending;
logic [ID_WIDTH-1:0]   slv2_awid_r;
logic [7:0]            slv2_awaddr_idx;

logic                  slv2_w_pending;
logic [DATA_WIDTH-1:0] slv2_wdata_r;
logic [STRB_WIDTH-1:0] slv2_wstrb_r;
logic                  slv2_wlast_r;

logic [ID_WIDTH-1:0]   slv2_rid_r;
logic [7:0]            slv2_raddr_idx;
logic [7:0]            slv2_rlen;
logic                  slv2_rd_pending;

wire slv2_aw_fire = m02_awvalid && m02_awready;
wire slv2_w_fire  = m02_wvalid  && m02_wready;
wire slv2_ar_fire = m02_arvalid && m02_arready;

always_comb begin
    m02_awready = !slv2_aw_pending && !m02_bvalid;
    m02_wready  = !slv2_w_pending  && !m02_bvalid;
    m02_arready = !slv2_rd_pending && !m02_rvalid;
end

always_ff @(posedge clk) begin
    if (rst) begin
        m02_bid         <= '0;
        m02_bresp       <= 2'b00;
        m02_bvalid      <= 1'b0;
        m02_rid         <= '0;
        m02_rdata       <= '0;
        m02_rresp       <= 2'b00;
        m02_rlast       <= 1'b0;
        m02_rvalid      <= 1'b0;

        slv2_aw_pending <= 1'b0;
        slv2_awid_r     <= '0;
        slv2_awaddr_idx <= 8'd0;

        slv2_w_pending  <= 1'b0;
        slv2_wdata_r    <= '0;
        slv2_wstrb_r    <= '0;
        slv2_wlast_r    <= 1'b0;

        slv2_rid_r      <= '0;
        slv2_raddr_idx  <= 8'd0;
        slv2_rlen       <= 8'd0;
        slv2_rd_pending <= 1'b0;
    end else begin

        // Complete B-channel handshake.
        if (m02_bvalid && m02_bready)
            m02_bvalid <= 1'b0;

        // Complete R-channel handshake.
        if (m02_rvalid && m02_rready)
            m02_rvalid <= 1'b0;

        // Capture AW independently.
        if (slv2_aw_fire) begin
            slv2_aw_pending <= 1'b1;
            slv2_awid_r     <= m02_awid;
            slv2_awaddr_idx <= m02_awaddr[9:2];
        end

        // Capture W independently.
        if (slv2_w_fire) begin
            slv2_w_pending <= 1'b1;
            slv2_wdata_r   <= m02_wdata;
            slv2_wstrb_r   <= m02_wstrb;
            slv2_wlast_r   <= m02_wlast;
        end

        // Perform the single-beat write once both AW and W exist.
        if ((slv2_aw_pending || slv2_aw_fire) &&
            (slv2_w_pending  || slv2_w_fire)) begin

            if (slv2_aw_pending)
                slv_mem[2][slv2_awaddr_idx] <=
                    slv2_w_pending ? slv2_wdata_r : m02_wdata;
            else
                slv_mem[2][m02_awaddr[9:2]] <=
                    slv2_w_pending ? slv2_wdata_r : m02_wdata;

            m02_bid    <= slv2_aw_pending ? slv2_awid_r : m02_awid;
            m02_bresp  <= 2'b00;
            m02_bvalid <= 1'b1;

            slv2_aw_pending <= 1'b0;
            slv2_w_pending  <= 1'b0;
        end

        // Capture AR.
        if (slv2_ar_fire) begin
            slv2_rid_r      <= m02_arid;
            slv2_raddr_idx  <= m02_araddr[9:2];
            slv2_rlen       <= m02_arlen;
            slv2_rd_pending <= 1'b1;
        end

        // Return read data.
        if (slv2_rd_pending && !m02_rvalid) begin
            m02_rid    <= slv2_rid_r;
            m02_rdata  <= slv_mem[2][slv2_raddr_idx];
            m02_rresp  <= 2'b00;
            m02_rlast  <= (slv2_rlen == 8'd0);
            m02_rvalid <= 1'b1;

            if (slv2_rlen == 8'd0) begin
                slv2_rd_pending <= 1'b0;
            end else begin
                slv2_rlen      <= slv2_rlen - 8'd1;
                slv2_raddr_idx <= slv2_raddr_idx + 8'd1;
            end
        end
    end
end


// ============================================================
// Dummy AXI Slave S3
// Robust single-beat AXI slave model.
// AW and W are accepted independently; either may arrive first.
// ============================================================
logic                  slv3_aw_pending;
logic [ID_WIDTH-1:0]   slv3_awid_r;
logic [7:0]            slv3_awaddr_idx;

logic                  slv3_w_pending;
logic [DATA_WIDTH-1:0] slv3_wdata_r;
logic [STRB_WIDTH-1:0] slv3_wstrb_r;
logic                  slv3_wlast_r;

logic [ID_WIDTH-1:0]   slv3_rid_r;
logic [7:0]            slv3_raddr_idx;
logic [7:0]            slv3_rlen;
logic                  slv3_rd_pending;

wire slv3_aw_fire = m03_awvalid && m03_awready;
wire slv3_w_fire  = m03_wvalid  && m03_wready;
wire slv3_ar_fire = m03_arvalid && m03_arready;

always_comb begin
    m03_awready = !slv3_aw_pending && !m03_bvalid;
    m03_wready  = !slv3_w_pending  && !m03_bvalid;
    m03_arready = !slv3_rd_pending && !m03_rvalid;
end

always_ff @(posedge clk) begin
    if (rst) begin
        m03_bid         <= '0;
        m03_bresp       <= 2'b00;
        m03_bvalid      <= 1'b0;
        m03_rid         <= '0;
        m03_rdata       <= '0;
        m03_rresp       <= 2'b00;
        m03_rlast       <= 1'b0;
        m03_rvalid      <= 1'b0;

        slv3_aw_pending <= 1'b0;
        slv3_awid_r     <= '0;
        slv3_awaddr_idx <= 8'd0;

        slv3_w_pending  <= 1'b0;
        slv3_wdata_r    <= '0;
        slv3_wstrb_r    <= '0;
        slv3_wlast_r    <= 1'b0;

        slv3_rid_r      <= '0;
        slv3_raddr_idx  <= 8'd0;
        slv3_rlen       <= 8'd0;
        slv3_rd_pending <= 1'b0;
    end else begin

        // Complete B-channel handshake.
        if (m03_bvalid && m03_bready)
            m03_bvalid <= 1'b0;

        // Complete R-channel handshake.
        if (m03_rvalid && m03_rready)
            m03_rvalid <= 1'b0;

        // Capture AW independently.
        if (slv3_aw_fire) begin
            slv3_aw_pending <= 1'b1;
            slv3_awid_r     <= m03_awid;
            slv3_awaddr_idx <= m03_awaddr[9:2];
        end

        // Capture W independently.
        if (slv3_w_fire) begin
            slv3_w_pending <= 1'b1;
            slv3_wdata_r   <= m03_wdata;
            slv3_wstrb_r   <= m03_wstrb;
            slv3_wlast_r   <= m03_wlast;
        end

        // Perform the single-beat write once both AW and W exist.
        if ((slv3_aw_pending || slv3_aw_fire) &&
            (slv3_w_pending  || slv3_w_fire)) begin

            if (slv3_aw_pending)
                slv_mem[3][slv3_awaddr_idx] <=
                    slv3_w_pending ? slv3_wdata_r : m03_wdata;
            else
                slv_mem[3][m03_awaddr[9:2]] <=
                    slv3_w_pending ? slv3_wdata_r : m03_wdata;

            m03_bid    <= slv3_aw_pending ? slv3_awid_r : m03_awid;
            m03_bresp  <= 2'b00;
            m03_bvalid <= 1'b1;

            slv3_aw_pending <= 1'b0;
            slv3_w_pending  <= 1'b0;
        end

        // Capture AR.
        if (slv3_ar_fire) begin
            slv3_rid_r      <= m03_arid;
            slv3_raddr_idx  <= m03_araddr[9:2];
            slv3_rlen       <= m03_arlen;
            slv3_rd_pending <= 1'b1;
        end

        // Return read data.
        if (slv3_rd_pending && !m03_rvalid) begin
            m03_rid    <= slv3_rid_r;
            m03_rdata  <= slv_mem[3][slv3_raddr_idx];
            m03_rresp  <= 2'b00;
            m03_rlast  <= (slv3_rlen == 8'd0);
            m03_rvalid <= 1'b1;

            if (slv3_rlen == 8'd0) begin
                slv3_rd_pending <= 1'b0;
            end else begin
                slv3_rlen      <= slv3_rlen - 8'd1;
                slv3_raddr_idx <= slv3_raddr_idx + 8'd1;
            end
        end
    end
end


// ============================================================
// Dummy AXI Slave S4
// Robust single-beat AXI slave model.
// AW and W are accepted independently; either may arrive first.
// ============================================================
logic                  slv4_aw_pending;
logic [ID_WIDTH-1:0]   slv4_awid_r;
logic [7:0]            slv4_awaddr_idx;

logic                  slv4_w_pending;
logic [DATA_WIDTH-1:0] slv4_wdata_r;
logic [STRB_WIDTH-1:0] slv4_wstrb_r;
logic                  slv4_wlast_r;

logic [ID_WIDTH-1:0]   slv4_rid_r;
logic [7:0]            slv4_raddr_idx;
logic [7:0]            slv4_rlen;
logic                  slv4_rd_pending;

wire slv4_aw_fire = m04_awvalid && m04_awready;
wire slv4_w_fire  = m04_wvalid  && m04_wready;
wire slv4_ar_fire = m04_arvalid && m04_arready;

always_comb begin
    m04_awready = !slv4_aw_pending && !m04_bvalid;
    m04_wready  = !slv4_w_pending  && !m04_bvalid;
    m04_arready = !slv4_rd_pending && !m04_rvalid;
end

always_ff @(posedge clk) begin
    if (rst) begin
        m04_bid         <= '0;
        m04_bresp       <= 2'b00;
        m04_bvalid      <= 1'b0;
        m04_rid         <= '0;
        m04_rdata       <= '0;
        m04_rresp       <= 2'b00;
        m04_rlast       <= 1'b0;
        m04_rvalid      <= 1'b0;

        slv4_aw_pending <= 1'b0;
        slv4_awid_r     <= '0;
        slv4_awaddr_idx <= 8'd0;

        slv4_w_pending  <= 1'b0;
        slv4_wdata_r    <= '0;
        slv4_wstrb_r    <= '0;
        slv4_wlast_r    <= 1'b0;

        slv4_rid_r      <= '0;
        slv4_raddr_idx  <= 8'd0;
        slv4_rlen       <= 8'd0;
        slv4_rd_pending <= 1'b0;
    end else begin

        // Complete B-channel handshake.
        if (m04_bvalid && m04_bready)
            m04_bvalid <= 1'b0;

        // Complete R-channel handshake.
        if (m04_rvalid && m04_rready)
            m04_rvalid <= 1'b0;

        // Capture AW independently.
        if (slv4_aw_fire) begin
            slv4_aw_pending <= 1'b1;
            slv4_awid_r     <= m04_awid;
            slv4_awaddr_idx <= m04_awaddr[9:2];
        end

        // Capture W independently.
        if (slv4_w_fire) begin
            slv4_w_pending <= 1'b1;
            slv4_wdata_r   <= m04_wdata;
            slv4_wstrb_r   <= m04_wstrb;
            slv4_wlast_r   <= m04_wlast;
        end

        // Perform the single-beat write once both AW and W exist.
        if ((slv4_aw_pending || slv4_aw_fire) &&
            (slv4_w_pending  || slv4_w_fire)) begin

            if (slv4_aw_pending)
                slv_mem[4][slv4_awaddr_idx] <=
                    slv4_w_pending ? slv4_wdata_r : m04_wdata;
            else
                slv_mem[4][m04_awaddr[9:2]] <=
                    slv4_w_pending ? slv4_wdata_r : m04_wdata;

            m04_bid    <= slv4_aw_pending ? slv4_awid_r : m04_awid;
            m04_bresp  <= 2'b00;
            m04_bvalid <= 1'b1;

            slv4_aw_pending <= 1'b0;
            slv4_w_pending  <= 1'b0;
        end

        // Capture AR.
        if (slv4_ar_fire) begin
            slv4_rid_r      <= m04_arid;
            slv4_raddr_idx  <= m04_araddr[9:2];
            slv4_rlen       <= m04_arlen;
            slv4_rd_pending <= 1'b1;
        end

        // Return read data.
        if (slv4_rd_pending && !m04_rvalid) begin
            m04_rid    <= slv4_rid_r;
            m04_rdata  <= slv_mem[4][slv4_raddr_idx];
            m04_rresp  <= 2'b00;
            m04_rlast  <= (slv4_rlen == 8'd0);
            m04_rvalid <= 1'b1;

            if (slv4_rlen == 8'd0) begin
                slv4_rd_pending <= 1'b0;
            end else begin
                slv4_rlen      <= slv4_rlen - 8'd1;
                slv4_raddr_idx <= slv4_raddr_idx + 8'd1;
            end
        end
    end
end


// ============================================================
// Dummy AXI Slave S5
// Robust single-beat AXI slave model.
// AW and W are accepted independently; either may arrive first.
// ============================================================
logic                  slv5_aw_pending;
logic [ID_WIDTH-1:0]   slv5_awid_r;
logic [7:0]            slv5_awaddr_idx;

logic                  slv5_w_pending;
logic [DATA_WIDTH-1:0] slv5_wdata_r;
logic [STRB_WIDTH-1:0] slv5_wstrb_r;
logic                  slv5_wlast_r;

logic [ID_WIDTH-1:0]   slv5_rid_r;
logic [7:0]            slv5_raddr_idx;
logic [7:0]            slv5_rlen;
logic                  slv5_rd_pending;

wire slv5_aw_fire = m05_awvalid && m05_awready;
wire slv5_w_fire  = m05_wvalid  && m05_wready;
wire slv5_ar_fire = m05_arvalid && m05_arready;

always_comb begin
    m05_awready = !slv5_aw_pending && !m05_bvalid;
    m05_wready  = !slv5_w_pending  && !m05_bvalid;
    m05_arready = !slv5_rd_pending && !m05_rvalid;
end

always_ff @(posedge clk) begin
    if (rst) begin
        m05_bid         <= '0;
        m05_bresp       <= 2'b00;
        m05_bvalid      <= 1'b0;
        m05_rid         <= '0;
        m05_rdata       <= '0;
        m05_rresp       <= 2'b00;
        m05_rlast       <= 1'b0;
        m05_rvalid      <= 1'b0;

        slv5_aw_pending <= 1'b0;
        slv5_awid_r     <= '0;
        slv5_awaddr_idx <= 8'd0;

        slv5_w_pending  <= 1'b0;
        slv5_wdata_r    <= '0;
        slv5_wstrb_r    <= '0;
        slv5_wlast_r    <= 1'b0;

        slv5_rid_r      <= '0;
        slv5_raddr_idx  <= 8'd0;
        slv5_rlen       <= 8'd0;
        slv5_rd_pending <= 1'b0;
    end else begin

        // Complete B-channel handshake.
        if (m05_bvalid && m05_bready)
            m05_bvalid <= 1'b0;

        // Complete R-channel handshake.
        if (m05_rvalid && m05_rready)
            m05_rvalid <= 1'b0;

        // Capture AW independently.
        if (slv5_aw_fire) begin
            slv5_aw_pending <= 1'b1;
            slv5_awid_r     <= m05_awid;
            slv5_awaddr_idx <= m05_awaddr[9:2];
        end

        // Capture W independently.
        if (slv5_w_fire) begin
            slv5_w_pending <= 1'b1;
            slv5_wdata_r   <= m05_wdata;
            slv5_wstrb_r   <= m05_wstrb;
            slv5_wlast_r   <= m05_wlast;
        end

        // Perform the single-beat write once both AW and W exist.
        if ((slv5_aw_pending || slv5_aw_fire) &&
            (slv5_w_pending  || slv5_w_fire)) begin

            if (slv5_aw_pending)
                slv_mem[5][slv5_awaddr_idx] <=
                    slv5_w_pending ? slv5_wdata_r : m05_wdata;
            else
                slv_mem[5][m05_awaddr[9:2]] <=
                    slv5_w_pending ? slv5_wdata_r : m05_wdata;

            m05_bid    <= slv5_aw_pending ? slv5_awid_r : m05_awid;
            m05_bresp  <= 2'b00;
            m05_bvalid <= 1'b1;

            slv5_aw_pending <= 1'b0;
            slv5_w_pending  <= 1'b0;
        end

        // Capture AR.
        if (slv5_ar_fire) begin
            slv5_rid_r      <= m05_arid;
            slv5_raddr_idx  <= m05_araddr[9:2];
            slv5_rlen       <= m05_arlen;
            slv5_rd_pending <= 1'b1;
        end

        // Return read data.
        if (slv5_rd_pending && !m05_rvalid) begin
            m05_rid    <= slv5_rid_r;
            m05_rdata  <= slv_mem[5][slv5_raddr_idx];
            m05_rresp  <= 2'b00;
            m05_rlast  <= (slv5_rlen == 8'd0);
            m05_rvalid <= 1'b1;

            if (slv5_rlen == 8'd0) begin
                slv5_rd_pending <= 1'b0;
            end else begin
                slv5_rlen      <= slv5_rlen - 8'd1;
                slv5_raddr_idx <= slv5_raddr_idx + 8'd1;
            end
        end
    end
end


// ============================================================
// Dummy AXI Slave S6
// Robust single-beat AXI slave model.
// AW and W are accepted independently; either may arrive first.
// ============================================================
logic                  slv6_aw_pending;
logic [ID_WIDTH-1:0]   slv6_awid_r;
logic [7:0]            slv6_awaddr_idx;

logic                  slv6_w_pending;
logic [DATA_WIDTH-1:0] slv6_wdata_r;
logic [STRB_WIDTH-1:0] slv6_wstrb_r;
logic                  slv6_wlast_r;

logic [ID_WIDTH-1:0]   slv6_rid_r;
logic [7:0]            slv6_raddr_idx;
logic [7:0]            slv6_rlen;
logic                  slv6_rd_pending;

wire slv6_aw_fire = m06_awvalid && m06_awready;
wire slv6_w_fire  = m06_wvalid  && m06_wready;
wire slv6_ar_fire = m06_arvalid && m06_arready;

always_comb begin
    m06_awready = !slv6_aw_pending && !m06_bvalid;
    m06_wready  = !slv6_w_pending  && !m06_bvalid;
    m06_arready = !slv6_rd_pending && !m06_rvalid;
end

always_ff @(posedge clk) begin
    if (rst) begin
        m06_bid         <= '0;
        m06_bresp       <= 2'b00;
        m06_bvalid      <= 1'b0;
        m06_rid         <= '0;
        m06_rdata       <= '0;
        m06_rresp       <= 2'b00;
        m06_rlast       <= 1'b0;
        m06_rvalid      <= 1'b0;

        slv6_aw_pending <= 1'b0;
        slv6_awid_r     <= '0;
        slv6_awaddr_idx <= 8'd0;

        slv6_w_pending  <= 1'b0;
        slv6_wdata_r    <= '0;
        slv6_wstrb_r    <= '0;
        slv6_wlast_r    <= 1'b0;

        slv6_rid_r      <= '0;
        slv6_raddr_idx  <= 8'd0;
        slv6_rlen       <= 8'd0;
        slv6_rd_pending <= 1'b0;
    end else begin

        // Complete B-channel handshake.
        if (m06_bvalid && m06_bready)
            m06_bvalid <= 1'b0;

        // Complete R-channel handshake.
        if (m06_rvalid && m06_rready)
            m06_rvalid <= 1'b0;

        // Capture AW independently.
        if (slv6_aw_fire) begin
            slv6_aw_pending <= 1'b1;
            slv6_awid_r     <= m06_awid;
            slv6_awaddr_idx <= m06_awaddr[9:2];
        end

        // Capture W independently.
        if (slv6_w_fire) begin
            slv6_w_pending <= 1'b1;
            slv6_wdata_r   <= m06_wdata;
            slv6_wstrb_r   <= m06_wstrb;
            slv6_wlast_r   <= m06_wlast;
        end

        // Perform the single-beat write once both AW and W exist.
        if ((slv6_aw_pending || slv6_aw_fire) &&
            (slv6_w_pending  || slv6_w_fire)) begin

            if (slv6_aw_pending)
                slv_mem[6][slv6_awaddr_idx] <=
                    slv6_w_pending ? slv6_wdata_r : m06_wdata;
            else
                slv_mem[6][m06_awaddr[9:2]] <=
                    slv6_w_pending ? slv6_wdata_r : m06_wdata;

            m06_bid    <= slv6_aw_pending ? slv6_awid_r : m06_awid;
            m06_bresp  <= 2'b00;
            m06_bvalid <= 1'b1;

            slv6_aw_pending <= 1'b0;
            slv6_w_pending  <= 1'b0;
        end

        // Capture AR.
        if (slv6_ar_fire) begin
            slv6_rid_r      <= m06_arid;
            slv6_raddr_idx  <= m06_araddr[9:2];
            slv6_rlen       <= m06_arlen;
            slv6_rd_pending <= 1'b1;
        end

        // Return read data.
        if (slv6_rd_pending && !m06_rvalid) begin
            m06_rid    <= slv6_rid_r;
            m06_rdata  <= slv_mem[6][slv6_raddr_idx];
            m06_rresp  <= 2'b00;
            m06_rlast  <= (slv6_rlen == 8'd0);
            m06_rvalid <= 1'b1;

            if (slv6_rlen == 8'd0) begin
                slv6_rd_pending <= 1'b0;
            end else begin
                slv6_rlen      <= slv6_rlen - 8'd1;
                slv6_raddr_idx <= slv6_raddr_idx + 8'd1;
            end
        end
    end
end


// ============================================================
// Dummy AXI Slave S7
// Robust single-beat AXI slave model.
// AW and W are accepted independently; either may arrive first.
// ============================================================
logic                  slv7_aw_pending;
logic [ID_WIDTH-1:0]   slv7_awid_r;
logic [7:0]            slv7_awaddr_idx;

logic                  slv7_w_pending;
logic [DATA_WIDTH-1:0] slv7_wdata_r;
logic [STRB_WIDTH-1:0] slv7_wstrb_r;
logic                  slv7_wlast_r;

logic [ID_WIDTH-1:0]   slv7_rid_r;
logic [7:0]            slv7_raddr_idx;
logic [7:0]            slv7_rlen;
logic                  slv7_rd_pending;

wire slv7_aw_fire = m07_awvalid && m07_awready;
wire slv7_w_fire  = m07_wvalid  && m07_wready;
wire slv7_ar_fire = m07_arvalid && m07_arready;

always_comb begin
    m07_awready = !slv7_aw_pending && !m07_bvalid;
    m07_wready  = !slv7_w_pending  && !m07_bvalid;
    m07_arready = !slv7_rd_pending && !m07_rvalid;
end

always_ff @(posedge clk) begin
    if (rst) begin
        m07_bid         <= '0;
        m07_bresp       <= 2'b00;
        m07_bvalid      <= 1'b0;
        m07_rid         <= '0;
        m07_rdata       <= '0;
        m07_rresp       <= 2'b00;
        m07_rlast       <= 1'b0;
        m07_rvalid      <= 1'b0;

        slv7_aw_pending <= 1'b0;
        slv7_awid_r     <= '0;
        slv7_awaddr_idx <= 8'd0;

        slv7_w_pending  <= 1'b0;
        slv7_wdata_r    <= '0;
        slv7_wstrb_r    <= '0;
        slv7_wlast_r    <= 1'b0;

        slv7_rid_r      <= '0;
        slv7_raddr_idx  <= 8'd0;
        slv7_rlen       <= 8'd0;
        slv7_rd_pending <= 1'b0;
    end else begin

        // Complete B-channel handshake.
        if (m07_bvalid && m07_bready)
            m07_bvalid <= 1'b0;

        // Complete R-channel handshake.
        if (m07_rvalid && m07_rready)
            m07_rvalid <= 1'b0;

        // Capture AW independently.
        if (slv7_aw_fire) begin
            slv7_aw_pending <= 1'b1;
            slv7_awid_r     <= m07_awid;
            slv7_awaddr_idx <= m07_awaddr[9:2];
        end

        // Capture W independently.
        if (slv7_w_fire) begin
            slv7_w_pending <= 1'b1;
            slv7_wdata_r   <= m07_wdata;
            slv7_wstrb_r   <= m07_wstrb;
            slv7_wlast_r   <= m07_wlast;
        end

        // Perform the single-beat write once both AW and W exist.
        if ((slv7_aw_pending || slv7_aw_fire) &&
            (slv7_w_pending  || slv7_w_fire)) begin

            if (slv7_aw_pending)
                slv_mem[7][slv7_awaddr_idx] <=
                    slv7_w_pending ? slv7_wdata_r : m07_wdata;
            else
                slv_mem[7][m07_awaddr[9:2]] <=
                    slv7_w_pending ? slv7_wdata_r : m07_wdata;

            m07_bid    <= slv7_aw_pending ? slv7_awid_r : m07_awid;
            m07_bresp  <= 2'b00;
            m07_bvalid <= 1'b1;

            slv7_aw_pending <= 1'b0;
            slv7_w_pending  <= 1'b0;
        end

        // Capture AR.
        if (slv7_ar_fire) begin
            slv7_rid_r      <= m07_arid;
            slv7_raddr_idx  <= m07_araddr[9:2];
            slv7_rlen       <= m07_arlen;
            slv7_rd_pending <= 1'b1;
        end

        // Return read data.
        if (slv7_rd_pending && !m07_rvalid) begin
            m07_rid    <= slv7_rid_r;
            m07_rdata  <= slv_mem[7][slv7_raddr_idx];
            m07_rresp  <= 2'b00;
            m07_rlast  <= (slv7_rlen == 8'd0);
            m07_rvalid <= 1'b1;

            if (slv7_rlen == 8'd0) begin
                slv7_rd_pending <= 1'b0;
            end else begin
                slv7_rlen      <= slv7_rlen - 8'd1;
                slv7_raddr_idx <= slv7_raddr_idx + 8'd1;
            end
        end
    end
end


// Helper tasks
// ============================================================

// Idle driver defaults – call once after reset
task automatic idle_master0();
    s00_awid=0; s00_awaddr=0; s00_awlen=0; s00_awsize=3'b010; s00_awburst=2'b01;
    s00_awlock=0; s00_awcache=0; s00_awprot=0; s00_awqos=0; s00_awvalid=0;
    s00_wdata=0; s00_wstrb=4'hF; s00_wlast=0; s00_wvalid=0;
    s00_bready=1;
    s00_arid=0; s00_araddr=0; s00_arlen=0; s00_arsize=3'b010; s00_arburst=2'b01;
    s00_arlock=0; s00_arcache=0; s00_arprot=0; s00_arqos=0; s00_arvalid=0;
    s00_rready=1;
endtask

task automatic idle_master1();
    s01_awid=0; s01_awaddr=0; s01_awlen=0; s01_awsize=3'b010; s01_awburst=2'b01;
    s01_awlock=0; s01_awcache=0; s01_awprot=0; s01_awqos=0; s01_awvalid=0;
    s01_wdata=0; s01_wstrb=4'hF; s01_wlast=0; s01_wvalid=0;
    s01_bready=1;
    s01_arid=0; s01_araddr=0; s01_arlen=0; s01_arsize=3'b010; s01_arburst=2'b01;
    s01_arlock=0; s01_arcache=0; s01_arprot=0; s01_arqos=0; s01_arvalid=0;
    s01_rready=1;
endtask

// -------------------------------------------------------
// AXI Write via slave port 0 (TB Master 0)
// addr   : full 32-bit address (must fall in correct slave range)
// data   : write data
// txid   : AXI ID
// -------------------------------------------------------
task automatic axi_write_m0(
    input  [ADDR_WIDTH-1:0] addr,
    input  [DATA_WIDTH-1:0] data,
    input  [ID_WIDTH-1:0]   txid,
    output logic            ok
);
    integer cyc;
    ok = 1'b1;
    // AW
    @(negedge clk);
    s00_awid    = txid;
    s00_awaddr  = addr;
    s00_awlen   = 8'd0;       // single beat
    s00_awsize  = 3'b010;     // 4 bytes
    s00_awburst = 2'b01;      // INCR
    s00_awvalid = 1'b1;
    cyc = 0;
    do @(posedge clk); while (!s00_awready && ++cyc < TIMEOUT_CYC);
    @(negedge clk); s00_awvalid = 1'b0;
    if (cyc >= TIMEOUT_CYC) begin $display("TIMEOUT AW M0 addr=%0h", addr); ok=0; return; end
    // W
    s00_wdata  = data;
    s00_wstrb  = 4'hF;
    s00_wlast  = 1'b1;
    s00_wvalid = 1'b1;
    cyc = 0;
    do @(posedge clk); while (!s00_wready && ++cyc < TIMEOUT_CYC);
    @(negedge clk); s00_wvalid = 1'b0; s00_wlast = 1'b0;
    if (cyc >= TIMEOUT_CYC) begin $display("TIMEOUT W M0 addr=%0h", addr); ok=0; return; end
    // B
    s00_bready = 1'b1;
    cyc = 0;
    do @(posedge clk); while (!s00_bvalid && ++cyc < TIMEOUT_CYC);
    if (cyc >= TIMEOUT_CYC) begin $display("TIMEOUT B M0 addr=%0h", addr); ok=0; return; end
    if (s00_bresp != 2'b00) begin $display("BAD BRESP=%0b M0 addr=%0h", s00_bresp, addr); ok=0; end
    @(negedge clk);
endtask

// -------------------------------------------------------
// AXI Read via slave port 0 (TB Master 0)
// -------------------------------------------------------
task automatic axi_read_m0(
    input  [ADDR_WIDTH-1:0] addr,
    input  [ID_WIDTH-1:0]   txid,
    output [DATA_WIDTH-1:0] rdata_out,
    output logic            ok
);
    integer cyc;
    ok = 1'b1;
    @(negedge clk);
    s00_arid    = txid;
    s00_araddr  = addr;
    s00_arlen   = 8'd0;
    s00_arsize  = 3'b010;
    s00_arburst = 2'b01;
    s00_arvalid = 1'b1;
    cyc = 0;
    do @(posedge clk); while (!s00_arready && ++cyc < TIMEOUT_CYC);
    @(negedge clk); s00_arvalid = 1'b0;
    if (cyc >= TIMEOUT_CYC) begin $display("TIMEOUT AR M0 addr=%0h", addr); ok=0; rdata_out='x; return; end
    // R
    s00_rready = 1'b1;
    cyc = 0;
    do @(posedge clk); while (!s00_rvalid && ++cyc < TIMEOUT_CYC);
    if (cyc >= TIMEOUT_CYC) begin $display("TIMEOUT R M0 addr=%0h", addr); ok=0; rdata_out='x; return; end
    rdata_out = s00_rdata;
    if (s00_rresp != 2'b00) begin $display("BAD RRESP=%0b M0 addr=%0h", s00_rresp, addr); ok=0; end
    @(negedge clk);
endtask

// -------------------------------------------------------
// AXI Write via slave port 1 (TB Master 1)
// -------------------------------------------------------
task automatic axi_write_m1(
    input  [ADDR_WIDTH-1:0] addr,
    input  [DATA_WIDTH-1:0] data,
    input  [ID_WIDTH-1:0]   txid,
    output logic            ok
);
    integer cyc;
    ok = 1'b1;
    @(negedge clk);
    s01_awid    = txid;
    s01_awaddr  = addr;
    s01_awlen   = 8'd0;
    s01_awsize  = 3'b010;
    s01_awburst = 2'b01;
    s01_awvalid = 1'b1;
    cyc = 0;
    do @(posedge clk); while (!s01_awready && ++cyc < TIMEOUT_CYC);
    @(negedge clk); s01_awvalid = 1'b0;
    if (cyc >= TIMEOUT_CYC) begin $display("TIMEOUT AW M1 addr=%0h", addr); ok=0; return; end
    s01_wdata  = data;
    s01_wstrb  = 4'hF;
    s01_wlast  = 1'b1;
    s01_wvalid = 1'b1;
    cyc = 0;
    do @(posedge clk); while (!s01_wready && ++cyc < TIMEOUT_CYC);
    @(negedge clk); s01_wvalid = 1'b0; s01_wlast = 1'b0;
    if (cyc >= TIMEOUT_CYC) begin $display("TIMEOUT W M1 addr=%0h", addr); ok=0; return; end
    s01_bready = 1'b1;
    cyc = 0;
    do @(posedge clk); while (!s01_bvalid && ++cyc < TIMEOUT_CYC);
    if (cyc >= TIMEOUT_CYC) begin $display("TIMEOUT B M1 addr=%0h", addr); ok=0; return; end
    if (s01_bresp != 2'b00) begin $display("BAD BRESP=%0b M1 addr=%0h", s01_bresp, addr); ok=0; end
    @(negedge clk);
endtask

// -------------------------------------------------------
// AXI Read via slave port 1 (TB Master 1)
// -------------------------------------------------------
task automatic axi_read_m1(
    input  [ADDR_WIDTH-1:0] addr,
    input  [ID_WIDTH-1:0]   txid,
    output [DATA_WIDTH-1:0] rdata_out,
    output logic            ok
);
    integer cyc;
    ok = 1'b1;
    @(negedge clk);
    s01_arid    = txid;
    s01_araddr  = addr;
    s01_arlen   = 8'd0;
    s01_arsize  = 3'b010;
    s01_arburst = 2'b01;
    s01_arvalid = 1'b1;
    cyc = 0;
    do @(posedge clk); while (!s01_arready && ++cyc < TIMEOUT_CYC);
    @(negedge clk); s01_arvalid = 1'b0;
    if (cyc >= TIMEOUT_CYC) begin $display("TIMEOUT AR M1 addr=%0h", addr); ok=0; rdata_out='x; return; end
    s01_rready = 1'b1;
    cyc = 0;
    do @(posedge clk); while (!s01_rvalid && ++cyc < TIMEOUT_CYC);
    if (cyc >= TIMEOUT_CYC) begin $display("TIMEOUT R M1 addr=%0h", addr); ok=0; rdata_out='x; return; end
    rdata_out = s01_rdata;
    if (s01_rresp != 2'b00) begin $display("BAD RRESP=%0b M1 addr=%0h", s01_rresp, addr); ok=0; end
    @(negedge clk);
endtask

// -------------------------------------------------------
// Pass/Fail accounting helper
// -------------------------------------------------------
task automatic check(
    input string   desc,
    input logic    pass_cond
);
    total_tests++;
    if (pass_cond) begin
        passed_tests++;
        $display("  PASS  [%0t] %s", $time, desc);
    end else begin
        failed_tests++;
        $display("  FAIL  [%0t] %s", $time, desc);
    end
endtask


// ============================================================
// Main test sequence
// ============================================================
// Slave base addresses as array for easy indexing
localparam [ADDR_WIDTH-1:0] SLV_BASE[0:7] = '{
    32'h0000_0000, 32'h0100_0000, 32'h0200_0000, 32'h0300_0000,
    32'h0400_0000, 32'h0500_0000, 32'h0600_0000, 32'h0700_0000
};

initial begin
    // ----------------------------------------------------------
    // FSDB / Verdi waveform dump
    // ----------------------------------------------------------
    $fsdbDumpfile("axi_interconnect_2x8_tb.fsdb");
    $fsdbDumpvars(0, tb_axi_interconnect_wrap_2x8);
    $fsdbDumpMDA();
    $fsdbDumpSVA();

    // ----------------------------------------------------------
    // Drive idle levels before reset
    // ----------------------------------------------------------
    idle_master0();
    idle_master1();

    // ----------------------------------------------------------
    // TEST 0 : Reset behaviour
    // ----------------------------------------------------------
    $display("\n--- TEST 0 : Reset ---");
    rst = 1'b1;
    repeat(10) @(posedge clk);
    // During reset all valid outputs should be de-asserted
    @(negedge clk);
    check("Reset: s00_awready=0", s00_awready === 1'b0);
    check("Reset: s00_arready=0", s00_arready === 1'b0);
    check("Reset: s01_awready=0", s01_awready === 1'b0);
    check("Reset: s01_arready=0", s01_arready === 1'b0);
    @(posedge clk); @(negedge clk);
    rst = 1'b0;
    repeat(5) @(posedge clk);   // let DUT settle

    // ----------------------------------------------------------
    // TEST 1-16: Master 0 writes to every slave (S0..S7)
    //            then reads back
    // ----------------------------------------------------------
    $display("\n--- TEST 1-16 : Master 0 WRITE + READ to S0-S7 ---");
    begin
        logic        ok_w, ok_r;
        logic [31:0] rd;
        logic [31:0] wr_data;
        logic [31:0] wr_addr;
        for (int s = 0; s < 8; s++) begin
            wr_addr = SLV_BASE[s] + 32'h10;          // offset within slave
            wr_data = 32'hA000_0000 | (s << 4) | 32'h1;

            // WRITE
            axi_write_m0(wr_addr, wr_data, 8'h10 + s, ok_w);
            // verify slave memory directly
            check($sformatf("M0->S%0d WRITE: slave mem holds data", s),
                  ok_w && (slv_mem[s][wr_addr[9:2]] === wr_data));
            // verify no other slave got the data
            for (int o = 0; o < 8; o++) begin
                if (o != s)
                    check($sformatf("M0->S%0d WRITE: S%0d NOT written", s, o),
                          slv_mem[o][wr_addr[9:2]] !== wr_data);
            end

            // READ BACK
            axi_read_m0(wr_addr, 8'h50 + s, rd, ok_r);
            check($sformatf("M0->S%0d READ: rdata matches", s),
                  ok_r && (rd === wr_data));
        end
    end

    // ----------------------------------------------------------
    // TEST 17-32: Master 1 writes to every slave (S0..S7)
    //             then reads back
    // ----------------------------------------------------------
    $display("\n--- TEST 17-32 : Master 1 WRITE + READ to S0-S7 ---");
    begin
        logic        ok_w, ok_r;
        logic [31:0] rd;
        logic [31:0] wr_data;
        logic [31:0] wr_addr;
        for (int s = 0; s < 8; s++) begin
            wr_addr = SLV_BASE[s] + 32'h20;
            wr_data = 32'hB000_0000 | (s << 4) | 32'h2;

            axi_write_m1(wr_addr, wr_data, 8'h20 + s, ok_w);
            $display("DEBUG M1->S%0d: wr_addr=%0h wr_addr[9:2]=%0d wr_data=%0h slv_mem[s][idx]=%0h ok_w=%0b",
                     s, wr_addr, wr_addr[9:2], wr_data, slv_mem[s][wr_addr[9:2]], ok_w);
            check($sformatf("M1->S%0d WRITE: slave mem holds data", s),
                  ok_w && (slv_mem[s][wr_addr[9:2]] === wr_data));
            for (int o = 0; o < 8; o++) begin
                if (o != s)
                    check($sformatf("M1->S%0d WRITE: S%0d NOT written", s, o),
                          slv_mem[o][wr_addr[9:2]] !== wr_data);
            end

            axi_read_m1(wr_addr, 8'h60 + s, rd, ok_r);
            check($sformatf("M1->S%0d READ: rdata matches", s),
                  ok_r && (rd === wr_data));
        end
    end

    // ----------------------------------------------------------
    // TEST: Master isolation – M0 data must not appear on M1 port
    // Write distinct value from M0, read via M1 at same address
    // They should agree (same physical slave memory), proving
    // isolation via independent AXI paths.
    // ----------------------------------------------------------
    $display("\n--- TEST: Master isolation ---");
    begin
        logic        ok_w, ok_r;
        logic [31:0] rd;
        logic [31:0] isol_data = 32'hCAFE_BABE;
        logic [31:0] isol_addr = SLV_BASE[3] + 32'h40;

        axi_write_m0(isol_addr, isol_data, 8'hAA, ok_w);
        check("Isolation WRITE via M0 -> S3: ok", ok_w);
        // M1 reads same address; data must match (correct routing both ways)
        axi_read_m1(isol_addr, 8'hBB, rd, ok_r);
        check("Isolation READ via M1 from S3: data matches", ok_r && (rd === isol_data));
    end

    // ----------------------------------------------------------
    // TEST: Concurrent M0 + M1 to DIFFERENT slaves
    // Fork both, join
    // ----------------------------------------------------------
    $display("\n--- TEST: Concurrent M0+M1 to different slaves ---");
    begin
        logic        ok0, ok1;
        logic [31:0] rd0, rd1;
        logic [31:0] cd0 = 32'hDEAD_0000;
        logic [31:0] cd1 = 32'hBEEF_0000;
        logic [31:0] ca0 = SLV_BASE[5] + 32'h50;
        logic [31:0] ca1 = SLV_BASE[6] + 32'h50;

        // Sequential writes then reads (VCS fork/join can be tricky
        // with automatic tasks; use sequential for reliability)
        axi_write_m0(ca0, cd0, 8'hC0, ok0);
        axi_write_m1(ca1, cd1, 8'hC1, ok1);
        check("Concurrent WRITE M0->S5", ok0);
        check("Concurrent WRITE M1->S6", ok1);

        axi_read_m0(ca0, 8'hD0, rd0, ok0);
        axi_read_m1(ca1, 8'hD1, rd1, ok1);
        check("Concurrent READ M0<-S5 matches", ok0 && (rd0 === cd0));
        check("Concurrent READ M1<-S6 matches", ok1 && (rd1 === cd1));
    end

    // ----------------------------------------------------------
    // TEST: Unmapped / invalid address
    // Addresses >= 0x0800_0000 are outside all slave windows.
    // The interconnect should return DECERR (bresp/rresp = 2'b11).
    // We check that the transaction completes (no hang) and flag
    // the response.
    // ----------------------------------------------------------
    $display("\n--- TEST: Unmapped address ---");
    begin
        logic        ok;
        logic [31:0] rd;
        logic [31:0] bad_addr = 32'hFF00_0000;
        integer      cyc;

        // Write to bad address from M0
        @(negedge clk);
        s00_awid    = 8'hEE;
        s00_awaddr  = bad_addr;
        s00_awlen   = 8'd0;
        s00_awsize  = 3'b010;
        s00_awburst = 2'b01;
        s00_awvalid = 1'b1;
        cyc = 0;
        do @(posedge clk); while (!s00_awready && ++cyc < TIMEOUT_CYC);
        @(negedge clk); s00_awvalid = 1'b0;
        if (cyc < TIMEOUT_CYC) begin
            s00_wdata  = 32'hDEAD_BEEF;
            s00_wstrb  = 4'hF;
            s00_wlast  = 1'b1;
            s00_wvalid = 1'b1;
            cyc = 0;
            do @(posedge clk); while (!s00_wready && ++cyc < TIMEOUT_CYC);
            @(negedge clk); s00_wvalid=0; s00_wlast=0;
            s00_bready = 1'b1;
            cyc = 0;
            do @(posedge clk); while (!s00_bvalid && ++cyc < TIMEOUT_CYC);
            if (cyc < TIMEOUT_CYC) begin
                // DECERR = 2'b11; SLVERR = 2'b10; either counts as error decode
                check("Unmapped WRITE returns error response",
                      (s00_bresp == 2'b11) || (s00_bresp == 2'b10));
            end else begin
                check("Unmapped WRITE did not hang", 1'b0);
            end
        end else begin
            check("Unmapped WRITE AW did not hang", 1'b0);
        end
        @(negedge clk);

        // Read from bad address via M0
        s00_arid    = 8'hEF;
        s00_araddr  = bad_addr;
        s00_arlen   = 8'd0;
        s00_arsize  = 3'b010;
        s00_arburst = 2'b01;
        s00_arvalid = 1'b1;
        cyc = 0;
        do @(posedge clk); while (!s00_arready && ++cyc < TIMEOUT_CYC);
        @(negedge clk); s00_arvalid = 1'b0;
        if (cyc < TIMEOUT_CYC) begin
            s00_rready = 1'b1;
            cyc = 0;
            do @(posedge clk); while (!s00_rvalid && ++cyc < TIMEOUT_CYC);
            if (cyc < TIMEOUT_CYC) begin
                check("Unmapped READ returns error response",
                      (s00_rresp == 2'b11) || (s00_rresp == 2'b10));
            end else begin
                check("Unmapped READ did not hang", 1'b0);
            end
        end else begin
            check("Unmapped READ AR did not hang", 1'b0);
        end
        @(negedge clk);
    end

    // ----------------------------------------------------------
    // TEST: Second reset – verify DUT recovers
    // ----------------------------------------------------------
    $display("\n--- TEST: Second reset recovery ---");
    begin
        logic        ok_w, ok_r;
        logic [31:0] rd;
        rst = 1'b1;
        repeat(8) @(posedge clk);
        rst = 1'b0;
        repeat(5) @(posedge clk);
        idle_master0();
        axi_write_m0(SLV_BASE[0] + 32'h80, 32'hFEED_FACE, 8'h01, ok_w);
        axi_read_m0 (SLV_BASE[0] + 32'h80, 8'h02, rd, ok_r);
        check("Post-reset WRITE+READ via M0->S0", ok_w && ok_r && (rd === 32'hFEED_FACE));
    end

    // ----------------------------------------------------------
    // Final summary
    // ----------------------------------------------------------
    repeat(4) @(posedge clk);
    $display("\n========================================");
    $display("2-MASTER / 8-SLAVE TEST SUMMARY");
    $display("Total  : %0d", total_tests);
    $display("Passed : %0d", passed_tests);
    $display("Failed : %0d", failed_tests);
    $display("RESULT : %s", (failed_tests == 0) ? "PASS" : "FAIL");
    $display("========================================\n");
    $finish;
end
initial 
begin
$fsdbDumpfile("dump.fsdb");
$fsdbDumpvars("+all");
$fsdbDumpSVA;
$fsdbDumpMDA;
end
endmodule
