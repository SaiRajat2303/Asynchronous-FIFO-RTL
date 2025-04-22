module fifomem #(parameter DATA_WIDTH = 64,
		 parameter ADDR_WIDTH = 4)
		(
		  output [DATA_WIDTH-1:0] rdata,
		  input	 [ADDR_WIDTH-1:0] waddr,
		  input  [ADDR_WIDTH-1:0] raddr,
		  input  [DATA_WIDTH-1:0] wdata,
		  input 		  wclk,
	 	  input			  wclken,
		  input			  wfull
		);
		
	// Instantiate designed SRAM Module
	
	localparam DEPTH = 1<< ADDR_WIDTH;
	reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

	assign rdata = mem[raddr];

	always@(posedge wclk)begin
		if(wclken && !wfull) begin
			mem[waddr] <= wdata;
		end
	end
endmodule
