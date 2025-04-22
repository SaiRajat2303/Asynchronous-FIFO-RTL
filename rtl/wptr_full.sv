`timescale 1ns/1ps
module wptr_full #(parameter ADDR_WIDTH=4)
                  (
                    output reg                       wfull,
                    output      [ADDR_WIDTH-1:0]     waddr,
                    output reg  [ADDR_WIDTH:0]       wptr,
                    input       [ADDR_WIDTH:0]       wq2_rptr,
                    input                            wclk,
                    input                            winc,
                    input                            wrst_n
                  );

                  reg [ADDR_WIDTH:0] wbin;
                  wire [ADDR_WIDTH:0] wgraynext, wbinnext;
                  wire wfull_val;

                  always@(posedge wclk or negedge wrst_n) begin
                    if(!wrst_n) begin
                        {wbin, wptr} <= 0;
                    end
                    else begin
                        {wbin, wptr} <= {wbinnext,wgraynext};
                    end
                  end

                  assign waddr = wbin[ADDR_WIDTH-1:0];

                  assign wbinnext = wbin + (winc & ~wfull);
                  assign wgraynext = (wbinnext >> 1) ^ wbinnext;

                  assign wfull_val = (wgraynext == {~wq2_rptr[ADDR_WIDTH:ADDR_WIDTH-1],wq2_rptr[ADDR_WIDTH-2:0]});

                  always@(posedge wclk or negedge wrst_n) begin
                    if(!wrst_n) begin
                        wfull <= 0;
                    end
                    else begin
                        wfull <= wfull_val;
                    end
                  end

endmodule
