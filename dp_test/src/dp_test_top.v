module dp_test_top(
  // AXI4 Lite Interface
  input         ARESETN,
  input         ACLK,

  // Write Address Channel
  input [15:0]  S_AXI_AWADDR,
  input [3:0]   S_AXI_AWCACHE,
  input [2:0]   S_AXI_AWPROT,
  input         S_AXI_AWVALID,
  output        S_AXI_AWREADY,

  // Write Data Channel
  input [31:0]  S_AXI_WDATA,
  input [3:0]   S_AXI_WSTRB,
  input         S_AXI_WVALID,
  output        S_AXI_WREADY,

  // Write Response Channel
  output        S_AXI_BVALID,
  input         S_AXI_BREADY,
  output [1:0]  S_AXI_BRESP,

  // Read Address Channel
  input [15:0]  S_AXI_ARADDR,
  input [3:0]   S_AXI_ARCACHE,
  input [2:0]   S_AXI_ARPROT,
  input         S_AXI_ARVALID,
  output        S_AXI_ARREADY,

  // Read Data Channel
  output [31:0] S_AXI_RDATA,
  output [1:0]  S_AXI_RRESP,
  output        S_AXI_RVALID,
  input         S_AXI_RREADY,

  // Video
  input         VCLK,

  // Output
  output        VSYNC,
  output        HSYNC,
  output        DE,
  output [35:0] PIXEL,
  output [35:0] PIXEL2,
  output [7:0]  ALPHA,

  // Input
  input         VSYNC_IN,
  input         HSYNC_IN,
  input         DE_IN,

  output [31:0] DEBUG
);

  wire         AQ_LOCAL_CLK;
  wire         AQ_LOCAL_CS;
  wire         AQ_LOCAL_RNW;
  wire         AQ_LOCAL_ACK;
  wire [31:0]  AQ_LOCAL_ADDR;
  wire [3:0]   AQ_LOCAL_BE;
  wire [31:0]  AQ_LOCAL_WDATA;
  wire [31:0]  AQ_LOCAL_RDATA;

  wire         RESET;

  wire [15:0]  HEIGHT;
  wire [15:0]  WIDTH;

  wire [15:0]  VSYNC_VCOUNT_START;
  wire [15:0]  VSYNC_VCOUNT_END;
  wire [15:0]  VSYNC_HCOUNT_START;
  wire [15:0]  VSYNC_HCOUNT_END;
  wire [15:0]  HSYNC_VCOUNT_START;
  wire [15:0]  HSYNC_VCOUNT_END;
  wire [15:0]  HSYNC_HCOUNT_START;
  wire [15:0]  HSYNC_HCOUNT_END;
  wire [15:0]  ACTIVE_HEIGHT_START;
  wire [15:0]  ACTIVE_WIDTH_START;
  wire [15:0]  ACTIVE_VIEW_START;
  wire [15:0]  ACTIVE_VIEW_END;

  wire [15:0]  R;
  wire [15:0]  G;
  wire [15:0]  B;
  wire [7:0]   A;

  wire [7:0]   BURST_LEN;
  wire [7:0]   WAIT;
  wire         INTERNAL;
  wire [31:0]  INTERNAL_COUNT_RESET;

  wire [15:0]  PIXEL_R;
  wire [15:0]  PIXEL_G;
  wire [15:0]  PIXEL_B;
  wire [15:0]  PIXEL_A;

dp_test_ls u_dp_test_ls
  (
   // AXI4 Lite Interface
   .ARESETN ( ARESETN ),
   .ACLK    ( ACLK    ),

    // Write Address Channel
   .S_AXI_AWADDR  ( S_AXI_AWADDR  ),
   .S_AXI_AWCACHE ( S_AXI_AWCACHE ),
   .S_AXI_AWPROT  ( S_AXI_AWPROT  ),
   .S_AXI_AWVALID ( S_AXI_AWVALID ),
   .S_AXI_AWREADY ( S_AXI_AWREADY ),

   // Write Data Channel
   .S_AXI_WDATA   ( S_AXI_WDATA  ),
   .S_AXI_WSTRB   ( S_AXI_WSTRB  ),
   .S_AXI_WVALID  ( S_AXI_WVALID ),
   .S_AXI_WREADY  ( S_AXI_WREADY ),

   // Write Response Channel
   .S_AXI_BVALID  ( S_AXI_BVALID ),
   .S_AXI_BREADY  ( S_AXI_BREADY ),
   .S_AXI_BRESP   ( S_AXI_BRESP  ),

   // Read Address Channel
   .S_AXI_ARADDR  ( S_AXI_ARADDR  ),
   .S_AXI_ARCACHE ( S_AXI_ARCACHE ),
   .S_AXI_ARPROT  ( S_AXI_ARPROT  ),
   .S_AXI_ARVALID ( S_AXI_ARVALID ),
   .S_AXI_ARREADY ( S_AXI_ARREADY ),

   // Read Data Channel
   .S_AXI_RDATA   ( S_AXI_RDATA  ),
   .S_AXI_RRESP   ( S_AXI_RRESP  ),
   .S_AXI_RVALID  ( S_AXI_RVALID ),
   .S_AXI_RREADY  ( S_AXI_RREADY ),

   // Local Interface
  .AQ_LOCAL_CLK   ( AQ_LOCAL_CLK   ),
  .AQ_LOCAL_CS    ( AQ_LOCAL_CS    ),
  .AQ_LOCAL_RNW   ( AQ_LOCAL_RNW   ),
  .AQ_LOCAL_ACK   ( AQ_LOCAL_ACK   ),
  .AQ_LOCAL_ADDR  ( AQ_LOCAL_ADDR  ),
  .AQ_LOCAL_BE    ( AQ_LOCAL_BE    ),
  .AQ_LOCAL_WDATA ( AQ_LOCAL_WDATA ),
  .AQ_LOCAL_RDATA ( AQ_LOCAL_RDATA ),

   .DEBUG()
  );

