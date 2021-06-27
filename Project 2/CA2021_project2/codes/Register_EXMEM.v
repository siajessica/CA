module Register_EXMEM (
    clk_i,
    start_i,
    stall_i,

    ALU_Res_i,
    MemWrite_Data_i,
    RDaddr_i,

    ALU_Res_o,    
    MemWrite_Data_o,    
    RDaddr_o,

	//Control Signal
    RegWrite_i, 
    MemtoReg_i, 
    MemRead_i,  
    MemWrite_i,

    RegWrite_o, 
    MemtoReg_o, 
    MemRead_o,  
    MemWrite_o
     
);

//Ports
input           clk_i, start_i, stall_i;
input   [31:0]  ALU_Res_i;
input   [31:0]  MemWrite_Data_i;
input   [4:0]   RDaddr_i;
input           RegWrite_i, MemtoReg_i, MemRead_i, MemWrite_i; 

output  [31:0]  ALU_Res_o;
output  [31:0]  MemWrite_Data_o;
output  [4:0]   RDaddr_o;
output          RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o;  

reg     [31:0]  ALU_Res_o;
reg     [31:0]  MemWrite_Data_o;
reg     [4:0]   RDaddr_o;
reg             RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o;  

always @(posedge clk_i) begin
    if(stall_i) begin
    end
    else begin
        if(start_i) begin
            ALU_Res_o           <= ALU_Res_i; 
            MemWrite_Data_o     <= MemWrite_Data_i;  
            RDaddr_o            <= RDaddr_i;   

            RegWrite_o          <= RegWrite_i; 
            MemtoReg_o          <= MemtoReg_i;
            MemRead_o           <= MemRead_i; 
            MemWrite_o          <= MemWrite_i;

        end
        
        else begin
            ALU_Res_o           <= ALU_Res_o; 
            MemWrite_Data_o     <= MemWrite_Data_o;  
            RDaddr_o            <= RDaddr_o;   

            RegWrite_o          <= RegWrite_o; 
            MemtoReg_o          <= MemtoReg_o;
            MemRead_o           <= MemRead_o; 
            MemWrite_o          <= MemWrite_o;

        end 
    end
end

endmodule
