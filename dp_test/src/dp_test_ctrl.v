/*
 * Copyright (C)2014-2017 AQUAXIS TECHNOLOGY.
 *  Don't remove this header.
 * When you use this source, there is a need to inherit this header.
 *
 * License
 *  For no commercial -
 *   License:     The Open Software License 3.0
 *   License URI: http://www.opensource.org/licenses/OSL-3.0
 *
 *  For commmercial -
 *   License:     AQUAXIS License 1.0
 *   License URI: http://www.aquaxis.com/licenses
 *
 * For further information please contact.
 *	URI:    http://www.aquaxis.com/
 *	E-Mail: info(at)aquaxis.com
 */
module dp_test_ctrl
  (
  input         RST_N,

  input         AQ_LOCAL_CLK,
  input         AQ_LOCAL_CS,
  input         AQ_LOCAL_RNW,
  output        AQ_LOCAL_ACK,
  input [31:0]  AQ_LOCAL_ADDR,
  input [3:0]   AQ_LOCAL_BE,
  input [31:0]  AQ_LOCAL_WDATA,
  output [31:0] AQ_LOCAL_RDATA,

  output         RESET,

  output [15:0]  HEIGHT,
  output [15:0]  WIDTH,
  output [15:0]  ACTIVE_HEIGHT_START,
  output [15:0]  ACTIVE_WIDTH_START,

  output [15:0]  VSYNC_VCOUNT_START,
  output [15:0]  VSYNC_VCOUNT_END,
  output [15:0]  VSYNC_HCOUNT_START,
  output [15:0]  VSYNC_HCOUNT_END,
  output [15:0]  HSYNC_VCOUNT_START,
  output [15:0]  HSYNC_VCOUNT_END,
  output [15:0]  HSYNC_HCOUNT_START,
  output [15:0]  HSYNC_HCOUNT_END,

  output [15:0]  ACTIVE_VIEW_START,
  output [15:0]  ACTIVE_VIEW_END,

  output [15:0]  R,
  output [15:0]  G,
  output [15:0]  B,
  output [7:0]   A,

  output [7:0]   BURST_LEN,
  output [7:0]   WAIT,
  output         INTERNAL,
  output [31:0]  INTERNAL_COUNT_RESET,

  output [31:0] DEBUG
);

  localparam A_RESET               = 8'h00;
  localparam A_HEIGHT              = 8'h04;
  localparam A_WIDTH               = 8'h08;
  localparam A_ACTIVE_HEIGHT_START = 8'h0C;
  localparam A_ACTIVE_WIDTH_START  = 8'h10;
  localparam A_VSYNC_VCOUNT_START  = 8'h14;
  localparam A_VSYNC_VCOUNT_END    = 8'h18;
  localparam A_VSYNC_HCOUNT_START  = 8'h1C;
  localparam A_VSYNC_HCOUNT_END    = 8'h20;
  localparam A_HSYNC_VCOUNT_START  = 8'h24;
  localparam A_HSYNC_VCOUNT_END    = 8'h28;
  localparam A_HSYNC_HCOUNT_START  = 8'h2C;
  localparam A_HSYNC_HCOUNT_END    = 8'h30;
  localparam A_R                   = 8'h34;
  localparam A_G                   = 8'h38;
  localparam A_B                   = 8'h3C;
  localparam A_A                   = 8'h40;
  localparam A_BURST_LEN           = 8'h44;
  localparam A_WAIT                = 8'h48;
  localparam A_ACTIVE_VIEW_START   = 8'h4C;
  localparam A_ACTIVE_VIEW_END     = 8'h50;
  localparam A_INTERNAL            = 8'h54;
  localparam A_INTERNAL_COUNT_RESET = 8'h58;

  localparam A_DEBUG               = 8'hFC;

  reg r_reset;
  reg [15:0] r_height, r_width;
  reg [15:0] r_active_height_start, r_active_width_start;
  reg [15:0] r_vsync_vcount_start, r_vsync_vcount_end;
  reg [15:0] r_vsync_hcount_start, r_vsync_hcount_end;
  reg [15:0] r_hsync_vcount_start, r_hsync_vcount_end;
  reg [15:0] r_hsync_hcount_start, r_hsync_hcount_end;
  reg [15:0] r_active_view_start, r_active_view_end;
  reg [15:0] r_r, r_g, r_b;
  reg [7:0]  r_a;
  reg [7:0]  r_burst_len, r_wait;
  reg        r_internal;
  reg [31:0] r_internal_count_reset;

  wire wr_ena, rd_ena,wr_ack;
  reg rd_ack;
  reg [31:0] reg_rdata;

  assign wr_ena = (AQ_LOCAL_CS & ~AQ_LOCAL_RNW)?1'b1:1'b0;
  assign rd_ena = (AQ_LOCAL_CS &  AQ_LOCAL_RNW)?1'b1:1'b0;
  assign wr_ack = wr_ena;

  // Write Register
  always @(posedge AQ_LOCAL_CLK) begin
    if(!RST_N) begin
      r_height <= 750;
      r_width  <= 1650;
      r_active_height_start <= 30;
      r_active_width_start  <= 370;
      r_vsync_vcount_start  <= 3;
      r_vsync_vcount_end    <= 8;
      r_vsync_hcount_start  <= 0;
      r_vsync_hcount_end    <= 1650;
      r_hsync_vcount_start  <= 0;
      r_hsync_vcount_end    <= 750;
      r_hsync_hcount_start  <= 72;
      r_hsync_hcount_end    <= 152;
      r_burst_len           <= 8;
      r_active_view_start   <= 270;
      r_active_view_end     <= 520;
      r_internal            <= 0;
    end else begin
      if(wr_ena) begin
        case(AQ_LOCAL_ADDR[7:0] & 8'hFC)
          A_RESET: begin
            r_reset <= AQ_LOCAL_WDATA;
          end
          A_HEIGHT: begin
            r_height <= AQ_LOCAL_WDATA;
          end
          A_WIDTH: begin
            r_width <= AQ_LOCAL_WDATA;
          end
          A_ACTIVE_HEIGHT_START: begin
            r_active_height_start <= AQ_LOCAL_WDATA;
          end
          A_ACTIVE_WIDTH_START: begin
            r_active_width_start <= AQ_LOCAL_WDATA;
          end
          A_VSYNC_VCOUNT_START: begin
            r_vsync_vcount_start <= AQ_LOCAL_WDATA;
          end
          A_VSYNC_VCOUNT_END: begin
            r_vsync_vcount_end <= AQ_LOCAL_WDATA;
          end
          A_VSYNC_HCOUNT_START: begin
            r_vsync_hcount_start <= AQ_LOCAL_WDATA;
          end
          A_VSYNC_HCOUNT_END: begin
            r_vsync_hcount_end <= AQ_LOCAL_WDATA;
          end
          A_HSYNC_VCOUNT_START: begin
            r_hsync_vcount_start <= AQ_LOCAL_WDATA;
          end
          A_HSYNC_VCOUNT_END: begin
            r_hsync_vcount_end <= AQ_LOCAL_WDATA;
          end
          A_HSYNC_HCOUNT_START: begin
            r_hsync_hcount_start <= AQ_LOCAL_WDATA;
          end
          A_HSYNC_HCOUNT_END: begin
            r_hsync_hcount_end <= AQ_LOCAL_WDATA;
          end
          A_A: begin
            r_a <= AQ_LOCAL_WDATA;
          end
          A_G: begin
            r_g <= AQ_LOCAL_WDATA;
          end
          A_B: begin
            r_b <= AQ_LOCAL_WDATA;
          end
          A_R: begin
            r_r <= AQ_LOCAL_WDATA;
          end
          A_BURST_LEN: begin
            r_burst_len <= AQ_LOCAL_WDATA;
          end
          A_WAIT: begin
            r_wait <= AQ_LOCAL_WDATA;
          end
          A_ACTIVE_VIEW_START: begin
            r_active_view_start <= AQ_LOCAL_WDATA;
          end
          A_ACTIVE_VIEW_END: begin
            r_active_view_end <= AQ_LOCAL_WDATA;
          end
          A_INTERNAL: begin
            r_internal <= AQ_LOCAL_WDATA[0];
          end
          A_INTERNAL_COUNT_RESET: begin
            r_internal_count_reset <= AQ_LOCAL_WDATA;
          end
          default: begin
          end
        endcase
      end
    end
  end

  // Read Register
  always @(posedge AQ_LOCAL_CLK) begin
    if(!RST_N) begin
      reg_rdata[31:0] <= 32'd0;
      rd_ack <= 1'b0;
    end else begin
      rd_ack <= rd_ena;
      if(rd_ena) begin
        case(AQ_LOCAL_ADDR[7:0] & 8'hFC)
          A_RESET: begin
            reg_rdata <= r_reset;
          end
          A_HEIGHT: begin
            reg_rdata <= r_height;
          end
          A_WIDTH: begin
            reg_rdata <= r_width;
          end
          A_ACTIVE_HEIGHT_START: begin
            reg_rdata <= r_active_height_start;
          end
          A_ACTIVE_WIDTH_START: begin
            reg_rdata <= r_active_width_start;
          end
          A_VSYNC_VCOUNT_START: begin
            reg_rdata <= r_vsync_vcount_start;
          end
          A_VSYNC_VCOUNT_END: begin
            reg_rdata <= r_vsync_vcount_end;
          end
          A_VSYNC_HCOUNT_START: begin
            reg_rdata <= r_vsync_hcount_start;
          end
          A_VSYNC_HCOUNT_END: begin
            reg_rdata <= r_vsync_hcount_end;
          end
          A_HSYNC_VCOUNT_START: begin
            reg_rdata <= r_hsync_vcount_start;
          end
          A_HSYNC_VCOUNT_END: begin
            reg_rdata <= r_hsync_vcount_end;
          end
          A_HSYNC_HCOUNT_START: begin
            reg_rdata <= r_hsync_hcount_start;
          end
          A_HSYNC_HCOUNT_END: begin
            reg_rdata <= r_hsync_hcount_end;
          end
          A_A: begin
            reg_rdata <= r_a;
          end
          A_G: begin
            reg_rdata <= r_g;
          end
          A_B: begin
            reg_rdata <= r_b;
          end
          A_R: begin
            reg_rdata <= r_r;
          end
          A_BURST_LEN: begin
            reg_rdata <= r_burst_len;
          end
          A_WAIT: begin
            reg_rdata <= r_wait;
          end
          A_ACTIVE_VIEW_START: begin
            reg_rdata <= r_active_view_start;
          end
          A_ACTIVE_VIEW_END: begin
            reg_rdata <= r_active_view_end;
          end
          A_INTERNAL: begin
            reg_rdata <= r_internal;
          end
          A_INTERNAL_COUNT_RESET: begin
            reg_rdata <= r_internal_count_reset;
          end
          default: begin
            reg_rdata[31:0] <= 32'd0;
          end
        endcase
      end else begin
        reg_rdata[31:0] <= 32'd0;
      end
    end
  end

  assign AQ_LOCAL_ACK         = (wr_ack | rd_ack);
  assign AQ_LOCAL_RDATA[31:0] = reg_rdata[31:0];

  assign RESET = r_reset;

  assign HEIGHT = r_height;
  assign WIDTH  = r_width;
  assign ACTIVE_HEIGHT_START = r_active_height_start;
  assign ACTIVE_WIDTH_START  = r_active_width_start;

  assign VSYNC_VCOUNT_START = r_vsync_vcount_start;
  assign VSYNC_VCOUNT_END   = r_vsync_vcount_end;
  assign VSYNC_HCOUNT_START = r_vsync_hcount_start;
  assign VSYNC_HCOUNT_END   = r_vsync_hcount_end;
  assign HSYNC_VCOUNT_START = r_hsync_vcount_start;
  assign HSYNC_VCOUNT_END   = r_hsync_vcount_end;
  assign HSYNC_HCOUNT_START = r_hsync_hcount_start;
  assign HSYNC_HCOUNT_END   = r_hsync_hcount_end;
  assign ACTIVE_VIEW_START   = r_active_view_start;
  assign ACTIVE_VIEW_END     = r_active_view_end;

  assign R = r_r;
  assign G = r_g;
  assign B = r_b;
  assign A = r_a;

  assign BURST_LEN = r_burst_len;
  assign WAIT      = r_wait;
  assign INTERNAL  = r_internal;
  assign INTERNAL_COUNT_RESET = r_internal_count_reset;

endmodule
