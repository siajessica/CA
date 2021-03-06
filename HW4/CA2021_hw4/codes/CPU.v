`include "Adder.v"
`include "ALU_Control.v"
`include "ALU.v"
`include "Control.v"
`include "MUX32.v"
`include "Sign_Extend.v"
`include "Registers.v"
`include "Instruction_Memory.v"
`include "PC.v"

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
wire    [31:0]  PC_now, PC_next;
wire    [31:0]  instr;

//Register
wire    [31:0]  RS1data, RS2data;

//Sign_Extend
wire    [31:0]  SignExtend_Res;

//MUX32
wire    [31:0]  MUX_Res;

//ALU
wire    [31:0]  ALU_Res;

//ALU_Control
wire     [2:0]  ALUCtrl;
wire            zero;

//Control
wire     [1:0]  ALUOp;
wire            RegWrite, ALUSrc;

Control Control(
    .Op_i       (instr[6:0]),
    .ALUOp_o    (ALUOp),
    .ALUSrc_o   (ALUSrc),
    .RegWrite_o (RegWrite)
);

Adder Add_PC(
    .data1_in   (PC_now),
    .data2_in   (32'd4),
    .data_o     (PC_next)
);

PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .pc_i       (PC_next),
    .pc_o       (PC_now)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (PC_now), 
    .instr_o    (instr)
);

Registers Registers(
    .clk_i          (clk_i),
    .RS1addr_i      (instr[19:15]),
    .RS2addr_i      (instr[24:20]),
    .RDaddr_i       (instr[11:7]), 
    .RDdata_i       (ALU_Res),
    .RegWrite_i     (RegWrite), 
    .RS1data_o      (RS1data), 
    .RS2data_o      (RS2data) 
);


MUX32 MUX_ALUSrc(
    .data1_i    (RS2data),
    .data2_i    (SignExtend_Res),
    .select_i   (ALUSrc),
    .data_o     (MUX_Res)
);


Sign_Extend Sign_Extend(
    .data_i     (instr[31:20]),
    .data_o     (SignExtend_Res)
);
  
ALU ALU(
    .data1_i    (RS1data),
    .data2_i    (MUX_Res),
    .ALUCtrl_i  (ALUCtrl),
    .data_o     (ALU_Res),
    .Zero_o     (zero)
);

ALU_Control ALU_Control(
    .funct_i    ({instr[31:25], instr[14:12]}),
    .ALUOp_i    (ALUOp),
    .ALUCtrl_o  (ALUCtrl)
);

endmodule

