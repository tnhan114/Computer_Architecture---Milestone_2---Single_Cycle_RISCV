module imm_gen(
		input logic [31:0] i_inst,
		output logic [31:0] o_imm 
);
		parameter I_type_layout = 7'b0010011;
		parameter I_type_load = 7'b0000011;
		parameter S_type = 7'b0100011;
		parameter B_type = 7'b1100011;
		parameter U_type = 7'b0110111;
		parameter J_type = 7'b1101111;
		parameter auipc = 7'b0010111;
		parameter Jalr = 7'b1100111;

		always_comb begin
						o_imm = 32'b0;
						case(i_inst[6:0])
								I_type_layout: begin
													o_imm[4:0] = i_inst[24:20];
													o_imm[10:5] = i_inst[30:25];
													o_imm[11] = i_inst[31];
													o_imm[31:12] = {20{i_inst[31]}};
													end
								S_type: begin
										  o_imm[4:0] = i_inst[11:7];
										  o_imm[10:5] = i_inst[30:25];
										  o_imm[31:12] = {20{i_inst[31]}};
										  end
								B_type: begin
										  o_imm[0] = 1'b0;
										  o_imm[4:1] = i_inst[11:8];
										  o_imm[10:5] = i_inst[30:25];
										  o_imm[11] = i_inst[7];
										  o_imm[31:12] = {20{i_inst[31]}};
										  end
								J_type: begin
										  o_imm[0] = 1'b0;
										  o_imm[4:1] = i_inst[24:21];
										  o_imm[10:5] = i_inst[30:25];
										  o_imm[11] = i_inst[20];
										  o_imm[19:12] = i_inst[19:12];
										  o_imm[31:20] = {12{i_inst[31]}};
										  end
								U_type: begin
										  o_imm[31:12] = i_inst[31:12];
										  o_imm[11:0] = 12'b0;
										  end
								I_type_load: begin
												 o_imm[11:0] = i_inst[31:20];
												 o_imm[31:12] = {20{i_inst[31]}};
												 end
								auipc: begin
										 o_imm[31:12] = i_inst[31:12];
										 o_imm[11:0] = 12'b0;
                               end
								Jalr: begin 
									   o_imm[11:0] = i_inst[31:20];
								      o_imm[31:12] = {20{i_inst[31]}};
										end
										default: o_imm[31:0] = 32'b0;
						endcase
						end
endmodule
