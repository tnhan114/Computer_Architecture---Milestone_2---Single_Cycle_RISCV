module mux2_1_32bit(
	input logic  [31:0] a,
	input logic  [31:0] b,
	input logic sel,
	output logic  [31:0] c
	);
	assign c = sel? b:a;
endmodule

module mux2_1_1bit(
		input logic a,
		input logic b,
		output logic c,
		input logic sel
);
		assign c = sel? b:a;
endmodule

module mux16_1( //32bit
	input logic [31:0] s0,
	input logic [31:0] s1,
	input logic [31:0] s2,
	input logic [31:0] s3,
	input logic [31:0] s4,
	input logic [31:0] s5,
	input logic [31:0] s6,
	input logic [31:0] s7,
	input logic [31:0] s8,
	input logic [31:0] s9,
	input logic [31:0] s10,
	input logic [31:0] s11,
	input logic [31:0] s12,
	input logic [31:0] s13,
	input logic [31:0] s14,
	input logic [31:0] s15,
	output logic [31:0] y,
	input logic [3:0] sel
);
	//ngo ra tang 1
	logic [31:0] c0;
	logic [31:0] c1;
	logic [31:0] c2;
	logic [31:0] c3;
	logic [31:0] c4;
	logic [31:0] c5;
	logic [31:0] c6;
	logic [31:0] c7;
	//tang 1
	mux2_1_32bit mux1_0 (.a(s0), .b(s1), .sel(sel[0]), .c(c0));
	mux2_1_32bit mux1_1 (.a(s2), .b(s3), .sel(sel[0]), .c(c1));
	mux2_1_32bit mux1_2 (.a(s4), .b(s5), .sel(sel[0]), .c(c2));
	mux2_1_32bit mux1_3 (.a(s6), .b(s7), .sel(sel[0]), .c(c3));
	mux2_1_32bit mux1_4 (.a(s8), .b(s9), .sel(sel[0]), .c(c4));
	mux2_1_32bit mux1_5 (.a(s10), .b(s11), .sel(sel[0]), .c(c5));
	mux2_1_32bit mux1_6 (.a(s12), .b(s13), .sel(sel[0]), .c(c6));
	mux2_1_32bit mux1_7 (.a(s14), .b(s15), .sel(sel[0]), .c(c7));
	
	//ngo ta tang 2
	logic [31:0] d0;
	logic [31:0] d1;
	logic [31:0] d2;
	logic [31:0] d3;
	//tang 2
	mux2_1_32bit muxB_0 (.a(c0), .b(c1), .sel(sel[1]), .c(d0));
	mux2_1_32bit muxB_1 (.a(c2), .b(c3), .sel(sel[1]), .c(d1));
	mux2_1_32bit muxB_2 (.a(c4), .b(c5), .sel(sel[1]), .c(d2));
	mux2_1_32bit muxB_3 (.a(c6), .b(c7), .sel(sel[1]), .c(d3));
	
	//ngo ra tang 3
	logic [31:0] e0;
	logic [31:0] e1;
	//tang 3
	mux2_1_32bit mux3_1 (.a(d0), .b(d1), .sel(sel[2]), .c(e0));
	mux2_1_32bit mux3_2 (.a(d2), .b(d3), .sel(sel[2]), .c(e1));
	//tang 4
	mux2_1_32bit mux4_0 (.a(e0), .b(e1), .sel(sel[3]), .c(y));
endmodule

module fa(
		input logic a, b, c_i,
		output logic s, c_o
);
	assign s = a ^ b ^c_i;
	assign c_o = a&b | (a ^ b) & c_i;
endmodule

//

module fa_sub(
		input logic [3:0] i_alu_op,
		input logic [31:0] i_op_a,
		input logic [31:0] i_op_b,
		output logic [31:0] sum,
		output logic slt,
		output logic sltu
);
		//
		logic sub_en;
		assign sub_en = (~i_alu_op[3] & ~i_alu_op[2] & i_alu_op[1]) | (~i_alu_op[3] & ~i_alu_op[2] & ~i_alu_op[1] & i_alu_op[0]);
		//
		logic [31:0] i_op_b_sub;
		assign i_op_b_sub = sub_en? ~i_op_b:i_op_b;
		//
		logic [31:0] c;

		fa fa0 (.a(i_op_a[0]), .b(i_op_b_sub [0]), .c_i(sub_en), .s(sum[0]), .c_o(c[0]));
		//
		genvar i;
		generate for (i=1; i<32; i++) begin:
		fa_chain
		fa fa_inst(
		.a (i_op_a[i]),
		.b (i_op_b_sub[i]),
		.c_i (c[i-1]),
		.s (sum[i]),
		.c_o (c[i])
		);
		end
		endgenerate
		//
		assign sltu = ~c[31];
		assign slt = ~sum[31]&~c[30]&c[31] | ~sum[31]&c[30]&~c[31] | sum[31]&~c[30]&~c[31] | sum[31]&c[30]&c[31];
endmodule

