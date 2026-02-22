//cộng với 4
module adder_32_const4 (
    input  logic [31:0] i_op_a,
    output logic [31:0] o_sum
);
    logic [31:0] c;
		
   fa fa0 (.a(i_op_a[0]), .b(1'b0), .c_i(1'b0), .s(o_sum[0]), .c_o(c[0]));
   fa fa1 (.a(i_op_a[1]), .b(1'b0), .c_i(c[0]), .s(o_sum[1]), .c_o(c[1]));
   fa fa2 (.a(i_op_a[2]), .b(1'b1), .c_i(c[1]), .s(o_sum[2]), .c_o(c[2]));
   fa fa3 (.a(i_op_a[3]), .b(1'b0), .c_i(c[2]), .s(o_sum[3]), .c_o(c[3]));
   fa fa4 (.a(i_op_a[4]), .b(1'b0), .c_i(c[3]), .s(o_sum[4]), .c_o(c[4]));
   fa fa5 (.a(i_op_a[5]), .b(1'b0), .c_i(c[4]), .s(o_sum[5]), .c_o(c[5]));
   fa fa6 (.a(i_op_a[6]), .b(1'b0), .c_i(c[5]), .s(o_sum[6]), .c_o(c[6]));
   fa fa7 (.a(i_op_a[7]), .b(1'b0), .c_i(c[6]), .s(o_sum[7]), .c_o(c[7]));
   fa fa8 (.a(i_op_a[8]), .b(1'b0), .c_i(c[7]), .s(o_sum[8]), .c_o(c[8]));
   fa fa9 (.a(i_op_a[9]), .b(1'b0), .c_i(c[8]), .s(o_sum[9]), .c_o(c[9]));
   fa fa10 (.a(i_op_a[10]), .b(1'b0), .c_i(c[9]), .s(o_sum[10]), .c_o(c[10]));
   fa fa11 (.a(i_op_a[11]), .b(1'b0), .c_i(c[10]), .s(o_sum[11]), .c_o(c[11]));
   fa fa12 (.a(i_op_a[12]), .b(1'b0), .c_i(c[11]), .s(o_sum[12]), .c_o(c[12]));
   fa fa13 (.a(i_op_a[13]), .b(1'b0), .c_i(c[12]), .s(o_sum[13]), .c_o(c[13]));
   fa fa14 (.a(i_op_a[14]), .b(1'b0), .c_i(c[13]), .s(o_sum[14]), .c_o(c[14]));
   fa fa15 (.a(i_op_a[15]), .b(1'b0), .c_i(c[14]), .s(o_sum[15]), .c_o(c[15]));
   fa fa16 (.a(i_op_a[16]), .b(1'b0), .c_i(c[15]), .s(o_sum[16]), .c_o(c[16]));
   fa fa17 (.a(i_op_a[17]), .b(1'b0), .c_i(c[16]), .s(o_sum[17]), .c_o(c[17]));
   fa fa18 (.a(i_op_a[18]), .b(1'b0), .c_i(c[17]), .s(o_sum[18]), .c_o(c[18]));
   fa fa19 (.a(i_op_a[19]), .b(1'b0), .c_i(c[18]), .s(o_sum[19]), .c_o(c[19]));
   fa fa20 (.a(i_op_a[20]), .b(1'b0), .c_i(c[19]), .s(o_sum[20]), .c_o(c[20]));
   fa fa21 (.a(i_op_a[21]), .b(1'b0), .c_i(c[20]), .s(o_sum[21]), .c_o(c[21]));
   fa fa22 (.a(i_op_a[22]), .b(1'b0), .c_i(c[21]), .s(o_sum[22]), .c_o(c[22]));
   fa fa23 (.a(i_op_a[23]), .b(1'b0), .c_i(c[22]), .s(o_sum[23]), .c_o(c[23]));
   fa fa24 (.a(i_op_a[24]), .b(1'b0), .c_i(c[23]), .s(o_sum[24]), .c_o(c[24]));
   fa fa25 (.a(i_op_a[25]), .b(1'b0), .c_i(c[24]), .s(o_sum[25]), .c_o(c[25]));
   fa fa26 (.a(i_op_a[26]), .b(1'b0), .c_i(c[25]), .s(o_sum[26]), .c_o(c[26]));
   fa fa27 (.a(i_op_a[27]), .b(1'b0), .c_i(c[26]), .s(o_sum[27]), .c_o(c[27]));
   fa fa28 (.a(i_op_a[28]), .b(1'b0), .c_i(c[27]), .s(o_sum[28]), .c_o(c[28]));
   fa fa29 (.a(i_op_a[29]), .b(1'b0), .c_i(c[28]), .s(o_sum[29]), .c_o(c[29]));
   fa fa30 (.a(i_op_a[30]), .b(1'b0), .c_i(c[29]), .s(o_sum[30]), .c_o(c[30]));
   fa fa31 (.a(i_op_a[31]), .b(1'b0), .c_i(c[30]), .s(o_sum[31]), .c_o(c[31]));

endmodule

module add_4(
	input logic [31:0] pc,
	output logic [31:0] pc_four
);
	adder_32_const4 pc_add_4 (.i_op_a(pc), .o_sum(pc_four));
endmodule


module pc(
    input  logic        i_clk,      // clock
    input  logic        i_rst,      // reset
    input  logic [31:0] pc_next,    // địa chỉ lệnh kế tiếp
    output logic [31:0] pc_curr     // địa chỉ lệnh hiện tại
);
    always_ff @(posedge i_clk) begin
        if (~i_rst)
            pc_curr <= 32'b0;
        else
            pc_curr <= pc_next;    
    end
endmodule


module mux_pc(
    input  logic [31:0] pc_plus4,   // PC + 4
    input  logic [31:0] alu_data, // địa chỉ nhảy 
    input  logic        pc_sel,     // 0 = PC+4, 1 = alu_data
    output logic [31:0] pc_next
);
    assign pc_next = (pc_sel) ? alu_data : pc_plus4;
endmodule

//mux
module mux4(
	input logic [31:0] pc_four,
	input logic [31:0] alu_data,
	input logic [31:0] ld_data,
	input logic [1:0] wb_sel,
	output logic [31:0] wb_data
);
	always_comb begin
    case (wb_sel)
        2'b00: wb_data = pc_four;    
        2'b01: wb_data = alu_data;   
        2'b10: wb_data = ld_data;    
        default: wb_data = 32'b0;       
	endcase
	end
endmodule
