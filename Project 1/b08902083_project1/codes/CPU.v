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

//PC
wire    [31:0]  PC_now, PC_four, PC_branch;
wire    [31:0]  instr;

//Registers
wire    [31:0]  RS1Data, RS2Data;

//Sign_Extend
wire    [31:0]  SignExtend_Res;

//MUX32
wire    [31:0]  MUX_PC_Res;
wire    [31:0]  MUX_MemtoReg_Res;
wire    [31:0]  MUX_ALUSrc_Res;

//MUX32_4i
wire    [31:0]  ForwardA_MUX_Res;
wire    [31:0]  ForwardB_MUX_Res;

//And
wire            Flush;

//Equal
wire            Equal_Res;

//Shift Left
wire    [31:0]  ShiftLeft_Res;

//Data Memory
wire    [31:0]  MemRead_Res;

//ALU
wire     [31:0]  ALU_Res;

//ALU_Control
wire     [3:0]  ALUCtrl;

//Control
wire     [1:0]  Ctrl_ALUOp;
wire            Ctrl_RegWrite, Ctrl_MemtoReg, Ctrl_MemRead, Ctrl_MemWrite, Ctrl_ALUSrc, Ctrl_Branch;

//Register IF/ID
wire     [31:0] IFID_instr;
wire     [31:0] IFID_PC;

//Register ID/EX
wire     [31:0] IDEX_RS1Data, IDEX_RS2Data;
wire     [31:0] IDEX_SignExtend_Res;
wire     [9:0]  IDEX_funct;
wire     [4:0]  IDEX_RDaddr;
wire     [4:0]  IDEX_RS1Addr, IDEX_RS2Addr;
wire     [1:0]  IDEX_ALUOp;
wire            IDEX_RegWrite, IDEX_MemtoReg, IDEX_MemRead, IDEX_MemWrite, IDEX_ALUSrc;

// Register_EXMEM
wire     [31:0] EXMEM_ALU_Res;
wire     [31:0] EXMEM_MemWrite_Data;
wire     [4:0]  EXMEM_RDaddr;
wire            EXMEM_RegWrite,EXMEM_MemtoReg, EXMEM_MemRead, EXMEM_MemWrite;

// Register_MEMWB
wire     [31:0] MEMWB_ALU_Res;
wire     [31:0] MEMWB_MemRead_Data;
wire     [4:0]  MEMWB_RDaddr;
wire            MEMWB_RegWrite, MEMWB_MemtoReg;

//Hazard Detection
wire            PCWrite;
wire            Stall;
wire            NoOp;

//Forwarding Unit
wire     [1:0]  Forward_A, Forward_B;


Adder Add_PC(
    .data1_in   (PC_now),
    .data2_in   (32'd4),
    .data_o     (PC_four)
);

Adder Add_Branch(
    .data1_in   (ShiftLeft_Res),
    .data2_in   (IFID_PC),
    .data_o     (PC_branch)
);

AND And(
    .data1_in   (Ctrl_Branch),
    .data2_in   (Equal_Res),
    .data_o     (Flush)
);

Equal Equal(
    .data1_in   (RS1Data),
    .data2_in   (RS2Data),
    .data_o     (Equal_Res)
);

PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .PCWrite_i  (PCWrite),
    .pc_i       (MUX_PC_Res),
    .pc_o       (PC_now)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (PC_now), 
    .instr_o    (instr)
);

Data_Memory Data_Memory(
    .clk_i          (clk_i), 
    .addr_i         (EXMEM_ALU_Res), 
    .MemRead_i      (EXMEM_MemRead),
    .MemWrite_i     (EXMEM_MemWrite),
    .data_i         (EXMEM_MemWrite_Data),
    .data_o         (MemRead_Res)
);

MUX32 MUX_ALUSrc(
    .data1_i    (ForwardB_MUX_Res),
    .data2_i    (IDEX_SignExtend_Res),
    .select_i   (IDEX_ALUSrc),
    .data_o     (MUX_ALUSrc_Res)
);

MUX32 MUX_MemtoReg(
    .data1_i    (MEMWB_ALU_Res),
    .data2_i    (MEMWB_MemRead_Data),
    .select_i   (MEMWB_MemtoReg),
    .data_o     (MUX_MemtoReg_Res)
);

MUX32 MUX_PC(
    .data1_i    (PC_four),
    .data2_i    (PC_branch),
    .select_i   (Flush),
    .data_o     (MUX_PC_Res)
);

Sign_Extend Sign_Extend(
    .data_i     (IFID_instr[31:0]),
    .data_o     (SignExtend_Res)
);

