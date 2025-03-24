`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/27 19:39:46
// Design Name: 
// Module Name: LAB3_SIM
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


module LAB4_SIM();
    reg clk;
	reg rst;
	wire [1:0]pcsrc;//选择pc+4还是pc+offset
    //wire ALUsrc;//选择alu的num2来源
    //wire reg_src;//寄存器堆的读入选择控制
    //wire reg_write;//控制器的寄存器堆写信号
    wire zero;//alu的zero输出信号
	
	//wire [3:0]alucontrol;//alu操作信号
    //wire branch;//分支指令控制
    //wire clk_out;//输出的时钟分频信号
    wire cmp;//readdata1和readdata2的比较
    wire [4:0]rd_out;//ID_EX的rd输出，用于冒险判断
    wire hazard;//冒险检测模块的控制信号
    wire hazard_ld;
    wire mem_readE;//main_control寄存器写回数据控制
    wire [1:0]forwarda;
    wire [1:0]forwardb;
    wire IF_flash;
    wire [9:0]control_sign;
    wire [4:0]rs1_out;
    wire [4:0]rs2_out;
    wire [4:0]rd_outM;
    wire [4:0]rd_outW;
    wire reg_writeM;
    wire reg_writeW;
    wire [31:0]addr3;
	wire [31:0]pc;//pc计数器输入指令寄存器的地址
	wire [31:0]instr;//指令储存器输入的指令
	wire [31:0]pc_out;
	wire [31:0]instr_out;//IF_ID寄存器储存的指令
	wire mem_writeM;//datamemory的写使能
    wire mem_readM;//datamemory的读使能
	wire [31:0]rlt_outM;//alu的输出
	wire [31:0]B_out;//寄存器堆的数据输出
	
	wire [31:0]read_data;//datamemory的read_data返回的数据
	wire mem_read;
	wire mem_write;
	
	
	wire [31:0]data;
	wire [31:0]A;
	wire [31:0]B;
	wire [31:0]data_back;
	wire [31:0]mux3a;//A的三路选择器输出
    wire [31:0]mux3b;//B的三路选择器输出
    wire [31:0]num2;
    wire ALUsrcE;//ALU操作数控制
    wire [31:0]imm_out;
    wire [9:0]control_sign_m;//经过选择后的传入ID_EX控制信号
    wire [31:0]rd1;//寄存器堆输出的数据1
    wire [31:0]rd2;//寄存器堆输出的数据2
    wire reg_writeE;//main_control的寄存器写使能
    wire [1:0]reg_srcE;//main_control寄存器写回数据控制
    wire mem_writeE;//main_control数据寄存器写使能
    wire [3:0]alucontrolE;//ALU操作指令
    wire [1:0]reg_srcW;
    wire [31:0]aluout;//alu的输出
    wire [1:0]reg_srcM;
    wire [31:0]lwd;//保存数据寄存器读出的数据
    wire [31:0]rlt_outW;
    wire [2:0]immset;//立即数指令
    wire [2:0]immsetE;
    wire [31:0]addr2;
	wire [31:0]addr1;
	wire [31:0]sl_data;
	wire inst_ce;//指令寄存器的读控制信号
	wire branch;
	wire [2:0]funct;
	wire [2:0]functM;
	wire [2:0]functE;
	wire [2:0]funct_b;
	wire [31:0]pc_offset;
	
	wire [31:0]pc_4;
    wire [31:0]pc_imm;
    wire [31:0]pc_4E;
    wire [31:0]pc_immE;
    wire [31:0]pc_4M;
    wire [31:0]pc_immM;
    wire [31:0]pc_4W;
    wire [31:0]pc_immW;
	
	wire forwardc;
	wire [31:0]B_fw;
	wire [2:0]funct_b_E;
	wire hazard_D;
	wire jump_D;
	wire jump;
	wire btb_en;
	wire [31:0]pc_pre;
	wire [31:0]addr1_D;
	wire cache_hit;
	wire [31:0]read_data_p;
	wire hazard_ld_D;
	wire [31:0]pc_ID_4;
	wire IF_flash_D;
	top top(.clk(clk),.rst(rst),.rlt_outM(rlt_outM),.read_data(read_data),.mem_writeM(mem_writeM),.instr(instr));
	riscv riscv(.clk(clk),.rst(rst),.instr(instr),.pc(pc),.mem_writeM(mem_writeM),.mem_readM(mem_readM),.rlt_outM(rlt_outM),.B_out(B_out),.read_data(read_data),.inst_ce(inst_ce),.functM(functM),.cache_hit(cache_hit));
	controller controller(.instr(instr_out),.zero(zero),.pcsrc(pcsrc),.immset(immset),.IF_flash(IF_flash),.mem_write(mem_write),.mem_read(mem_read),.cmp(cmp),.control_sign(control_sign)
	                       ,.branch(branch),.functld(funct),.funct_b(funct_b),.jump(jump_D),.btb_en(btb_en)
	                       );
    new_pc new_pc(.clk(clk),.rst(rst),.addr(addr3),.inst_ce(inst_ce),.pc(pc),.hazard(hazard),.hazard_ld(hazard_ld));
    adder adder1(.a(pc),.b(32'h1),.y(addr1));//pc计数器的加法器
    adder adder4(.a(pc_out),.b(32'h1),.y(pc_4));//pc_ID+4,用于预测失败出现选择
    //adder adder2(.a(pc_out),.b(sl_data),.y(addr2));//偏移地址的输出
    //adder adder3(.a(pc_out),.b(data),.y(pc_offset));//jalr指令的偏移地址
    pc_offset_adder adder2(.pc_out(pc_out),.imm(sl_data),.rlt(addr2));//偏移地址的输出
    pc_offset_adder adder3(.pc_out(rd1),.imm(data),.rlt(pc_offset));//jalr指令的偏移地址
    pc_offset_adder adder5(.pc_out(pc_out),.imm(sl_data),.rlt(pc_imm));//auipc储存pc+imm
    //adder_off adder2(.a(pc_out),.b(sl_data),.y(addr2));//偏移地址的输出
    //mux2_1 m1(.addr1(addr1),.addr2(addr2),.opt(pcsrc),.addr3(addr3));//pc地址选择器
    //mux4_1 m1(.addr1(addr1),.addr2(addr2),.addr3(pc_offset),.pcsrc(pcsrc),.addr5(addr3));//pc地址选择器
    new_pc_mux4_1 m1(.pcsrc(pcsrc),.pc_pre(pc_pre),.pc_4(addr1),.pc_offset(addr2),.pc_offset_j(pc_offset),.btb_en(btb_en),.pc(addr3),.IF_flash(IF_flash)
                            ,.pc_4_D(pc_4),.IF_flash_D(IF_flash_D)
                            );//pc地址选择器
    btb_pre btb_pre(.pc(pc),.pc_out(pc_out),.pc_offset_j(pc_offset),.pc_offset(addr2),.pc_4(addr1),.pcsrc(pcsrc),.IF_flash(IF_flash),.jump(jump),.btb_en(btb_en),.pc_pre(pc_pre),.hazard_D(hazard_D)
                    ,.hazard_ld_D(hazard_ld_D),.IF_flash_D(IF_flash_D)
                    );
    sl2 sl1(.data(data),.sl_data(sl_data));
    mux3_1 m5(.a(A),.b(rlt_outM),.c(data_back),.op(forwarda),.d(mux3a));//A的三路选择器
    mux3_1 m6(.a(num2),.b(rlt_outM),.c(data_back),.op(forwardb),.d(mux3b));//B的三路选择器
    mux2_1 m2(.addr1(B),.addr2(imm_out),.opt(ALUsrcE),.addr3(num2));//alu数据来源第一个二选一选择器
    //mux2_1 m3(.addr2(lwd),.addr1(rlt_outW),.opt(reg_srcW),.addr3(data_back));//datamemory和aluout的写回选择
    mux2_1 m7(.addr1(B),.addr2(rlt_outM),.opt(forwardc),.addr3(B_fw));//sd数据前推
    mux4_1 m3(.addr1(rlt_outW),.addr2(lwd),.addr3(pc_immW),.addr4(pc_4W),.pcsrc(reg_srcW),.addr5(data_back));//datamemory和aluout的写回选择
    imm_gen imm_gen(.imm(instr_out),.immset(immset),.data(data));
    ALU alu(.num1(mux3a),.num2(mux3b),.alucontrol(alucontrolE),.zero(zero),.rlt(aluout));
    datapath datapath(.clk(clk),.rst(rst),.instr(instr),.immset(immset),.pcsrc(pcsrc),.control_sign(control_sign),.read_data(read_data),.forwarda(forwarda),.forwardb(forwardb),.instr_out(instr_out)
                      ,.inst_ce(inst_ce),.zero(zero),.pc(pc),.cmp(cmp),.hazard(hazard),.IF_flash(IF_flash),.rd_out(rd_out),.rd_outM(rd_outM),.rd_outW(rd_outW),.reg_writeM(reg_writeM)
                      ,.reg_writeW(reg_writeW),.rs1_out(rs1_out),.rs2_out(rs2_out),.mem_readE(mem_readE),.rlt_outM(rlt_outM),.B_out(B_out),.mem_writeM(mem_writeM),.mem_readM(mem_readM)
                      ,.funct(funct),.functM(functM),.funct_b(funct_b),.immsetE(immsetE),.mem_writeE(mem_writeE),.forwardc(forwardc),.ALUsrcE(ALUsrcE)
                      ,.btb_en(btb_en),.jump_D(jump_D),.hazard_ld(hazard_ld)
                      );
    IF_ID IF_ID(.clk(clk),.rst(rst),.hazard(hazard),.IF_flash(IF_flash),.instr(instr),.pc(pc),.pc_out(pc_out),.instr_out(instr_out),.jump_D(jump_D),.jump(jump),.hazard_D(hazard_D),.addr1(addr1),.addr1_D(addr1_D)
                    ,.hazard_ld(hazard_ld),.hazard_ld_D(hazard_ld_D),.IF_flash_D(IF_flash_D)
                    );  
    mux2_1_control m4(.a(control_sign),.b(10'b0),.op(hazard),.c(control_sign_m));//用于插入空控制信号的二选一选择器
    regfile regfile(.clk(clk),.we3(reg_writeW),.ra1(instr_out[19:15]),.ra2(instr_out[24:20]),.wa3(rd_outW),.wd3(data_back),.rd1(rd1),.rd2(rd2));
    ID_EX ID_EX(.clk(clk),.rst(rst),.control_sign(control_sign_m),.rd1(rd1),.rd2(rd2),.imm(data),.rd(instr_out[11:7]),.rs1(instr_out[19:15]),.rs2(instr_out[24:20]),.reg_writeE(reg_writeE),.reg_srcE(reg_srcE)
                ,.mem_readE(mem_readE),.mem_writeE(mem_writeE),.alucontrolE(alucontrolE),.ALUsrcE(ALUsrcE),.A(A),.B(B),.imm_out(imm_out),.rs1_out(rs1_out),.rs2_out(rs2_out),.rd_out(rd_out)
                ,.funct(funct),.functE(functE),.pc_4(addr1_D),.pc_imm(pc_imm),.pc_4E(pc_4E),.pc_immE(pc_immE),.immset(immset),.immsetE(immsetE),.funct_b(funct_b),.funct_b_E(funct_b_E),.hazard(hazard)
                ,.hazard_ld(hazard_ld)
                );
    EX_MEM EX_MEM(.clk(clk),.rst(rst),.reg_writeE(reg_writeE),.reg_srcE(reg_srcE),.mem_readE(mem_readE),.mem_writeE(mem_writeE),.rlt(aluout),.B(B_fw),.rd_out(rd_out),.reg_writeM(reg_writeM)
                ,.reg_srcM(reg_srcM),.mem_readM(mem_readM),.mem_writeM(mem_writeM),.rlt_outM(rlt_outM),.B_out(B_out),.rd_outM(rd_outM)
                ,.functE(functE),.functM(functM),.pc_4E(pc_4E),.pc_immE(pc_immE),.pc_4M(pc_4M),.pc_immM(pc_immM),.hazard_ld(hazard_ld)
                );
    MEM_WB MEM_WB(.clk(clk),.rst(rst),.reg_writeM(reg_writeM),.reg_srcM(reg_srcM),.read_data(read_data_p),.rlt_outM(rlt_outM),.rd_outM(rd_outM),.reg_writeW(reg_writeW),.reg_srcW(reg_srcW),.lwd(lwd)
                ,.rd_outW(rd_outW),.rlt_outW(rlt_outW),.pc_4M(pc_4M),.pc_immM(pc_immM),.pc_4W(pc_4W),.pc_immW(pc_immW),.hazard_ld(hazard_ld)
                );
    Hazard_detecting h1(.cmp(cmp),.rd_out(rd_out),.instr_out(instr_out),.mem_readE(mem_readE),.hazard(hazard),.funct_b(funct_b),.branch(branch),.clk(clk),.hazard_ld(hazard_ld),.cache_hit(cache_hit)
                        ,.mem_readM(mem_readM),.rd_outM(rd_outM)
                        );
    Foward_detecting f1(.rs1_out(rs1_out),.rs2_out(rs2_out),.rd_outM(rd_outM),.rd_outW(rd_outW),.reg_writeM(reg_writeM),.reg_writeW(reg_writeW),.forwarda(forwarda),.forwardb(forwardb),.immsetE(immsetE)
                ,.mem_writeE(mem_writeE),.forwardc(forwardc),.ALUsrcE(ALUsrcE)
                );
    //data_memory data_memory(.clka(clk),.wea(mem_writeM),.ena(mem_readM),.addra(rlt_outM),.dina(B_out),.functM(functM),.douta(read_data));
    d_cache d_cache(.rst(rst),.clka(clk),.wea(mem_writeM),.ena(mem_readM),.addra(rlt_outM),.dina(B_out),.douta(read_data),.ohit(cache_hit));
    data_process data_process(.dina(read_data),.functM(functM),.douta(read_data_p));
    /*
	top dut(.clk(clk),.rst(rst),.aluout(aluout),.read_data(read_data),.mem_write(mem_write),.instr(instr));
	riscv riscv(.clk(clk),.rst(rst),.instr(instr),.pc(pc),.mem_write(mem_write),.mem_read(mem_read),.aluout(aluout),.rs2(rs2),.read_data(read_data),.inst_ce(inst_ce));
    new_pc pc1(.clk(clk_out),.rst(rst),.pc(pc),.addr(addr),.inst_ce(inst_ce));
    //clk_div clk_div(.clk(clk),.rst(rst),.clk_out(clk_out));
    //riscv riscv(.clk(clk),.rst(rst),.instr(instr),.pc(pc),.mem_write(mem_write),
     //   .mem_read(mem_read),.aluout(aluout),.rs2(rs2),.data_back(read_data),.inst_ce(inst_ce));
    blk_mem_gen_0 instr_mem(.clka(clk),.ena(inst_ce),.addra(pc),.douta(instr));//指令寄存器
	blk_mem_gen_1 data_mem(.clka(clk),.ena(mem_read),.wea(mem_write),
	    .addra(aluout),.dina(rs2),.douta(read_data));//datamemory寄存器
	regfile regfile(.clk(clk),.we3(reg_write),.ra1(instr[19:15]),.ra2(instr[24:20]),.wa3(instr[11:7]),.wd3(data_back),.rd1(rs1),.rd2(rs2));
	controller controller(.instr(instr),.zero(zero),.pcsrc(pcsrc),.immset(immset),.reg_write(reg_write),.ALUsrc(ALUsrc),.mem_write(mem_write),.mem_read(mem_read),
                     .reg_src(reg_src),.branch(branch),.alucontrol(alucontrol));
    datapath datapath(.clk(clk),.clk_out(clk_out),.rst(rst),.instr(instr),.immset(immset),.pcsrc(pcsrc),.ALUsrc(ALUsrc),.reg_src(reg_src),.reg_write(reg_write),.alucontrol(alucontrol),
                      .read_data(read_data),.inst_ce(inst_ce),.zero(zero),.aluout(aluout),.rs2(rs2),.pc(pc));
                      
    imm_gen imm_gen(.imm(instr),.immset(immset),.data(data));
    mux2_1 m2(.addr1(rs2),.addr2(data),.opt(ALUsrc),.addr3(num2));//alu数据来源选择器
    ALU alu(.num1(rs1),.num2(num2),.alucontrol(alucontrol),.zero(zero),.rlt(aluout));
    mux2_1 m1(.addr1(addr1),.addr2(addr2),.opt(pcsrc),.addr3(addr));//pc地址选择器
    adder adder1(.a(pc),.b(32'h1),.y(addr1));//pc计数器的加法器
    adder adder2(.a(pc),.b(sl_data),.y(addr2));//偏移地址的输出
    sl2 sl1(.data(data),.sl_data(sl_data));
    mux2_1 m3(.addr2(read_data),.addr1(aluout),.opt(reg_src),.addr3(data_back));//datamemory和aluout的写回选择
    */
	initial begin 
	    clk = 1;
		rst = 1;
		#20;
		rst = 0;
		//instr=32'h00000213;
	end
    always #5 clk=~clk;
    
	always @(negedge clk) begin
		#10 $display("mem_write: %b, aluout: %b, read_data: %b, instr: %b",top.mem_writeM, rlt_outM,read_data,instr);
	end
	
endmodule
