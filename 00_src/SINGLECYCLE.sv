//----------------------------------------------------------------------//
//  Design Note
//----------------------------------------------------------------------//
//  1. Instruction Memory Depth (IMEM): At least 8 kB to run the "isa_1b.hex" or "isa_4b.hex"
//  2. Data        Memory Depth (DMEM): At least 2 kB (0x0000_0000 - 0x0000_07FF)
//  3. IMEM and DMEM are separate memory blocks (Harvard-like structure).

module single_cycle(
	input logic i_clk,
	input logic i_reset,
	input logic [31:0] i_io_sw,
	output logic [31:0] o_pc_debug,
	output logic o_insn_vld,
	output logic [31:0] o_io_ledr,
	output logic [31:0] o_io_ledg,
	output logic [6:0] o_io_hex0, o_io_hex1, o_io_hex2, o_io_hex3, o_io_hex4, o_io_hex5, o_io_hex6, o_io_hex7,
	output logic [31:0] o_io_lcd
);
	//control_unit
	logic [31:0]  instr;      
	logic         br_less;     
	logic         br_equal;    
	logic        pc_sel;      
	logic        rd_wren;     
	logic        insn_vld;   
	logic        br_un;       
	logic        opa_sel;     
	logic        opb_sel;     
	logic [3:0]  alu_op;     
	logic        mem_wren;    
	logic [2:0]  type_sel;  
	logic [1:0]  wb_sel;
	//REGFILE
	logic [31:0] rs1_data;
	logic [31:0] rs2_data;
	logic [31:0] rd_data; //=wb_data
	//PC
	logic [31:0] pc_next;
	logic [31:0] pc;
	logic [31:0] pc_four;
	logic [31:0] alu_data;//chung alu
	//IMMGEN
	logic [31:0] o_data_immgen;
	//alu
	logic [31:0] operand_a;
	logic [31:0] operand_b;
	//LSU
	logic [31:0] ld_data;
	//noi chan
	alu ALU(.i_alu_op (alu_op), .i_op_a(operand_a), .i_op_b(operand_b), .o_alu_data(alu_data));
	
	ControlUnit CU(.instr(instr), .br_less(br_less), .br_equal(br_equal), .pc_sel(pc_sel), .rd_wren(rd_wren), .insn_vld(insn_vld),
						.br_un(br_un), .opa_sel(opa_sel), .opb_sel(opb_sel), .alu_op(alu_op), .mem_wren(mem_wren), .type_sel(type_sel),
						.wb_sel(wb_sel));
						
	imm_gen IMM_GEN (.i_inst(instr), .o_imm(o_data_immgen));
	
	brc BRC (.i_rs1_data(rs1_data), .i_rs2_data(rs2_data), .i_br_un(br_un), .o_br_less(br_less), .o_br_equal(br_equal));
	
	pc PC (.i_clk(i_clk), .i_rst(i_reset), .pc_next(pc_next), .pc_curr(pc));
	
	add_4 pc_plus_4 (.pc(pc), .pc_four(pc_four));
	
	mux_pc MUX_1 (.pc_plus4(pc_four), .alu_data(alu_data), .pc_sel(pc_sel), .pc_next(pc_next));
	
	reg_single pc_debug (.D(pc), .CLK(i_clk), .RST(i_reset), .EN(1'b1), .Q(o_pc_debug));
	
	d_ff_rs insn_vld_debug (.D(insn_vld), .clk(i_clk), .reset(i_reset), .Q(o_insn_vld));
	
	imem I_MEM (.i_reset(i_reset), .i_addr(pc), .o_rdata(instr));
	
	//
	logic [4:0] rs1_addr;
	logic [4:0] rs2_addr;
	logic [4:0] rd_addr;
	assign rs1_addr = instr[19:15];
	assign rs2_addr = instr[24:20];
	assign rd_addr = instr[11:7];
	register REGFILE (.i_clk(i_clk), .i_reset(i_reset), .i_rs1_addr(rs1_addr), .i_rs2_addr(rs2_addr),
							.o_rs1_data(rs1_data), .o_rs2_data(rs2_data), .i_rd_addr(rd_addr), .i_rd_data(rd_data), .i_rd_wren(rd_wren));
							
	mux2_1_32bit MUX_A(.a(rs1_data), .b(pc), .c(operand_a), .sel(opa_sel));
	
	
	mux2_1_32bit MUX_B(.a(rs2_data), .b(o_data_immgen), .c(operand_b), .sel(opb_sel));
	
	lsu2 LSU (.i_clk(i_clk), .i_reset(i_reset), .i_lsu_addr(alu_data), .i_st_data(rs2_data),
				 .i_lsu_wren(mem_wren), .i_io_sw(i_io_sw), .type_sel(type_sel), .o_ld_data(ld_data), .o_io_ledr(o_io_ledr), 
				 .o_io_ledg(o_io_ledg), .o_io_lcd(o_io_lcd), . o_io_hex0(o_io_hex0), .o_io_hex1(o_io_hex1), .o_io_hex2(o_io_hex2),
				 .o_io_hex3(o_io_hex3), .o_io_hex4(o_io_hex4), .o_io_hex5(o_io_hex5), .o_io_hex6(o_io_hex6),  .o_io_hex7(o_io_hex7));
	
	mux4 MUX_C (.pc_four(pc_four), .alu_data(alu_data), .ld_data(ld_data), .wb_data(rd_data), .wb_sel(wb_sel));
endmodule
