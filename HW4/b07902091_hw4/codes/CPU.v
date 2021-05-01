module CPU
(
    clk_i, 
    rst_i,
    start_i
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;

// Wire/Reg
wire    [31:0]      instr_addr,next_instr_addr,instr,RS2data,RS1data,Mux_data,ALU_data,Sign_Extend_data,Four;
wire    [1:0]       ALUOp;
wire    [2:0]       ALUCtrl;
wire                RegWrite,ALUSrc,Zero;

assign Four = 32'd4;

Control Control(
    .Op_i       (instr[6:0]),
    .ALUOp_o    (ALUOp),      
    .ALUSrc_o   (ALUSrc),      	
    .RegWrite_o (RegWrite)   
);

Adder Add_PC(
    .data1_in   (instr_addr),       
    .data2_in   (Four),            
    .data_o     (next_instr_addr)   
);

PC PC(
    .clk_i      (clk_i),     
    .rst_i      (rst_i),     
    .start_i    (start_i),     
    .pc_i       (next_instr_addr),     
    .pc_o       (instr_addr)           
);

Instruction_Memory Instruction_Memory(
    .addr_i     (instr_addr),     
    .instr_o    (instr)            
);

Registers Registers(
    .clk_i     	(clk_i),    
    .RS1addr_i  (instr[19:15]),         
    .RS2addr_i  (instr[24:20]),         
    .RDaddr_i   (instr[11:7]),         
    .RDdata_i   (ALU_data),            
    .RegWrite_i (RegWrite),   			
    .RS1data_o  (RS1data),          	
    .RS2data_o  (RS2data)    			
);

MUX32 MUX_ALUSrc(
    .data1_i    (RS2data),  		
    .data2_i    (Sign_Extend_data),    
    .select_i   (ALUSrc),     			
    .data_o     (Mux_data)           	
);

Sign_Extend Sign_Extend(
    .data_i     (instr[31:20]),        
    .data_o     (Sign_Extend_data)     
);
  
ALU ALU(
    .data1_i    (RS1data),      			
    .data2_i    (Mux_data),
    .ALUCtrl_i  (ALUCtrl),                
    .data_o     (ALU_data),             
    .Zero_o     (Zero)                    
);

ALU_Control ALU_Control(
    .funct_i    ({instr[31:25],instr[14:12]}),  
    .ALUOp_i    (ALUOp),              			
    .ALUCtrl_o  (ALUCtrl)                       
);

endmodule