//
module sll(
		input logic [31:0] i_op_a,
		input logic [4:0] i_op_b,
		output logic [31:0] sll
);
		logic [31:0] s0;
		logic [31:0] s1;
		logic [31:0] s2;
		logic [31:0] s3;
		logic [31:0] s4;
	
	always_comb begin
		//tang 1
		s0 = i_op_b[0]? {i_op_a[30:0], 1'b0} : i_op_a;
		//tang 2
		s1 = i_op_b[1]? {s0[29:0], 2'b0} : s0;
		//tang 3
		s2 = i_op_b[2]? {s1[27:0], 4'b0} : s1;
		//tang 4
		s3 = i_op_b[3]? {s2[23:0], 8'b0} : s2;
		//tang 5
		s4 = i_op_b[4]? {s3[15:0], 16'b0} : s3;
	end
	
		assign sll=s4;
endmodule

//
module srl(
		input logic [31:0] i_op_a,
		input logic [4:0] i_op_b,
		output logic [31:0] srl
);
		logic [31:0] s0;
		logic [31:0] s1;
		logic [31:0] s2;
		logic [31:0] s3;
		logic [31:0] s4;
		
	always_comb begin
		//tang 1
		s0 = i_op_b[0]? {1'b0, i_op_a[31:1]} : i_op_a;
		//tang 2
		s1 = i_op_b[1]? {2'b0, s0[31:2]} : s0;
		//tang 3
		s2 = i_op_b[2]? {4'b0, s1[31:4]} : s1;
		//tang 4
		s3 = i_op_b[3]? {8'b0, s2[31:8]} : s2;
		//tang 5
		s4 = i_op_b[4]? {16'b0, s3[31:16]} : s3;
	end
	
	assign srl = s4;
endmodule

//
module sra(
		input logic [31:0] i_op_a,
		input logic [4:0] i_op_b,
		output logic [31:0] sra
);
		logic [31:0] s0;
		logic [31:0] s1;
		logic [31:0] s2;
		logic [31:0] s3;
		logic [31:0] s4;
		
		always_comb begin
		//tang 1
		s0 = i_op_b[0]? {i_op_a[31], i_op_a[31:1]} : i_op_a;
		//tang 2
		s1 = i_op_b[1]? {{2{i_op_a[31]}}, s0[31:2]} : s0;
		//tang 3
		s2 = i_op_b[2]? {{4{i_op_a[31]}}, s1[31:4]} : s1;
		//tang 4
		s3 = i_op_b[3]? {{8{i_op_a[31]}}, s2[31:8]} : s2;
		//tang 5
		s4 = i_op_b[4]? {{16{i_op_a[31]}}, s3[31:16]} : s3;
	end
	
	assign sra = s4;
endmodule 


//
module shift_32bit(
	input logic [31:0] i_op_a,
	input logic [4:0] i_op_b,
	output logic [31:0] sll, srl, sra
);
	sll sll_32bit(.i_op_a(i_op_a), .i_op_b(i_op_b), .sll(sll));
	srl srl_32bit(.i_op_a(i_op_a), .i_op_b(i_op_b), .srl(srl));
	sra sra_32bit(.i_op_a(i_op_a), .i_op_b(i_op_b), .sra(sra));
endmodule

//
module or_gate (
		input logic [31:0] i_op_a,
		input logic [31:0] i_op_b,
		output logic [31:0] or_result
);
		assign or_result = i_op_a | i_op_b;
endmodule

//
module and_gate (
		input logic [31:0] i_op_a,
		input logic [31:0] i_op_b,
		output logic [31:0] and_result
);
		assign and_result = i_op_a & i_op_b;
endmodule

//
module xor_gate (
		input logic [31:0] i_op_a,
		input logic [31:0] i_op_b,
		output logic [31:0] xor_result
);
		assign xor_result = (~i_op_a & i_op_b) | (i_op_a & ~i_op_b);
endmodule

module logic_32bit(
	input logic [31:0] i_op_a,
	input logic [31:0] i_op_b,
	output logic [31:0] or_result, and_result, xor_result
);
	or_gate or_gate_32bit(.i_op_a(i_op_a), .i_op_b(i_op_b), .or_result(or_result));
	and_gate and_gate_32bit(.i_op_a(i_op_a), .i_op_b(i_op_b), .and_result(and_result));
	xor_gate xor_gate_32bit(.i_op_a(i_op_a), .i_op_b(i_op_b), .xor_result(xor_result));
endmodule

//
module alu(
		input logic [31:0] i_op_a,
		input logic [31:0] i_op_b,
		input logic [3:0] i_alu_op,
		output logic [31:0] o_alu_data
);
	
	//conng, tru, so sanh
	logic [31:0] sum;
	logic slt;
	logic sltu;
	fa_sub cong_tru_ss (.i_alu_op(i_alu_op), .i_op_a(i_op_a), .i_op_b(i_op_b), .sum(sum), .slt(slt), .sltu(sltu));
	
	//logic 32 bit
	logic [31:0] and_result;
	logic [31:0] or_result;
	logic [31:0] xor_result;
	logic_32bit logic_32bit (.i_op_a(i_op_a), .i_op_b(i_op_b), .and_result(and_result), .or_result(or_result), .xor_result(xor_result));
	
	//3 phep dich bit
	logic [31:0] sll;
	logic [31:0] srl;
	logic [31:0] sra;
	shift_32bit shift_32bit (.i_op_a(i_op_a), .i_op_b(i_op_b[4:0]), .sll(sll), .srl(srl), .sra(sra));
	
		
	//chon du lieu xuat
	mux16_1 mux_result (.s0(sum), .s1(sum), .s2({31'b0, slt}), .s3({31'b0, sltu}), .s4(xor_result),
								.s5(or_result), .s6(and_result), .s7(sll), .s8(srl), .s9(sra), .s10(32'b0),
								.s11(32'b0), .s12(32'b0), .s13(32'b0), .s14(32'b0), .s15(i_op_b),
								.y(o_alu_data), .sel(i_alu_op));	
endmodule
