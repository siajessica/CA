module CPU(
    clk_i,
    rst_i,
    start_i,
    
    mem_data_i,
    mem_ack_i,   
    mem_data_o,
    mem_addr_o,
    mem_enable_o,
    mem_write_o,
);
// Ports
input               clk_i;
input               rst_i;
input               start_i;
input   [255:0]     mem_data_i;
input               mem_ack_i;
output  [255:0]     mem_data_o;
output  [31:0]      mem_addr_o;
output              mem_enable_o,mem_write_o;         

// PC
wire    [31:0]      PC_now,PC_Four,PC_Branch;
wire    [31:0]      instr;

// Control
wire                Ctrl_RegWrite,Ctrl_MemtoReg,Ctrl_MemRead,Ctrl_MemWrite,Ctrl_ALUSrc,Ctrl_Branch;
wire    [1:0]       Ctrl_ALUOp;

// ALU_Control
wire    [3:0]       ALUCtrl;

// Registers
wire    [31:0]      RS2data,RS1data;

// ALU
wire    [31:0]      ALU_Res;

//Sign_Extend
wire    [31:0]      SignExtend_Res;

// MUX32
wire    [31:0]      MUX_ALUSrc_Res;
wire    [31:0]      MUX_MemtoReg_Result;
wire    [31:0]      MUX_PC_Res;

// Data_Memory

// Register_IFID
wire    [31:0]      IFID_instr;
wire    [31:0]      IFID_pc;

// Register_IDEX
wire    [31:0]      IDEX_RS1Data,IDEX_RS2Data;
wire    [31:0]      IDEX_SignExtend;
wire    [9:0]       IDEX_funct;
wire    [4:0]       IDEX_RDAddr,IDEX_RS1Addr,IDEX_RS2Addr;  
wire    [1:0]       IDEX_ALUOp;
wire                IDEX_RegWrite, IDEX_MemtoReg, IDEX_MemRead, IDEX_MemWrite, IDEX_ALUSrc;

// Register_EXMEM
wire    [31:0]      EXMEM_ALU_Res,EXMEM_MemWriteData;
wire    [4:0]       EXMEM_RDAddr;
wire                EXMEM_RegWrite,EXMEM_MemtoReg, EXMEM_MemRead, EXMEM_MemWrite;

// Register_MEMWB
wire    [31:0]      MEMWB_ALU_Res,MEMWB_MemReadData;
wire    [4:0]       MEMWB_RDAddr;
wire                MEMWB_RegWrite, MEMWB_MemtoReg;

// Forwarding_Unit
wire    [1:0]       Forward_A;
wire    [1:0]       Forward_B;
// MUX32_4
wire    [31:0]      ForwardA_MUX_Res;
wire    [31:0]      ForwardB_MUX_Res;

// And
wire                Flush;

// Equal
wire                Equal_Res;

// Shift_Left
wire    [31:0]      ShiftLeft_Res;

//Hazard_Detection
wire PCWrite;
wire Stall;
wire NoOp;

// Cache_Control
wire    [31:0]      CacheCtrl_MEMWB_Data;
wire                CacheCtrl_Stall;