Shift_Left ShiftLeft(
	.data_i     (SignExtend_Res), 
	.data_o     (ShiftLeft_Res)
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

Registers Registers(
    .clk_i          (clk_i),
    .RS1addr_i      (IFID_instr[19:15]),
    .RS2addr_i      (IFID_instr[24:20]),
    .RDaddr_i       (MEMWB_RDaddr), 
    .RDdata_i       (MUX_MemtoReg_Res),
    .RegWrite_i     (MEMWB_RegWrite), 
    .RS1data_o      (RS1Data), 
    .RS2data_o      (RS2Data) 
);

Control Control(
	.Op_i       (IFID_instr[6:0]),		
	.NoOp_i     (NoOp),
	.RegWrite_o (Ctrl_RegWrite),
	.MemtoReg_o (Ctrl_MemtoReg),
	.MemRead_o  (Ctrl_MemRead),
	.MemWrite_o (Ctrl_MemWrite),
	.ALUOp_o    (Ctrl_ALUOp),	
	.ALUSrc_o   (Ctrl_ALUSrc),
	.Branch_o   (Ctrl_Branch)
);

Register_IFID Register_IFID(
	.clk_i      (clk_i),
	.start_i    (start_i),

    .instr_i    (instr),
    .pc_i       (PC_now),
	.instr_o    (IFID_instr),
    .pc_o       (IFID_PC),

    .Stall_i    (Stall),
    .Flush_i    (Flush)
);

Register_IDEX Register_IDEX (
	.clk_i      (clk_i),
	.start_i    (start_i),

	.RS1Data_i  (RS1Data),
	.RS2Data_i  (RS2Data),
    .RS1Data_o  (IDEX_RS1Data),
	.RS2Data_o  (IDEX_RS2Data),

	.SignExtend_Res_i   (SignExtend_Res),
    .SignExtend_Res_o   (IDEX_SignExtend_Res),

	.funct_i    ({IFID_instr[31:25], IFID_instr[14:12]}),
	.funct_o    (IDEX_funct),

    .RDaddr_i   (IFID_instr[11:7]),
	.RDaddr_o   (IDEX_RDaddr),
    
    .RS1Addr_i  (IFID_instr[19:15]),
	.RS2Addr_i  (IFID_instr[24:20]),
	.RS1Addr_o  (IDEX_RS1Addr),
	.RS2Addr_o  (IDEX_RS2Addr),

    //Control Signal
	.RegWrite_i     (Ctrl_RegWrite),
	.MemtoReg_i     (Ctrl_MemtoReg),
	.MemRead_i      (Ctrl_MemRead),
	.MemWrite_i     (Ctrl_MemWrite),
	.ALUOp_i        (Ctrl_ALUOp),
	.ALUSrc_i       (Ctrl_ALUSrc),
	.RegWrite_o     (IDEX_RegWrite),
	.MemtoReg_o     (IDEX_MemtoReg),
	.MemRead_o      (IDEX_MemRead),
	.MemWrite_o     (IDEX_MemWrite),
	.ALUOp_o        (IDEX_ALUOp),
	.ALUSrc_o       (IDEX_ALUSrc)
);

Register_EXMEM Register_EXMEM (
    .clk_i                  (clk_i),
    .start_i                (start_i),

    .ALU_Res_i              (ALU_Res),
    .ALU_Res_o              (EXMEM_ALU_Res),

    .MemWrite_Data_i        (ForwardB_MUX_Res),
    .MemWrite_Data_o        (EXMEM_MemWrite_Data),

    .RDaddr_i               (IDEX_RDaddr),
    .RDaddr_o               (EXMEM_RDaddr),

	//Control Signal
    .RegWrite_i             (IDEX_RegWrite), 
    .MemtoReg_i             (IDEX_MemtoReg), 
    .MemRead_i              (IDEX_MemRead),  
    .MemWrite_i             (IDEX_MemWrite), 
    .RegWrite_o             (EXMEM_RegWrite), 
    .MemtoReg_o             (EXMEM_MemtoReg), 
    .MemRead_o              (EXMEM_MemRead),  
    .MemWrite_o             (EXMEM_MemWrite)
);

Register_MEMWB Register_MEMWB (
	.clk_i                  (clk_i), 
	.start_i                (start_i),

	.MemAddr_i              (EXMEM_ALU_Res),
	.MemRead_Data_i         (MemRead_Res),
	.RDaddr_i               (EXMEM_RDaddr),

	.MemAddr_o              (MEMWB_ALU_Res),
	.MemRead_Data_o         (MEMWB_MemRead_Data),
	.RDaddr_o               (MEMWB_RDaddr),

    //Control Signal
	.RegWrite_i             (EXMEM_RegWrite),
	.MemtoReg_i             (EXMEM_MemtoReg),
	.RegWrite_o             (MEMWB_RegWrite),
	.MemtoReg_o             (MEMWB_MemtoReg)
);

Forwarding_Unit Forwarding_Unit(
	.EX_RS1_i                (IDEX_RS1Addr),
	.EX_RS2_i                (IDEX_RS2Addr),
	.MEM_RegWrite_i          (EXMEM_RegWrite),
	.MEM_Rd_i                (EXMEM_RDaddr),
	.WB_RegWrite_i           (MEMWB_RegWrite),
	.WB_Rd_i                 (MEMWB_RDaddr),
	.Forward_A_o             (Forward_A),
	.Forward_B_o             (Forward_B)
);

MUX32_4i ForwardA_MUX(
	.Forward_in             (Forward_A),
	.EXRS_Data_in           (IDEX_RS1Data),
	.MEM_ALU_Res_in         (EXMEM_ALU_Res),
	.WB_WriteData_in        (MUX_MemtoReg_Res),
	.MUX_Res_o              (ForwardA_MUX_Res)
);

MUX32_4i ForwardB_MUX(
	.Forward_in             (Forward_B),
	.EXRS_Data_in           (IDEX_RS2Data),
	.MEM_ALU_Res_in         (EXMEM_ALU_Res),
	.WB_WriteData_in        (MUX_MemtoReg_Res),
	.MUX_Res_o              (ForwardB_MUX_Res)
);

Hazard_Detection Hazard_Detection(
    .RS1addr_i          (IFID_instr[19:15]),
    .RS2addr_i          (IFID_instr[24:20]),
    .MemRead_i          (IDEX_MemRead), 
    .RDaddr_i           (IDEX_RDaddr),
    .PCWrite_o          (PCWrite),
    .Stall_o            (Stall),
    .NoOp_o             (NoOp)
);

endmodule

