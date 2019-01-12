module dp_test(
  input         RST_N,
  input         CLK,

  input         RESET,

  input         VSYNC_IN,
  input         HSYNC_IN,

  input         INTERNAL,
  input [31:0]  INTERNAL_COUNT_RESET,
  input [15:0]  HEIGHT,
  input [15:0]  WIDTH,

  input [15:0]  VSYNC_VCOUNT_START,
  input [15:0]  VSYNC_VCOUNT_END,
  input [15:0]  VSYNC_HCOUNT_START,
  input [15:0]  VSYNC_HCOUNT_END,
  input [15:0]  HSYNC_VCOUNT_START,
  input [15:0]  HSYNC_VCOUNT_END,
  input [15:0]  HSYNC_HCOUNT_START,
  input [15:0]  HSYNC_HCOUNT_END,
  input [15:0]  ACTIVE_HEIGHT_START,
  input [15:0]  ACTIVE_WIDTH_START,

  input [15:0]  ACTIVE_VIEW_START,
  input [15:0]  ACTIVE_VIEW_END,

  input [15:0]  R,
  input [15:0]  G,
  input [15:0]  B,
  input [7:0]   A,

  input [7:0]   BURST_LEN,
  input [7:0]   WAIT,

  output        VSYNC,
  output        HSYNC,
  output        DE,
  output [35:0] PIXEL,
  output [35:0] PIXEL2,
  output [7:0]  ALPHA
);

reg [15:0] r_vcount, r_hcount;
wire       w_reset;

reg [1:0]  vsync_in_d, hsync_in_d;
wire       internal_reset;
reg [31:0] internal_count;

always @(posedge CLK) begin
  if(!RST_N) begin
    vsync_in_d <= 0;
    hsync_in_d <= 0;
    internal_count <= 0;
  end else begin
    hsync_in_d <= {hsync_in_d[0], HSYNC_IN};
    if(hsync_in_d == 2'h01) begin
      vsync_in_d <= {vsync_in_d[0], VSYNC_IN};
    end
    if((vsync_in_d == 2'h01) && (hsync_in_d == 2'h01)) begin
      internal_count <= 0;
    end else if(internal_count == 32'hFFFF_FFFF) begin
      // End of Count
    end else begin
      internal_count <= internal_count +1;
    end
  end
end

assign internal_reset = (internal_count == INTERNAL_COUNT_RESET)?1'b1:1'b0;
assign w_reset = RESET | (INTERNAL & internal_reset);

always @(posedge CLK) begin
  if(!RST_N) begin
    r_vcount <= 0;
    r_hcount <= 0;
  end else begin
    // V Count
    if(w_reset) begin
      r_vcount <= 0;
    end else if(r_hcount >= (WIDTH -1)) begin
      if(r_vcount >= (HEIGHT -1)) begin
        r_vcount <= 0;
      end else begin
        r_vcount <= r_vcount +1;
      end
    end 

    // H Count
    if(w_reset) begin
      r_hcount <= 0;
    end else if(r_hcount >= (WIDTH -1)) begin
      r_hcount <= 0;
    end else begin
      r_hcount <= r_hcount +1;
    end
  end
end

wire w_active;
assign w_active = (r_vcount >= ACTIVE_HEIGHT_START) && (r_hcount >= ACTIVE_WIDTH_START);

wire w_vsync, w_hsync;
assign w_vsync = (r_vcount >= VSYNC_VCOUNT_START) && (r_vcount < VSYNC_VCOUNT_END) && 
                 (r_hcount >= VSYNC_HCOUNT_START) && (r_hcount < VSYNC_HCOUNT_END);
assign w_hsync = (r_vcount >= HSYNC_VCOUNT_START) && (r_vcount < HSYNC_VCOUNT_END) && 
                 (r_hcount >= HSYNC_HCOUNT_START) && (r_hcount < HSYNC_HCOUNT_END);

reg [15:0] r_pcount;

always @(posedge CLK) begin
  if(!RST_N) begin
    r_pcount <= 0;
  end else begin
    if(w_reset) begin
      r_pcount <= 0;
    end else if(r_pcount >= (BURST_LEN + WAIT -1)) begin
      r_pcount <= 0;
    end else if(
      (r_vcount >= ACTIVE_HEIGHT_START) && (r_hcount >= ACTIVE_WIDTH_START)
    ) begin
      r_pcount <= r_pcount +1;
    end
  end
end

wire [15:0] t_bar_width, bar_width;
assign bar_width = ((WIDTH - ACTIVE_WIDTH_START) >> 3);

wire [15:0] t_pcount;
assign t_pcount = r_hcount - ACTIVE_WIDTH_START;

wire [11:0] w_r, w_g, w_b;

assign w_r = (t_pcount < bar_width * 1)?12'hFFF:
             (t_pcount < bar_width * 2)?12'hFFF:
             (t_pcount < bar_width * 3)?12'h000:
             (t_pcount < bar_width * 4)?12'h000:
             (t_pcount < bar_width * 5)?12'hFFF:
             (t_pcount < bar_width * 6)?12'hFFF:
             (t_pcount < bar_width * 7)?12'h000:
             12'h000;

assign w_g = (t_pcount < bar_width * 1)?12'hFFF:
             (t_pcount < bar_width * 2)?12'hFFF:
             (t_pcount < bar_width * 3)?12'hFFF:
             (t_pcount < bar_width * 4)?12'hFFF:
             (t_pcount < bar_width * 5)?12'h000:
             (t_pcount < bar_width * 6)?12'h000:
             (t_pcount < bar_width * 7)?12'h000:
             12'h000;

assign w_b = (t_pcount < bar_width * 1)?12'hFFF:
             (t_pcount < bar_width * 2)?12'h000:
             (t_pcount < bar_width * 3)?12'hFFF:
             (t_pcount < bar_width * 4)?12'h000:
             (t_pcount < bar_width * 5)?12'hFFF:
             (t_pcount < bar_width * 6)?12'h000:
             (t_pcount < bar_width * 7)?12'hFFF:
             12'h000;

wire w_view;
assign w_view = ((r_vcount >= ACTIVE_VIEW_START) && (r_vcount < ACTIVE_VIEW_END))?1'b1:1'b0;

wire w_penable;
assign w_penable = (r_vcount >= ACTIVE_HEIGHT_START) && (r_hcount >= ACTIVE_WIDTH_START) && 
                   (r_pcount < BURST_LEN);

assign VSYNC = w_vsync;
assign HSYNC = w_hsync;
assign DE = w_penable;
//assign PIXEL = (w_penable)?{R[11:0], G[11:0], B[11:0]}:36'd0;
assign PIXEL  = (w_penable & (r_vcount < ACTIVE_VIEW_END))?{(w_b[11:0]), (w_r[11:0]), (w_g[11:0])}:36'd0;
assign PIXEL2 = (w_penable & (r_vcount >= ACTIVE_VIEW_START))?{(w_b[11:0]^12'hFFF), (w_r[11:0]^12'hFFF), (w_g[11:0]^12'hFFF)}:36'd0;
assign ALPHA = (w_penable & (r_vcount >= ACTIVE_VIEW_START))?((r_vcount < ACTIVE_VIEW_END)?{1'b0, A[7:1]}:A[7:0]):8'd0;


endmodule
