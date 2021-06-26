module Register_MEMWB (
	clk_i, 
	start_i,
	stall_i,

	MemAddr_i,
	MemRead_Data_i,
	RDaddr_i,

	MemAddr_o,
	MemRead_Data_o,
	RDaddr_o,

    //Control Signal
	RegWrite_i,
	MemtoReg_i,
	RegWrite_o,
	MemtoReg_o
);

input               clk_i,start_i, stall_i;
input 	[31:0] 		MemAddr_i,MemRead_Data_i;
input 	[4:0]		RDaddr_i;
input               RegWrite_i, MemtoReg_i;

output 	[31:0] 		MemAddr_o,MemRead_Data_o;
output 	[4:0]		RDaddr_o;
output              RegWrite_o, MemtoReg_o;

reg 	[31:0] 		MemAddr_o,MemRead_Data_o;
reg 	[4:0]		RDaddr_o;
reg                 RegWrite_o, MemtoReg_o;

always @(posedge clk_i) begin
	if(stall_i) begin
		if(start_i)	begin
			MemAddr_o			<= MemAddr_i;		
			MemRead_Data_o		<= MemRead_Data_i;		
			RDaddr_o			<= RDaddr_i;		
			
			RegWrite_o          <= RegWrite_i; 
			MemtoReg_o          <= MemtoReg_i;

		end
		else begin
			MemAddr_o			<= MemAddr_o;		
			MemRead_Data_o		<= MemRead_Data_o;		
			RDaddr_o			<= RDaddr_o;		
			
			RegWrite_o          <= RegWrite_o; 
			MemtoReg_o          <= MemtoReg_o;

		end
	end
end

endmodule