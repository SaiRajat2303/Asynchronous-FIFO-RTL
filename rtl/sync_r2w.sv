/* 
This is a 2 flop synchroniser module to synchronise rptr into the write clock domain
*/
`timescale 1ns/1ps
module sync_r2w #(parameter ADDR_WIDTH = 4)
				(output reg[ADDR_WIDTH: 0] 		wq2_rptr, // Additional MSB for wrapping 
				input	   [ADDR_WIDTH: 0] 		rptr,     // Additional MSB for wrap ptr
				input							wclk,
				input							wrst_n);

				reg [ADDR_WIDTH:0] wq1_rptr;

				always@(posedge wclk or negedge wrst_n) begin
					if(!wrst_n) begin
						{wq2_rptr,wq1_rptr} <= 0;
					end
					else begin
						{wq2_rptr,wq1_rptr} <= {wq1_rptr,rptr};
					end
					/* 
					Concatenation -> Beautiful and compact code style of creating 
					1 and 2 cycle delayed versions of rptr
					*/
				end
endmodule

