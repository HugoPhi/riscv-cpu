`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/20 20:56:27
// Design Name: 
// Module Name: top
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


module top(
	input clk,
	input rst,
	output [31:0]read_data,//datamemory的读出的数据
	output [31:0]rlt_outM,//alu的输出结果
	output mem_writeM,//控制器的datamemory写使能
	output [31:0]instr//执行的指令
    );
	//wire mem_write;//控制器的datamemory写使能
	wire mem_readM;//控制器的datamemory读使能
	wire [31:0]pc;//pc当前执行的指令地址
	//wire [31:0]instr;//执行的指令
	wire [31:0]B_out;//寄存器堆读出的数据
	//wire branch;
   	//wire [31:0]aluout;//alu的输出结果
   	//wire [31:0]read_data;//datamemory的读出的数据
   	wire inst_ce;//指令寄存器的读控制信号
   	wire [2:0]functM;//EX_MEM寄存器储存的ld种类funct
   	wire [31:0]data_buff;
   	wire cache_hit;//cache发出的信号
   	//时钟分频
   	
   	//wire clk_out;//输出的时钟分频信号
   	//实例化模块
   	//clk_div(.rst(rst),.clk(clk),.clk_out(clk_out));
	riscv riscv(.clk(clk),.rst(rst),.instr(instr),.pc(pc),.mem_writeM(mem_writeM),.mem_readM(mem_readM),.rlt_outM(rlt_outM),.B_out(B_out),.read_data(read_data),.inst_ce(inst_ce),.functM(functM)
	           ,.cache_hit(cache_hit)
	           );
	//blk_mem_gen_2 instr_mem(.clka(clk),.ena(inst_ce),.addra(pc),.douta(instr));//指令寄存器
	instr_memory instr_mem(.clka(clk),.ena(inst_ce),.addra(pc),.douta(instr));//指令寄存器
	//dcache dcache();
	//blk_mem_gen_2 data_mem(.clka(clk),.ena(mem_readM),.wea(mem_writeM),.addra(rlt_outM),.dina(B_out),.douta(read_data));//dmem主存
	d_cache d_cache(.rst(rst),.clka(clk),.wea(mem_writeM),.ena(mem_readM),.addra(rlt_outM),.dina(B_out),.douta(read_data),.ohit(cache_hit));
	//data_memory data_memory(.clka(clk),.wea(mem_writeM),.ena(mem_readM),.addra(rlt_outM),.dina(B_out),.functM(functM),.douta(read_data));
endmodule
