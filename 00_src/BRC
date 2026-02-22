//equal
module equal(
	input logic [31:0] i_rs1_data,
	input logic [31:0] i_rs2_data,
	output logic o_br_equal
);
	//kiem tra bang
	logic [31:0] bang;
	assign bang = (~i_rs1_data & i_rs2_data) | (i_rs1_data & ~i_rs2_data); //cac bit giong nhau tung cap thi xor =0 
	assign o_br_equal = ~(|bang);
endmodule

//nho hon
module less(
	input logic [31:0] i_rs1_data,
	input logic [31:0] i_rs2_data,
	input logic i_br_un,
	output logic o_br_less
);
	logic sub_en;
	assign sub_en = 1'b1;
	logic [31:0] sum; //ket qua phep tru
	logic [31:0] c; //co nho cua phep tru tung cap bit
	logic less_unsigned;
	logic less_signed;
	fa fa0 (.a(i_rs1_data[0]), .b(~i_rs2_data[0]), .c_i(sub_en), .s(sum[0]), .c_o(c[0]));
   genvar i;
		generate for (i=1; i<32; i++) begin:
		fa_chain
		fa fa_inst(
		.a (i_rs1_data[i]),
		.b (~i_rs2_data[i]),
		.c_i (c[i-1]),
		.s (sum[i]),
		.c_o (c[i])
		);
		end
		endgenerate
	
	assign less_unsigned = ~c[31];
	assign less_signed = ~sum[31]&~c[30]&c[31] | ~sum[31]&c[30]&~c[31] | sum[31]&~c[30]&~c[31] | sum[31]&c[30]&c[31];
	mux2_1_1bit mux0(.a(less_signed), .b(less_unsigned), .sel(i_br_un), .c(o_br_less));
endmodule


module brc(
	input logic [31:0] i_rs1_data,
	input logic [31:0] i_rs2_data,
	input logic i_br_un,
	output logic o_br_less,
	output logic o_br_equal
	);
	//kiem tra bang
	equal kiem_tra_bang(.i_rs1_data(i_rs1_data), .i_rs2_data(i_rs2_data), .o_br_equal(o_br_equal));

	//kiem tra nho hon 
	less kiem_tra_nho_hon(.i_rs1_data(i_rs1_data), .i_rs2_data(i_rs2_data), .i_br_un(i_br_un), .o_br_less(o_br_less));
endmodule
