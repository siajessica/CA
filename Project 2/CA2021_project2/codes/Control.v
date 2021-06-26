`define R_Type  2'b10
`define I_Type  2'b00
`define S_Type  2'b01
`define SB_Type 2'b11
`define R       7'b0110011
`define I_Imm   7'b0010011
`define I_lw    7'b0000011
`define S       7'b0100011
`define SB      7'b1100011

module Control(
	Op_i,		
	NoOp_i,
	RegWrite_o,
	MemtoReg_o,
	MemRead_o,
	MemWrite_o,
	ALUOp_o,	
	ALUSrc_o,
	Branch_o
);

//Ports
input   [6:0]   Op_i;	
input           NoOp_i;
output  [1:0]   ALUOp_o;
output RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o, ALUSrc_o, Branch_o;

reg     [1:0]   ALUOp_o;
reg RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o, ALUSrc_o, Branch_o;

always @(*) begin
	if (NoOp_i) begin
		RegWrite_o	= 1'b0;
		MemtoReg_o	= 1'b0;
		MemRead_o	= 1'b0;
		MemWrite_o	= 1'b0;
		ALUOp_o		= `R_Type;
		ALUSrc_o	= 1'b0;
		Branch_o	= 1'b0;
	end
	else begin
		case(Op_i)
			`R: begin
				RegWrite_o	= 1'b1;
				MemtoReg_o	= 1'b0;
				MemRead_o	= 1'b0;
				MemWrite_o	= 1'b0;
				ALUOp_o		= `R_Type;
				ALUSrc_o	= 1'b0;
				Branch_o	= 1'b0;
			end

			`I_Imm: begin
				RegWrite_o	= 1'b1;
				MemtoReg_o	= 1'b0;
				MemRead_o	= 1'b0;
				MemWrite_o	= 1'b0;
				ALUOp_o		= `I_Type;
				ALUSrc_o	= 1'b1;
				Branch_o	= 1'b0;
			end
 
			`I_lw: begin
				RegWrite_o	= 1'b1;
				MemtoReg_o	= 1'b1;
				MemRead_o	= 1'b1;
				MemWrite_o	= 1'b0;
				ALUOp_o		= `I_Type;
				ALUSrc_o	= 1'b1;
				Branch_o	= 1'b0;
			end

			`S: begin
				RegWrite_o	= 1'b0;
				MemtoReg_o	= 1'b0;
				MemRead_o	= 1'b0;
				MemWrite_o	= 1'b1;
				ALUOp_o		= `S_Type;
				ALUSrc_o	= 1'b1;
				Branch_o	= 1'b0;
			end

			`SB: begin
				RegWrite_o	= 1'b0;
				MemtoReg_o	= 1'b0;
				MemRead_o	= 1'b0;
				MemWrite_o	= 1'b0;
				ALUOp_o		= `SB_Type;
				ALUSrc_o	= 1'b0;
				Branch_o	= 1'b1;
			end

			default: begin
				RegWrite_o	= 1'b0;
				MemtoReg_o	= 1'b0;
				MemRead_o	= 1'b0;
				MemWrite_o	= 1'b0;
				ALUOp_o		= `SB_Type;
				ALUSrc_o	= 1'b0;
				Branch_o	= 1'b0;
			end
		endcase	
	end
end


endmodule
