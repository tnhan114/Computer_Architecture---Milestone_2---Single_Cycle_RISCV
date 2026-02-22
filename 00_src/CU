module ControlUnit (
	input logic [31:0]  instr,       // mã lệnh 32-bit
	input logic         br_less,     // cờ so sánh nhỏ hơn (từ BRC)
	input logic         br_equal,    // cờ so sánh bằng (từ BRC)
	output logic        pc_sel,      // 0: PC + 4, 1: ALU (nhảy hoặc branch)
	output logic        rd_wren,     // 0: không cho phép ghi vào rd, 1: cho phép ghi
	output logic        insn_vld,    // cờ hợp lệ của instruction (1: hợp lệ)
	output logic        br_un,       // 0: so sánh có dấu, 1: so sánh không dấu
	output logic        opa_sel,     // chọn toán hạng A của ALU (0: rs1, 1: PC)
	output logic        opb_sel,     // chọn toán hạng B của ALU (0: rs2, 1: immediate)
	output logic [3:0]  alu_op,      // chọn loại phép toán ALU (add, sub, and, or, v.v.)
	output logic        mem_wren,    // 1: ghi bộ nhớ, 0: đọc bộ nhớ
	output logic [2:0]  type_sel,    // kiểu dữ liệu truy cập bộ nhớ:
                                 //   000: byte
                                 //   001: half word
                                 //   010: word
                                 //   100: byte unsigned
                                 //   101: half word unsigned
                                 //   111: reserved
	output logic [1:0]  wb_sel   	 // chọn dữ liệu ghi về register file:
                                 //   00: pc_4 (PC + 4)
                                 //   01: alu_data (kết quả từ ALU)
                                 //   10: ld_data (dữ liệu load từ memory)
);


// Tách opcode / funct3 / funct7
	logic [6:0] opcode;
	logic [2:0] funct3;
	logic [6:0] funct7;

	assign opcode = instr[6:0];
	assign funct3 = instr[14:12];
	assign funct7 = instr[31:25];

// Mặc định (reset các tín hiệu)
	always_comb begin
					pc_sel   = 0;
					rd_wren  = 0;
					insn_vld = 1;
					br_un    = 0;
					opa_sel  = 0;
					opb_sel  = 0;
					alu_op   = 4'b0000;
					mem_wren = 0;
					type_sel = 3'b111;
					wb_sel   = 2'b11; //không làm gì

		case (opcode)

// R-format (add, sub, and, or, xor, sll, srl, sra, slt, sltu)
				7'b0110011: begin
								pc_sel   = 0; rd_wren = 1;
								opa_sel  = 0; opb_sel = 0;
								mem_wren = 0; wb_sel  = 2'b01;
								case (funct3)
										3'b000: alu_op = (funct7[5])? 4'b0001:4'b0000; // add hoac sub
										3'b010: alu_op = 4'b0010; // slt
										3'b011: alu_op = 4'b0011; // sltu
										3'b100: alu_op = 4'b0100; // xor
										3'b110: alu_op = 4'b0101; // or
										3'b111: alu_op = 4'b0110; // and
										3'b001: alu_op = 4'b0111; // sll
										3'b101: alu_op = (funct7[5])? 4'b1001:4'b1000; // sra hoac srl
										default: alu_op = 4'b1010;
								endcase
								end


// I-format layout (addi, andi, ori, xori, slti, sltiu, slli, srli, srai)
				7'b0010011: begin
								pc_sel   = 0; rd_wren = 1;
								opa_sel  = 0; opb_sel = 1;
								mem_wren = 0; wb_sel  = 2'b01;
								case (funct3)
										3'b000: alu_op = 4'b0000; // addi
										3'b010: alu_op = 4'b0010; // slti
										3'b011: alu_op = 4'b0011; // sltiu
										3'b100: alu_op = 4'b0100; // xori
										3'b110: alu_op = 4'b0101; // ori
										3'b111: alu_op = 4'b0110; // andi
										3'b001: alu_op = 4'b0111; // slli
										3'b101: alu_op = (funct7[5])? 4'b1001:4'b1000; // srai hoac srli
										default: alu_op = 4'b1111;         // nop
												endcase
												end 

// I- format: Load (lb, lh, lw, lbu, lhu)
					7'b0000011: begin
									pc_sel   = 0; rd_wren = 1;
									opa_sel  = 0; opb_sel = 1;
									mem_wren = 0; wb_sel = 2'b10; 
									alu_op = 4'b0000;
									case (funct3)
											3'b000:  type_sel = 3'b000;
											3'b001:  type_sel = 3'b001;
											3'b010:  type_sel = 3'b010; 
											3'b100:  type_sel = 3'b100;
											3'b101:  type_sel = 3'b101; 
											default: type_sel = 3'b111; //reserved 
									endcase 
									end

// S - format: Store (sb, sh, sw)
					7'b0100011: begin
									pc_sel   = 0; rd_wren = 0;
									opa_sel  = 0; opb_sel = 1;
									mem_wren = 1; wb_sel = 2'b11; 
									alu_op = 4'b0000;
									case (funct3)
											3'b000:  type_sel = 3'b000;
											3'b001:  type_sel = 3'b001;
											3'b010:  type_sel = 3'b010; 
											default: type_sel = 3'b111; //reserved 
									endcase 
									end

// B - format (beq, bne, blt, bge, bltu, bgeu)
					7'b1100011: begin
									rd_wren = 0;
									opa_sel  = 1; opb_sel = 1;
									mem_wren = 0; wb_sel = 2'b11; 
									alu_op = 4'b0000;
									br_un = funct3[1];  // 1: không dấu (BLTU, BGEU); 0: có dấu (BLT, BGE)
									case (funct3)
											3'b000: pc_sel = br_equal;  // beq
											3'b001: pc_sel = ~br_equal; // bne
											3'b100: pc_sel = br_less;   // blt
											3'b101: pc_sel = ~br_less;  // bge
											3'b110: pc_sel = br_less;   // bltu
											3'b111: pc_sel = ~br_less;  // bgeu
											default: pc_sel = 1'b0; //kết hợp 2 điều kiện pc_sel và br_un để phân biệt lệnh B-type
									endcase
									end

// J - format (jal)
					7'b1101111: begin
									pc_sel   = 1; rd_wren = 1;
									opa_sel  = 1; opb_sel = 1;
									mem_wren = 0; wb_sel  = 2'b00; 
									alu_op = 4'b0000;
									end

// U - format (lui)
					7'b0110111: begin
									pc_sel   = 0; rd_wren = 1;
									opa_sel  = 0; opb_sel = 1;
									mem_wren = 0; wb_sel  = 2'b01; 
									alu_op = 4'b1111; //nop: ko dùng ALU 
									end

// U - format (auipc)
					7'b0010111: begin
									pc_sel   = 0; rd_wren = 1;
									opa_sel  = 1; opb_sel = 1;
									mem_wren = 0; wb_sel  = 2'b01; 
									alu_op = 4'b0000;
									end

// jalr
					7'b1100111: begin
									pc_sel   = 1; rd_wren = 1;
									opa_sel  = 0; opb_sel = 1;
									mem_wren = 0; wb_sel  = 2'b00; 
									alu_op = 4'b0000;
									end
           

					default: begin
								insn_vld = 0;
								rd_wren  = 0;
								end
					endcase
					end
endmodule
