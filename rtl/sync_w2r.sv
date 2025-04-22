/*
    This module is just 2 flip flops in series with wclk as clk input
*/
`timescale 1ns/1ps
module sync_w2r #(parameter ADDR_WIDTH = 4)
                (
                    output reg [ADDR_WIDTH:0] rq2_wptr,
                    input  [ADDR_WIDTH:0] wptr,
                    input                 rclk,
                    input                 rrst_n
                );

                reg [ADDR_WIDTH:0] rq1_wptr;

                always@(posedge rclk or negedge rrst_n) begin
                    if(!rrst_n) begin
                        {rq2_wptr,rq1_wptr} <= 0;
                    end
                    else begin
                        {rq2_wptr,rq1_wptr} <= {rq1_wptr,wptr};
                    end
                end
endmodule
