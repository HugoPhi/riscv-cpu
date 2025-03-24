`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/20 22:55:51
// Design Name: 
// Module Name: datapath
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

//
module datapath(
    input clk,
    //input clk_out,//pc的时钟信号
    input rst,
    input hazard,//冒险检测模块的冒险信号
    input IF_flash,//数据冲刷信号
    input [31:0]instr,//指令寄存器输出的指令
    input [2:0]immset,//控制器的立即数操作指令输出
    input [1:0]pcsrc,//选择pc+4还是pc+offset
    //input ALUsrc,//选择alu的num2来源
    //input reg_src,//寄存器堆的读入选择控制
    //input reg_write,//控制器的寄存器堆写信号
    input [9:0]control_sign,//main_control的控制信号序列化之后传入
    //input [3:0]alucontrol,//alu的控制信号
    input [31:0]read_data,//datamemory读出的数据
    input [1:0]forwarda,//控制ID_EX的A，决定ALU的第一个输入
    input [1:0]forwardb,//控制ID_EX的B，决定ALU的第二个输入
    output inst_ce,//指令寄存器的读控制信号
    output zero,//alu的zero输出信号
    output [31:0]pc,//pc当前执行的指令地址
    output cmp,//readdata1和readdata2的比较
    output [31:0]instr_out,//IF_ID的IR输出
    output [4:0]rd_out,//ID_EX的rd输出，用于冒险判断
    output [4:0]rs1_out,//ID_EX的读取寄存器堆中的第一个地址
    output [4:0]rs2_out,//ID_EX的读取寄存器堆中的第二个地址
    output mem_readE,//main_control寄存器写回数据控制
    output [4:0]rd_outM,//EX_MEM的写回寄存器堆地址
    output [4:0]rd_outW,//MEM_WB的写回寄存器堆地址
    output [31:0]rlt_outM,//EX_MEM储存alu的计算结果
    output [31:0]B_out,//EX_MEM储存ID_EX的B的数据
    output mem_writeM,//EX_MEM的data寄存器写使能
    output mem_readM,//EX_MEM的data寄存器读使能
    output reg_writeM,//EX_MEM的寄存器堆写使能
    output reg_writeW,//MEM_WB的寄存器堆写使能
    
    output btb_en,
    output jump_D,
    
    input [2:0]funct,
    output [2:0]functM,
    input [2:0]funct_b,
    output [2:0]immsetE,
    input forwardc,
    output mem_writeE,
    output ALUsrcE,
    input hazard_ld
    );
    wire [2:0]functE;
    //wire [31:0]pc;//pc当前执行的指令地址
    wire [31:0]addr1;//pc+4
    wire [31:0]addr2;//pc+offset
    wire [31:0]addr3;//地址mux2_1的输出，输入到pc
    wire [31:0]data;//立即数扩展输出
    wire [31:0]sl_data;//sl模块左移输出
    wire [31:0]num2;//alusrc二选一模块输出
    wire [31:0]rd1;//寄存器堆输出的数据1
    wire [31:0]rd2;//寄存器堆输出的数据2
    wire [31:0]data_back;//数据返回选择器选择的wb数据
    wire [31:0]pc_out;//IF_ID保存的pc
    wire reg_writeE;//main_control的寄存器写使能
    wire [1:0]reg_srcE;//main_control寄存器写回数据控制
    //wire mem_readE;//main_control寄存器写回数据控制
    //wire mem_writeE;//main_control数据寄存器写使能
    wire branchE;//main_control分支指令控制
    wire [3:0]alucontrolE;//ALU操作指令
    //wire ALUsrcE;//ALU操作数控制
    wire [9:0]control_sign_m;//经过选择后的传入ID_EX控制信号
    wire [31:0]A;
    wire [31:0]B;
    wire [31:0]imm_out;
    //wire [4:0]rd_out;
    //wire reg_writeM;
    wire [1:0]reg_srcM;
    //wire mem_readM;
    //wire mem_writeM;
    wire branchM;
    //wire reg_writeW;
    wire [1:0]reg_srcW;
    wire [31:0]lwd;//保存数据寄存器读出的数据
    wire [31:0]rlt_outW;
    wire [31:0]mux3a;//A的三路选择器输出
    wire [31:0]mux3b;//B的三路选择器输出
    wire [31:0]aluout;//alu的输出
    wire [31:0]pc_offset;//jalr的pc偏移地址
    //wire [2:0]funct_b;//b指令的前推种类
    wire [31:0]pc_4;
    wire [31:0]pc_imm;
    wire [31:0]pc_4E;
    wire [31:0]pc_immE;
    wire [31:0]pc_4M;
    wire [31:0]pc_immM;
    wire [31:0]pc_4W;
    wire [31:0]pc_immW;
    //wire [2:0]immsetE;
    wire [31:0]B_fw;//前推sd后的B_out
    wire [2:0]funct_b_E;
    wire [31:0]pc_pre;
    wire jump;
    wire hazard_D;
    wire [31:0]addr1_D;
    wire [31:0]read_data_p;
    wire hazard_ld_D;
    wire [31:0]pc_4_D;
    wire IF_flash_D;
    //wire [31:0]read_data_M;
    //实例化模块
    new_pc new_pc(.clk(clk),.rst(rst),.addr(addr3),.inst_ce(inst_ce),.pc(pc),.hazard(hazard),.hazard_ld(hazard_ld));
    regfile regfile(.clk(clk),.we3(reg_writeW),.ra1(instr_out[19:15]),.ra2(instr_out[24:20]),.wa3(rd_outW),.wd3(data_back),.rd1(rd1),.rd2(rd2));
    imm_gen imm_gen(.imm(instr_out),.immset(immset),.data(data));
    ALU alu(.num1(mux3a),.num2(mux3b),.alucontrol(alucontrolE),.zero(zero),.rlt(aluout));
    sl2 sl1(.data(data),.sl_data(sl_data));
    adder adder1(.a(pc),.b(32'h1),.y(addr1));//pc计数器的加法器pc+4
    //adder adder6(.a(pc_out),.b(32'h1),.y(pc_ID_4));//pc_ID+4,用于预测失败出现选择
    pc_offset_adder adder2(.pc_out(pc_out),.imm(sl_data),.rlt(addr2));//偏移地址的输出pc+offset
    pc_offset_adder adder3(.pc_out(rd1),.imm(data),.rlt(pc_offset));//jalr指令的偏移地址rs1+imm
    pc_offset_adder adder5(.pc_out(pc_out),.imm(data),.rlt(pc_imm));//auipc储存pc+imm
    //adder adder2(.a(pc_out),.b(sl_data),.y(addr2));//偏移地址的输出
    //adder adder3(.a(pc_out),.b(data),.y(pc_offset));//jalr指令的偏移地址
    adder adder4(.a(pc_out),.b(32'h1),.y(pc_4));//jal/jalr储存pc+4
    //adder adder5(.a(pc_out),.b(rd1),.y(pc_imm));//auipc储存pc+imm
    //adder_off adder2(.a(pc_out),.b(sl_data),.y(addr2));//偏移地址的输出
    //mux2_1 m1(.addr1(addr1),.addr2(addr2),.opt(pcsrc),.addr3(addr3));//pc地址选择器
    //mux4_1 m1(.addr1(addr1),.addr2(addr2),.addr3(pc_offset),.pcsrc(pcsrc),.addr5(addr3));//pc地址选择器
    new_pc_mux4_1 m1(.pcsrc(pcsrc),.pc_pre(pc_pre),.pc_4(addr1),.pc_offset(addr2),.pc_offset_j(pc_offset),.btb_en(btb_en),.pc(addr3),.IF_flash(IF_flash)
                    ,.pc_4_D(pc_4),.IF_flash_D(IF_flash_D)
                    );//pc地址选择器
    btb_pre btb_pre(.pc(pc),.pc_out(pc_out),.pc_offset_j(pc_offset),.pc_offset(addr2),.pc_4(addr1),.pcsrc(pcsrc),.IF_flash(IF_flash),.jump(jump),.btb_en(btb_en),.pc_pre(pc_pre),.hazard_D(hazard_D),.hazard_ld_D(hazard_ld_D)
                    ,.IF_flash_D(IF_flash_D)
                    );
    mux2_1 m2(.addr1(B),.addr2(imm_out),.opt(ALUsrcE),.addr3(num2));//alu数据来源第一个二选一选择器
    //mux2_1 m3(.addr2(lwd),.addr1(rlt_outW),.opt(reg_srcW),.addr3(data_back));//datamemory和aluout的写回选择
    mux4_1 m3(.addr1(rlt_outW),.addr2(lwd),.addr3(pc_immW),.addr4(pc_4W),.pcsrc(reg_srcW),.addr5(data_back));//datamemory和aluout的写回选择
    mux2_1_control m4(.a(control_sign),.b(10'b0),.op(hazard),.c(control_sign_m));//用于插入空控制信号的二选一选择器
    compare compare(.rd1(rd1),.rd2(rd2),.cmp(cmp),.funct_b(funct_b));//比较寄存器堆取出数据进行数据冒险判断
    mux3_1 m5(.a(A),.b(rlt_outM),.c(data_back),.op(forwarda),.d(mux3a));//A的三路选择器
    mux3_1 m6(.a(num2),.b(rlt_outM),.c(data_back),.op(forwardb),.d(mux3b));//B的三路选择器
    mux2_1 m7(.addr1(B),.addr2(rlt_outM),.opt(forwardc),.addr3(B_fw));
    //data_memory data_memory(.dina(read_data),.functM(functM),.douta(read_data_M));
    data_process data_process(.dina(read_data),.functM(functM),.douta(read_data_p));
    //实例化寄存器
    IF_ID IF_ID(.clk(clk),.rst(rst),.hazard(hazard),.IF_flash(IF_flash),.instr(instr),.pc(pc),.pc_out(pc_out),.instr_out(instr_out),.jump(jump),.jump_D(jump_D),.hazard_D(hazard_D),.addr1(addr1),.addr1_D(addr1_D)
                ,.hazard_ld(hazard_ld),.hazard_ld_D(hazard_ld_D),.IF_flash_D(IF_flash_D)
                );
    ID_EX ID_EX(.clk(clk),.rst(rst),.control_sign(control_sign_m),.rd1(rd1),.rd2(rd2),.imm(data),.rd(instr_out[11:7]),.rs1(instr_out[19:15]),.rs2(instr_out[24:20]),.reg_writeE(reg_writeE),.reg_srcE(reg_srcE)
                ,.mem_readE(mem_readE),.mem_writeE(mem_writeE),.alucontrolE(alucontrolE),.ALUsrcE(ALUsrcE),.A(A),.B(B),.imm_out(imm_out),.rs1_out(rs1_out),.rs2_out(rs2_out),.rd_out(rd_out)
                ,.funct(funct),.functE(functE),.pc_4(pc_4),.pc_imm(pc_imm),.pc_4E(pc_4E),.pc_immE(pc_immE),.immset(immset),.immsetE(immsetE),.funct_b(funct_b),.funct_b_E(funct_b_E),.hazard(hazard)
                ,.hazard_ld(hazard_ld)
                );
    EX_MEM EX_MEM(.clk(clk),.rst(rst),.reg_writeE(reg_writeE),.reg_srcE(reg_srcE),.mem_readE(mem_readE),.mem_writeE(mem_writeE),.rlt(aluout),.B(B_fw),.rd_out(rd_out),.reg_writeM(reg_writeM)
                ,.reg_srcM(reg_srcM),.mem_readM(mem_readM),.mem_writeM(mem_writeM),.rlt_outM(rlt_outM),.B_out(B_out),.rd_outM(rd_outM)
                ,.functE(functE),.functM(functM),.pc_4E(pc_4E),.pc_immE(pc_immE),.pc_4M(pc_4M),.pc_immM(pc_immM)
                ,.hazard_ld(hazard_ld)
                );
    MEM_WB MEM_WB(.clk(clk),.rst(rst),.reg_writeM(reg_writeM),.reg_srcM(reg_srcM),.read_data(read_data_p),.rlt_outM(rlt_outM),.rd_outM(rd_outM),.reg_writeW(reg_writeW),.reg_srcW(reg_srcW),.lwd(lwd)
                ,.rd_outW(rd_outW),.rlt_outW(rlt_outW),.pc_4M(pc_4M),.pc_immM(pc_immM),.pc_4W(pc_4W),.pc_immW(pc_immW)
                ,.hazard_ld(hazard_ld)
                );
    
endmodule