dp_test_ctrl u_dp_test_ctrl
  (
  .RST_N ( ARESETN ),

  .AQ_LOCAL_CLK   ( AQ_LOCAL_CLK   ),
  .AQ_LOCAL_CS    ( AQ_LOCAL_CS    ),
  .AQ_LOCAL_RNW   ( AQ_LOCAL_RNW   ),
  .AQ_LOCAL_ACK   ( AQ_LOCAL_ACK   ),
  .AQ_LOCAL_ADDR  ( AQ_LOCAL_ADDR  ),
  .AQ_LOCAL_BE    ( AQ_LOCAL_BE    ),
  .AQ_LOCAL_WDATA ( AQ_LOCAL_WDATA ),
  .AQ_LOCAL_RDATA ( AQ_LOCAL_RDATA ),

  .RESET  ( RESET ),

  .HEIGHT ( HEIGHT ),
  .WIDTH  ( WIDTH  ),
  .ACTIVE_HEIGHT_START ( ACTIVE_HEIGHT_START ),
  .ACTIVE_WIDTH_START  ( ACTIVE_WIDTH_START  ),

  .VSYNC_VCOUNT_START ( VSYNC_VCOUNT_START ),
  .VSYNC_VCOUNT_END   ( VSYNC_VCOUNT_END   ),
  .VSYNC_HCOUNT_START ( VSYNC_HCOUNT_START ),
  .VSYNC_HCOUNT_END   ( VSYNC_HCOUNT_END   ),
  .HSYNC_VCOUNT_START ( HSYNC_VCOUNT_START ),
  .HSYNC_VCOUNT_END   ( HSYNC_VCOUNT_END   ),
  .HSYNC_HCOUNT_START ( HSYNC_HCOUNT_START ),
  .HSYNC_HCOUNT_END   ( HSYNC_HCOUNT_END   ),

  .ACTIVE_VIEW_START  ( ACTIVE_VIEW_START  ),
  .ACTIVE_VIEW_END    ( ACTIVE_VIEW_END    ),

  .R ( PIXEL_R ),
  .G ( PIXEL_G ),
  .B ( PIXEL_B ),
  .A ( PIXEL_A ),

  .BURST_LEN ( BURST_LEN ),
  .WAIT      ( WAIT      ),
  .INTERNAL  ( INTERNAL  ),
  .INTERNAL_COUNT_RESET  ( INTERNAL_COUNT_RESET  ),

  .DEBUG()
);

dp_test u_dp_test(
  .RST_N ( ARESETN ),
  .CLK   ( VCLK    ),

  .RESET  ( RESET ),

  .INTERNAL ( INTERNAL ),
  .INTERNAL_COUNT_RESET  ( INTERNAL_COUNT_RESET  ),
  .VSYNC_IN ( VSYNC_IN ),
  .HSYNC_IN ( HSYNC_IN ),

  .HEIGHT ( HEIGHT ),
  .WIDTH  ( WIDTH  ),
  .ACTIVE_HEIGHT_START ( ACTIVE_HEIGHT_START ),
  .ACTIVE_WIDTH_START  ( ACTIVE_WIDTH_START  ),

  .VSYNC_VCOUNT_START ( VSYNC_VCOUNT_START ),
  .VSYNC_VCOUNT_END   ( VSYNC_VCOUNT_END   ),
  .VSYNC_HCOUNT_START ( VSYNC_HCOUNT_START ),
  .VSYNC_HCOUNT_END   ( VSYNC_HCOUNT_END   ),
  .HSYNC_VCOUNT_START ( HSYNC_VCOUNT_START ),
  .HSYNC_VCOUNT_END   ( HSYNC_VCOUNT_END   ),
  .HSYNC_HCOUNT_START ( HSYNC_HCOUNT_START ),
  .HSYNC_HCOUNT_END   ( HSYNC_HCOUNT_END   ),

  .ACTIVE_VIEW_START  ( ACTIVE_VIEW_START  ),
  .ACTIVE_VIEW_END    ( ACTIVE_VIEW_END    ),

  .R ( PIXEL_R ),
  .G ( PIXEL_G ),
  .B ( PIXEL_B ),
  .A ( PIXEL_A ),

  .BURST_LEN ( BURST_LEN ),
  .WAIT      ( WAIT      ),

  .VSYNC ( VSYNC ),
  .HSYNC ( HSYNC ),
  .DE    ( DE    ),
  .PIXEL ( PIXEL ),
  .PIXEL2 ( PIXEL2 ),
  .ALPHA ( ALPHA )
);
endmodule
