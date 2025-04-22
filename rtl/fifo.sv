// Top level module for an Asynchronous FIFO
// Project as a part of TT Mentorship : Aleksander Mijatovic : Sai Rajat
`timescale 1ns/1ps
module fifo #(parameter DATA_WIDTH = 64,
			  parameter ADDR_WIDTH = 4)
			  (
				output [DATA_WIDTH - 1 : 0] 	rdata,
				output							wfull, // Naming it wfull , since full flag is computed in write clock domain -> when write pointer catches up with synchronized read pointer
				output							rempty,// Naming it rempty , since empty flag is computed in write clock domain -> when read pointer catches up with synchronized write pointer
				input  [DATA_WIDTH - 1 : 0] 	wdata,
				input							wclk,
				input							wrst_n,
				input							winc,
				input 							rclk,
				input							rrst_n,
				input							rinc
			  );
			
			  wire [ADDR_WIDTH:0] rptr, wptr, rq2_wptr, wq2_rptr;
			  wire [ADDR_WIDTH-1:0] raddr, waddr;
			
			  rptr_empty #(ADDR_WIDTH) rptr_empty 
			  						(
										.rempty(rempty),
										.rptr(rptr),
										.rq2_wptr(rq2_wptr),
										.rinc(rinc),
										.raddr(raddr),
										.rclk(rclk),
										.rrst_n(rrst_n));
			
			  wptr_full #(ADDR_WIDTH) wptr_full 
			  						(
										.wfull(wfull),
										.wptr(wptr),
										.wq2_rptr(wq2_rptr),
										.winc(winc),
										.waddr(waddr),
										.wclk(wclk),
										.wrst_n(wrst_n));

			  sync_r2w #(ADDR_WIDTH)		sync_r2w (.wq2_rptr(wq2_rptr), .rptr(rptr),
			  						.wclk(wclk), .wrst_n(wrst_n));
			  // 2 - flop synchroniser for synchronised read pointer in write clock domain

			  sync_w2r #(ADDR_WIDTH)	sync_w2r(.rq2_wptr(rq2_wptr), .wptr(wptr),
			  						.rclk(rclk), .rrst_n(rrst_n));
			  // 2 - flop synchroniser for synchronised write pointer in read clock domain

			  // raddr and waddr -> binary values for writing into the mem array (converted from Gray Code)

			  fifomem #(DATA_WIDTH, ADDR_WIDTH) fifomem
			  							(
										.rdata(rdata), 
										.wdata(wdata),
										.waddr(waddr),
										.raddr(raddr),
										.wclken(winc),
										.wfull(wfull),
										.wclk(wclk)); // Memory Array for the FIFO
			
			  
								
	// Note: wptr and rptr are the FIFO pointers in Gray Code
  // Gray Code preferred due to single bit toggles -> safer synchronization!
	// However, raddr and waddr are the values in binary that are used to index the memory array !

	/* 
    Note : winc is a signal that indicates the wptr to be incremented 
	  which can serve as a valid field for WDATA
    winc -> equivalent to push , rinc -> equivalent to pop
	*/
endmodule


