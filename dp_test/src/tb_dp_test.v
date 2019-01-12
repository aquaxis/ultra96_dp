`timescale 1ns / 1ps
module tb_dp_test;
  // --------------------------------------------------
  // AXI4 Lite Interface
  // --------------------------------------------------
  // Reset; Clock
  reg         S_AXI_ARESETN;
  reg         S_AXI_ACLK;

  // Write Address Channel
  wire [15:0] S_AXI_AWADDR;
  wire [3:0]  S_AXI_AWCACHE;
  wire [2:0]  S_AXI_AWPROT;
  wire        S_AXI_AWVALID;
  wire        S_AXI_AWREADY;

  // Write Data Channel
  wire [31:0] S_AXI_WDATA;
  wire [3:0]  S_AXI_WSTRB;
  wire        S_AXI_WVALID;
  wire        S_AXI_WREADY;

  // Write Response Channel
  wire        S_AXI_BVALID;
  wire        S_AXI_BREADY;
  wire [1:0]  S_AXI_BRESP;

  // Read Address Channel
  wire [15:0] S_AXI_ARADDR;
  wire [3:0]  S_AXI_ARCACHE;
  wire [2:0]  S_AXI_ARPROT;
  wire        S_AXI_ARVALID;
  wire        S_AXI_ARREADY;

  // Read Data Channel
  wire [31:0] S_AXI_RDATA;
  wire [1:0]  S_AXI_RRESP;
  wire        S_AXI_RVALID;
  wire        S_AXI_RREADY;

  // Video
  reg        VCLK;

  wire        VSYNC;
  wire        HSYNC;
  wire        DE;
  wire [35:0] PIXEL;
  wire [7:0]  ALPHA;

  wire [31:0] DEBUG;


  localparam CLK100M = 10;
  localparam CLK200M = 5;
  localparam CLK74M  = 13.184;

  // Initialize and Free for Reset
  initial begin
    S_AXI_ARESETN <= 1'b0;
    S_AXI_ACLK    <= 1'b0;
    VCLK          <= 1'b0;

	  #100;

	  @(posedge S_AXI_ACLK);
      S_AXI_ARESETN <= 1'b1;
	  $display("============================================================");
	  $display("Simulatin Start");
	  $display("============================================================");
  end

  // Clock
  always  begin
	  #(CLK100M/2) S_AXI_ACLK <= ~S_AXI_ACLK;
  end

  always  begin
	  #(CLK74M/2) VCLK <= ~VCLK;
  end

  // Finish
  reg sim_end;
  initial begin
    sim_end = 0;
	  wait(sim_end);
	  $display("============================================================");
	  $display("Simulatin Finish");
	  $display("============================================================");
	  $finish();
  end

  // Sinario
  initial begin
	  wait(S_AXI_ARESETN);

	  @(posedge S_AXI_ACLK);

	  $display("============================================================");
	  $display("Process Start");
	  $display("============================================================");

      axi_ls_master.wrdata(32'h0000_0000, 1);  // Reset

      axi_ls_master.wrdata(32'h0000_0004, 750);  // Height
      axi_ls_master.wrdata(32'h0000_0008, 1648);  // Height

      axi_ls_master.wrdata(32'h0000_000C, 30);  // Height
      axi_ls_master.wrdata(32'h0000_0010, 368);  // Height

      axi_ls_master.wrdata(32'h0000_0014, 3);
      axi_ls_master.wrdata(32'h0000_0018, 8);
      axi_ls_master.wrdata(32'h0000_001C, 0);
      axi_ls_master.wrdata(32'h0000_0020, 1648);

      axi_ls_master.wrdata(32'h0000_0024, 0);
      axi_ls_master.wrdata(32'h0000_0028, 750);
      axi_ls_master.wrdata(32'h0000_002C, 72);
      axi_ls_master.wrdata(32'h0000_0030, 152);

      axi_ls_master.wrdata(32'h0000_0034, 32'hF0);
      axi_ls_master.wrdata(32'h0000_0038, 32'h0F);
      axi_ls_master.wrdata(32'h0000_003C, 32'hAA);
      axi_ls_master.wrdata(32'h0000_0040, 32'h55);

      axi_ls_master.wrdata(32'h0000_0044, 8);
//      axi_ls_master.wrdata(32'h0000_0048, 4);
      axi_ls_master.wrdata(32'h0000_0048, 0);

      axi_ls_master.wrdata(32'h0000_0000, 0);


	  repeat (2000000) @(posedge S_AXI_ACLK);

    sim_end = 1;
  end

  dp_test_top u_dp_test_top(
    // --------------------------------------------------
    // AXI4 Lite Interface
    // --------------------------------------------------
    // Reset, Clock
    .ARESETN       ( S_AXI_ARESETN ),
    .ACLK          ( S_AXI_ACLK    ),

    // Write Address Channel
    .S_AXI_AWADDR  ( S_AXI_AWADDR  ),
    .S_AXI_AWCACHE ( S_AXI_AWCACHE ),
    .S_AXI_AWPROT  ( S_AXI_AWPROT  ),
    .S_AXI_AWVALID ( S_AXI_AWVALID ),
    .S_AXI_AWREADY ( S_AXI_AWREADY ),

    // Write Data Channel
    .S_AXI_WDATA   ( S_AXI_WDATA   ),
    .S_AXI_WSTRB   ( S_AXI_WSTRB   ),
    .S_AXI_WVALID  ( S_AXI_WVALID  ),
    .S_AXI_WREADY  ( S_AXI_WREADY  ),

    // Write Response Channel
    .S_AXI_BVALID  ( S_AXI_BVALID  ),
    .S_AXI_BREADY  ( S_AXI_BREADY  ),
    .S_AXI_BRESP   ( S_AXI_BRESP   ),

    // Read Address Channel
    .S_AXI_ARADDR  ( S_AXI_ARADDR  ),
    .S_AXI_ARCACHE ( S_AXI_ARCACHE ),
    .S_AXI_ARPROT  ( S_AXI_ARPROT  ),
    .S_AXI_ARVALID ( S_AXI_ARVALID ),
    .S_AXI_ARREADY ( S_AXI_ARREADY ),

    // Read Data Channel
    .S_AXI_RDATA   ( S_AXI_RDATA   ),
    .S_AXI_RRESP   ( S_AXI_RRESP   ),
    .S_AXI_RVALID  ( S_AXI_RVALID  ),
    .S_AXI_RREADY  ( S_AXI_RREADY  ),

    .VCLK  ( VCLK ),

    .VSYNC ( VSYNC ),
    .HSYNC ( HSYNC ),
    .DE    ( DE    ),
    .PIXEL ( PIXEL ),
    .ALPHA ( ALPHA ),

    .DEBUG         ( DEBUG         )
  );

  tb_axi_ls_master_model axi_ls_master(
    // Reset, Clock
    .ARESETN       ( S_AXI_ARESETN ),
    .ACLK          ( S_AXI_ACLK    ),

    // Write Address Channel
    .S_AXI_AWADDR  ( S_AXI_AWADDR  ),
    .S_AXI_AWCACHE ( S_AXI_AWCACHE ),
    .S_AXI_AWPROT  ( S_AXI_AWPROT  ),
    .S_AXI_AWVALID ( S_AXI_AWVALID ),
    .S_AXI_AWREADY ( S_AXI_AWREADY ),

    // Write Data Channel
    .S_AXI_WDATA   ( S_AXI_WDATA   ),
    .S_AXI_WSTRB   ( S_AXI_WSTRB   ),
    .S_AXI_WVALID  ( S_AXI_WVALID  ),
    .S_AXI_WREADY  ( S_AXI_WREADY  ),

    // Write Response Channel
    .S_AXI_BVALID  ( S_AXI_BVALID  ),
    .S_AXI_BREADY  ( S_AXI_BREADY  ),
    .S_AXI_BRESP   ( S_AXI_BRESP   ),

    // Read Address Channe
    .S_AXI_ARADDR  ( S_AXI_ARADDR  ),
    .S_AXI_ARCACHE ( S_AXI_ARCACHE ),
    .S_AXI_ARPROT  ( S_AXI_ARPROT  ),
    .S_AXI_ARVALID ( S_AXI_ARVALID ),
    .S_AXI_ARREADY ( S_AXI_ARREADY ),

    // Read Data Channel
    .S_AXI_RDATA   ( S_AXI_RDATA   ),
    .S_AXI_RRESP   ( S_AXI_RRESP   ),
    .S_AXI_RVALID  ( S_AXI_RVALID  ),
    .S_AXI_RREADY  ( S_AXI_RREADY  )
  );

endmodule
