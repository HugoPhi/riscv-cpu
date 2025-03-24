`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/11 17:06:34
// Design Name: 
// Module Name: ID_EX
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ID_EX(
    input clk,
    input rst,
    input [9:0]control_sign,//main_control的控制信号序列化之后传入
    input [31:0]rd1,//寄存器堆的rd1
    input [31:0]rd2,//寄存器堆的rd2
    input [31:0]imm,//imm_gen的输出
    input [4:0]rd,//IF_ID的写入寄存器地址输出
    //input IF_flash,//指令冲刷信号
    input [2:0]funct_b,
    output reg [2:0]funct_b_E,
    output reg reg_writeE,//main_control的寄存器写使能
    output reg [1:0]reg_srcE,//main_control寄存器写回数据控制
    output reg mem_readE,//main_control寄存器写回数据控制
    output reg mem_writeE,//main_control数据寄存器写使能
    //output reg branchE,//main_control分支指令控制
    output reg [3:0]alucontrolE,//ALU操作指令
    output reg ALUsrcE,//ALU操作数控制
    input [4:0]rs1,//寄存器堆的rs1地址
    input [4:0]rs2,//寄存器堆的rs2地址
    output reg [31:0]A,
    output reg [31:0]B,
    output reg [31:0]imm_out,
    output reg [4:0]rs1_out,
    output reg [4:0]rs2_out,
    output reg [4:0]rd_out,
    input [2:0]funct,
    output reg [2:0]functE,
    input [31:0]pc_4,
    input [31:0]pc_imm,
    output reg [31:0]pc_4E,
    output reg [31:0]pc_immE,
    input [2:0]immset,
    output reg [2:0]immsetE,
    input hazard,
    input hazard_ld
    );
    always@(posedge clk)begin
        if(rst||hazard)begin
            reg_writeE<=1'b0;
            reg_srcE<=2'b0;
            mem_readE<=1'b0;
            mem_writeE<=1'b0;
            //branchE<=1'b0;
            alucontrolE<=4'b0;
            ALUsrcE<=1'b0;
            A<=32'b0;
            B<=32'b0;
            imm_out<=32'b0;
            rs1_out<=5'b0;
            rs2_out<=5'b0;
            rd_out<=5'b0;
            functE<=3'b0;
            pc_4E<=32'b0;
            pc_immE<=32'b0;
            immsetE<=3'b0;
            funct_b_E<=3'b0;
        end
        else if(hazard_ld)begin
            reg_writeE<=reg_writeE;
            reg_srcE<=reg_srcE;
            mem_readE<=mem_readE;
            mem_writeE<=mem_writeE;
            //branchE<=1'b0;
            alucontrolE<=alucontrolE;
            ALUsrcE<=ALUsrcE;
            A<=A;
            B<=B;
            imm_out<=imm_out;
            rs1_out<=rs1_out;
            rs2_out<=rs2_out;
            rd_out<=rd_out;
            functE<=functE;
            pc_4E<=pc_4E;
            pc_immE<=pc_immE;
            immsetE<=immsetE;
            funct_b_E<=funct_b_E;
        end
        else begin
            A<=rd1;
            B<=rd2;
            rd_out<=rd;
            rs1_out<=rs1;
            rs2_out<=rs2;
            imm_out<=imm;
            reg_writeE<=control_sign[9];
            reg_srcE<=control_sign[8:7];
            mem_readE<=control_sign[6];
            mem_writeE<=control_sign[5];
            //branchE<=control_sign[5];
            alucontrolE<=control_sign[4:1];
            ALUsrcE<=control_sign[0];
            functE<=funct;
            pc_4E<=pc_4;
            pc_immE<=pc_imm;
            immsetE<=immset;
            funct_b_E<=funct_b;
        end
    end
endmodule
