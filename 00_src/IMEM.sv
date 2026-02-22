//8KB
module imem(
	input logic i_reset,
	input logic [31:0] i_addr,//nối ngõ ra thanh ghi PC ; 
	output logic [31:0] o_rdata //chua lenh
);
	logic [31:0] imem [0:2047];
	initial begin
	$readmemh("isa_4b.hex", imem, 0, 2047); 
	end
	//
	assign o_rdata = imem[i_addr[12:2]];
endmodule
