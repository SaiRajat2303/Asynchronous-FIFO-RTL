`timescale 1ns/1ps
module rptr_empty #(parameter ADDR_WIDTH = 4)
                    (
                        output  reg                 rempty, // Output reg -> since it shall be used within an always block
                        output     [ADDR_WIDTH-1:0] raddr, // Binary format of the rptr -> which is a dual n-bit gray code number
                        output reg [ADDR_WIDTH:0]   rptr, // read pointer in Dual n-bit gray code
                        input      [ADDR_WIDTH:0]   rq2_wptr, // Synchronised write pointer in read domain
                        input                       rinc, // Valid for the read operation
                        input                       rclk,
                        input                       rrst_n
                    );

                    reg [ADDR_WIDTH:0] rbin;
                    wire [ADDR_WIDTH:0] rgraynext, rbinnext;
                    wire rempty_val;

                    always@(posedge rclk or negedge rrst_n) begin
                        if(!rrst_n) begin
                            {rbin, rptr} <= 0;
                        end
                        else begin
                            {rbin, rptr} <= {rbinnext, rgraynext};
                        end
                    end

                    // raddr to index FIFO Memory Array
                    assign raddr = rbin[ADDR_WIDTH-1:0]; // Excluding the wrap bit !

                    assign rbinnext = rbin + (rinc & ~rempty);
                    assign rgraynext = (rbinnext>>1)^rbinnext; // VIP -> Getting gray code value from binary 

                    assign rempty_val = (rgraynext == rq2_wptr); 

                    always @(posedge rclk or negedge rrst_n) begin
                        if(!rrst_n) begin 
                            rempty <= 1'b1;
                        end
                        else begin
                            rempty <= rempty_val;
                        end
                    end
endmodule
