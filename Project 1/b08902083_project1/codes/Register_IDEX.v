module Register_IDEX (
	clk_i,
	start_i,

	RS1Data_i,
	RS2Data_i,
    RS1Data_o,
	RS2Data_o,

	SignExtend_Res_i,
    SignExtend_Res_o,

	funct_i,
	funct_o,

    RDaddr_i,
	RDaddr_o,
    
    RS1Addr_i,
	RS2Addr_i,
	RS1Addr_o,
	RS2Addr_o,

    //Control Signal
	RegWrite_i,
	MemtoReg_i,
	MemRead_i,
	MemWrite_i,
	ALUOp_i,
	ALUSrc_i,
	RegWrite_o,
	MemtoReg_o,
	MemRead_o,
	MemWrite_o,
	ALUOp_o,
	ALUSrc_o
);

input           clk_i, start_i;
input   [31:0]  RS1Data_i, RS2Data_i;
input   [31:0]  SignExtend_Res_i;
input   [9:0]   funct_i;
input   [4:0]   RDaddr_i;
input   [4:0]   RS1Addr_i, RS2Addr_i;
input   [1:0]   ALUOp_i;
input           RegWrite_i, MemtoReg_i, MemRead_i, MemWrite_i, ALUSrc_i;	

output  [31:0]  RS1Data_o, RS2Data_o;
output  [31:0]  SignExtend_Res_o;
output  [9:0]   funct_o;
output  [4:0]   RDaddr_o;
output  [4:0]   RS1Addr_o, RS2Addr_o;
output  [1:0]   ALUOp_o;
output          RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o, ALUSrc_o;	

reg     [31:0]  RS1Data_o, RS2Data_o;
reg     [31:0]  SignExtend_Res_o;
reg     [9:0]   funct_o;
reg     [4:0]   RDaddr_o;
reg     [4:0]   RS1Addr_o, RS2Addr_o;
reg     [1:0]   ALUOp_o;
reg             RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o, ALUSrc_o;	

always @(posedge clk_i) begin
	if(start_i) begin 
		RS1Data_o 		    <= RS1Data_i;
		RS2Data_o 		    <= RS2Data_i;
		SignExtend_Res_o 	<= SignExtend_Res_i;
		funct_o				<= funct_i;
		RDaddr_o       		<= RDaddr_i;
		RS1Addr_o       	<= RS1Addr_i;
		RS2Addr_o       	<= RS2Addr_i;
	
		RegWrite_o          <= RegWrite_i; 
		MemtoReg_o          <= MemtoReg_i;
		MemRead_o           <= MemRead_i; 
		MemWrite_o          <= MemWrite_i;
		ALUOp_o             <= ALUOp_i;
		ALUSrc_o            <= ALUSrc_i;

	end 
	else begin
		RS1Data_o 		    <= RS1Data_o;
		RS2Data_o 		    <= RS2Data_o;
		SignExtend_Res_o    <= SignExtend_Res_o;
		funct_o				<= funct_o;
		RDaddr_o            <= RDaddr_o;
		RS1Addr_o       	<= RS1Addr_o;
		RS2Addr_o       	<= RS2Addr_o;
	
		RegWrite_o          <= RegWrite_o; 
		MemtoReg_o          <= MemtoReg_o;
		MemRead_o           <= MemRead_o; 
		MemWrite_o          <= MemWrite_o;
		ALUOp_o             <= ALUOp_o;
		ALUSrc_o            <= ALUSrc_o;
	end 
end

endmodule