Adder Add_PC(
    .data1_in   (PC_now),       
    .data2_in   (32'd4),            
    .data_o     (PC_Four)   
);

Adder Add_Branch(
    .data1_in   (ShiftLeft_Res),       
    .data2_in   (IFID_pc),            
    .data_o     (PC_Branch)   
);

ALU ALU(
    .data1_i    (ForwardA_MUX_Res),                  
    .data2_i    (MUX_ALUSrc_Res),
    .ALUCtrl_i  (ALUCtrl),                
    .data_o     (ALU_Res)            
);

ALU_Control ALU_Control(
    .funct_i    (IDEX_funct),  
    .ALUOp_i    (IDEX_ALUOp),                        
    .ALUCtrl_o  (ALUCtrl)                       
);

And And(
    .data1_i(Ctrl_Branch),
    .data2_i(Equal_Res),
    .data_o(Flush)
);

Control Control(
    .Op_i(IFID_instr[6:0]), 
    .NoOp_i(NoOp),      
    .RegWrite_o(Ctrl_RegWrite),
    .MemtoReg_o(Ctrl_MemtoReg),
    .MemRead_o(Ctrl_MemRead),
    .MemWrite_o(Ctrl_MemWrite),
    .ALUOp_o(Ctrl_ALUOp),    
    .ALUSrc_o(Ctrl_ALUSrc),
    .Branch_o(Ctrl_Branch)
);

Equal Equal(
    .data1_i(RS1data),
    .data2_i(RS2data),
    .equal_o(Equal_Res)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (PC_now),     
    .instr_o    (instr)            
);

MUX32 MUX_ALUSrc(
    .data1_i    (ForwardB_MUX_Res),          
    .data2_i    (IDEX_SignExtend),    
    .select_i   (IDEX_ALUSrc),               
    .data_o     (MUX_ALUSrc_Res)              
);

MUX32 MUX_MemtoReg(
    .data1_i    (MEMWB_ALU_Res),          
    .data2_i    (MEMWB_MemReadData),    
    .select_i   (MEMWB_MemtoReg),               
    .data_o     (MUX_MemtoReg_Result)  
);

MUX32 MUX_PC(
    .data1_i    (PC_Four),          
    .data2_i    (PC_Branch),    
    .select_i   (Flush),               
    .data_o     (MUX_PC_Res)  
);

Registers Registers(
    .clk_i      (clk_i),    
    .RS1addr_i  (IFID_instr[19:15]),         
    .RS2addr_i  (IFID_instr[24:20]),         
    .RDaddr_i   (MEMWB_RDAddr),         
    .RDdata_i   (MUX_MemtoReg_Result),            
    .RegWrite_i (MEMWB_RegWrite),             
    .RS1data_o  (RS1data),              
    .RS2data_o  (RS2data)               
);

Sign_Extend Sign_Extend(
    .data_i     (IFID_instr[31:0]),        
    .data_o     (SignExtend_Res)     
);
  
Shift_Left Shift_Left(
    .data_i     (SignExtend_Res), 
    .data_o     (ShiftLeft_Res)
);

Forwarding_Unit Forwarding_Unit(
    .EX_Rs1_i (IDEX_RS1Addr),
    .EX_Rs2_i (IDEX_RS2Addr),
    .MEM_RegWrite_i (EXMEM_RegWrite),
    .MEM_Rd_i (EXMEM_RDAddr),
    .WB_RegWrite_i (MEMWB_RegWrite),
    .WB_Rd_i (MEMWB_RDAddr),
    .Forward_A_o (Forward_A),
    .Forward_B_o (Forward_B)
);

MUX32_4 ForwardA_MUX(
    .Forward_i (Forward_A),
    .EX_RS_Data_i (IDEX_RS1Data),
    .MEM_ALU_Result_i (EXMEM_ALU_Res),
    .WB_WriteData_i (MUX_MemtoReg_Result),
    .MUX_Result_o (ForwardA_MUX_Res)
);

MUX32_4 ForwardB_MUX(
    .Forward_i (Forward_B),
    .EX_RS_Data_i (IDEX_RS2Data),
    .MEM_ALU_Result_i (EXMEM_ALU_Res),
    .WB_WriteData_i (MUX_MemtoReg_Result),
    .MUX_Result_o (ForwardB_MUX_Res)
);

Hazard_Detection Hazard_Detection(
    .RS1addr_i(IFID_instr[19:15]),
    .RS2addr_i(IFID_instr[24:20]),
    .MemRead_i(IDEX_MemRead), 
    .RdAddr_i(IDEX_RDAddr),
    .PCWrite_o(PCWrite),
    .Stall_o(Stall),
    .NoOp_o(NoOp)
);

// Changes for Project 2

PC PC(
    .clk_i      (clk_i),     
    .rst_i      (rst_i),     
    .start_i    (start_i),
    .stall_i    (CacheCtrl_Stall), 
    .PCWrite_i  (PCWrite),    
    .pc_i       (MUX_PC_Res),     
    .pc_o       (PC_now)           
);

Register_IFID IFID(
    .clk_i(clk_i),
    .start_i(start_i),
    .stall_i(CacheCtrl_Stall), 

    .instr_i(instr),
    .pc_i(PC_now),

    .Stall_i(Stall),
    .Flush_i(Flush),

    .instr_o(IFID_instr),
    .pc_o(IFID_pc)
);

Register_IDEX IDEX(
    .clk_i(clk_i), 
    .start_i(start_i),
    .stall_i(CacheCtrl_Stall), 

    .RS1Data_i(RS1data), 
    .RS2Data_i(RS2data),
    .SignExtended_i(SignExtend_Res), 
    .funct_i({IFID_instr[31:25],IFID_instr[14:12]}),
    .RdAddr_i(IFID_instr[11:7]),
    .RS1Addr_i(IFID_instr[19:15]),
    .RS2Addr_i(IFID_instr[24:20]),

    .RS1Data_o(IDEX_RS1Data),
    .RS2Data_o(IDEX_RS2Data),
    .SignExtended_o(IDEX_SignExtend),
    .funct_o(IDEX_funct),
    .RdAddr_o(IDEX_RDAddr),
    .RS1Addr_o(IDEX_RS1Addr),
    .RS2Addr_o(IDEX_RS2Addr),

    //Control Signal
    .RegWrite_i(Ctrl_RegWrite), 
    .MemtoReg_i(Ctrl_MemtoReg), 
    .MemRead_i(Ctrl_MemRead),  
    .MemWrite_i(Ctrl_MemWrite), 
    .ALUOp_i(Ctrl_ALUOp), 
    .ALUSrc_i(Ctrl_ALUSrc),
    .RegWrite_o(IDEX_RegWrite),
    .MemtoReg_o(IDEX_MemtoReg),
    .MemRead_o(IDEX_MemRead),
    .MemWrite_o(IDEX_MemWrite),
    .ALUOp_o(IDEX_ALUOp),
    .ALUSrc_o(IDEX_ALUSrc)
);

Register_EXMEM EXMEM(
    .clk_i(clk_i),
    .start_i(start_i),
    .stall_i(CacheCtrl_Stall), 

    .ALU_Result_i(ALU_Res),
    .MemWrite_Data_i(ForwardB_MUX_Res),
    .RdAddr_i(IDEX_RDAddr),

    .ALU_Result_o(EXMEM_ALU_Res),
    .MemWrite_Data_o(EXMEM_MemWriteData),
    .RdAddr_o(EXMEM_RDAddr),

    //Control Signal
    .RegWrite_i(IDEX_RegWrite), 
    .MemtoReg_i(IDEX_MemtoReg), 
    .MemRead_i(IDEX_MemRead),  
    .MemWrite_i(IDEX_MemWrite), 
    .RegWrite_o(EXMEM_RegWrite), 
    .MemtoReg_o(EXMEM_MemtoReg), 
    .MemRead_o(EXMEM_MemRead),  
    .MemWrite_o(EXMEM_MemWrite)
);

Register_MEMWB MEMWB(
    .clk_i(clk_i), 
    .start_i(start_i),
    .stall_i(CacheCtrl_Stall), 

    .MemAddr_i(EXMEM_ALU_Res),
    .MemRead_Data_i(CacheCtrl_MEMWB_Data),
    .RdAddr_i(EXMEM_RDAddr),

    .MemAddr_o(MEMWB_ALU_Res),
    .MemRead_Data_o(MEMWB_MemReadData),
    .RdAddr_o(MEMWB_RDAddr),

    //Control Signal
    .RegWrite_i(EXMEM_RegWrite),
    .MemtoReg_i(EXMEM_MemtoReg),
    .RegWrite_o(MEMWB_RegWrite),
    .MemtoReg_o(MEMWB_MemtoReg)
);

dcache_controller dcache(
    .clk_i(clk_i), 
    .rst_i(rst_i),

    .mem_data_i(mem_data_i), 
    .mem_ack_i(mem_ack_i),
    .mem_data_o(mem_data_o),
    .mem_addr_o(mem_addr_o), 
    .mem_enable_o(mem_enable_o), 
    .mem_write_o(mem_write_o), 

    .cpu_data_i(EXMEM_MemWriteData), 
    .cpu_addr_i(EXMEM_ALU_Res),
    .cpu_MemRead_i(EXMEM_MemRead), 
    .cpu_MemWrite_i(EXMEM_MemWrite), 
    .cpu_data_o(CacheCtrl_MEMWB_Data), 
    .cpu_stall_o(CacheCtrl_Stall)
);



endmodule

