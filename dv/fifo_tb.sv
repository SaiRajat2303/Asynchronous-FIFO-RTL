`timescale 1ns/1ps

module fifo_tb;

  localparam DATA_WIDTH = 64;
  localparam ADDR_WIDTH = 4;

  // Testbench signals
  reg wclk, rclk;
  reg wrst, rrst;
  wire wrst_n = ~wrst;
  wire rrst_n = ~rrst;
  reg winc, rinc;
  reg [DATA_WIDTH-1:0] wdata;
  wire [DATA_WIDTH-1:0] rdata;
  wire wfull, rempty;

  // Instantiate the DUT
  fifo #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH)
  ) dut (
    .wclk(wclk),
    .wrst_n(wrst_n),
    .winc(winc),
    .wdata(wdata),
    .wfull(wfull),
    .rclk(rclk),
    .rrst_n(rrst_n),
    .rinc(rinc),
    .rdata(rdata),
    .rempty(rempty)
  );

  // Generate clocks
  initial wclk = 0;
  always #5 wclk = ~wclk;   // 100 MHz write clock

  initial rclk = 0;
  always #10 rclk = ~rclk;  // 50 MHz read clock

  // Stimulus
  initial begin
    // Initialize inputs
    wrst = 1;
    rrst = 1;
    winc = 0;
    rinc = 0;
    wdata = 0;

    // Apply reset
    #20;
    wrst = 0;
    rrst = 0;

    // Wait one clock cycle
    #10;

    // 4 continuous writes
    winc = 1;
    wdata = 64'hAAAA_BBBB_CCCC_DDDD;
    #10;
    wdata = 64'h1111_2222_3333_4444;
    #10;
    wdata = 64'h5555_6666_7777_8888;
    #10;
    wdata = 64'h9999_AAAA_BBBB_CCCC;
    #10;
    winc = 0;

    // Wait for some time
    #20;

    // 1 read
    rinc = 1;
    #20;
    rinc = 0;

    // Wait and finish
    #100;
    $finish;
  end

endmodule
