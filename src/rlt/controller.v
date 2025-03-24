`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/13 19:50:57
// Design Name: 
// Module Name: controller
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


module controller(
    input [31:0]instr,//指令传入
    input zero,//ALU的zero输入
    input cmp,//readdata1和readdata2的比较
    output wire [1:0]pcsrc,//地址选择器控制
    output wire [2:0]immset,//立即数操作指令
    //output wire reg_write,//寄存器堆写使能
    output wire mem_write,//datamemory数据寄存器写使能
    //output wire reg_src,//寄存器写回数据控制
    output wire mem_read,//datamemoty数据寄存器读使能
    output wire branch,//分支指令控制?
    //output wire [3:0]alucontrol,//输出的alu控制信号
    output wire IF_flash,//冲刷指令
    //output wire ALUsrc//ALU操作数控制
    output wire [9:0]control_sign,//传给ID_EX的控制信号
    output reg [2:0]functld,
    output reg [2:0]funct_b,
    input btb_en,//分支预测使能
    input jump
    //input cache_miss,//cache的命中信号
    //output wire hazard_ld//cachemiss时阻塞
    );
    //wire branch;//分支指令控制?
    wire [3:0]alucontrol;//输出的alu控制信号
    wire reg_write;//寄存器堆写使能
    wire [1:0]reg_src;//寄存器写回数据控制
    wire ALUsrc;//ALU操作数控制
    wire [1:0]aluop;//alu操作指令
    wire [6:0]opcode;//七位opcode
    reg [3:0]funct;//四位操作码
    reg [1:0]jflag;//判断是否为无条件跳转
    assign opcode=instr[6:0];
    //assign hazard_ld=(cache_miss&&opcode==7'b000_0011)?1'b1:1'b0;
    always@(*)begin
        case(opcode)//获得opcode
            7'b110_1111:begin//jal
                functld<=3'b0;
                funct<=4'b0;
                funct_b<=3'b010;
                jflag<=2'b10;
            end
            7'b110_0111:begin//jalr
                funct<={instr[30],instr[14:12]};
                functld<=3'b0;
                funct_b<=3'b010;
                jflag<=2'b01;
            end
            7'b001_0111:begin//auipc
                funct<={instr[30],instr[14:12]};
                functld<=3'b0;
                funct_b<=3'b0;
                jflag<=2'b0;
            end
            7'b011_0011:begin//r
                if(instr[14:12]==3'b010)begin
                    funct<={instr[25],instr[14:12]};
                end else begin
                    funct<={instr[30],instr[14:12]};
                end
                functld<=3'b0;
                funct_b<=3'b0;
                jflag<=2'b0;
            end
            7'b001_0011:begin//i
                if(instr[14:12]==3'b101)begin
                    funct<={instr[30],instr[14:12]};
                end
                else begin
                    funct<={1'b0,instr[14:12]};
                end
                functld<=3'b0;
                funct_b<=3'b0;
                jflag<=2'b0;
            end
            7'b000_0011:begin//ld
                funct<={1'b0,instr[14:12]};
                functld<=instr[14:12];
                funct_b<=3'b0;
                jflag<=2'b0;
            end
            7'b010_0011:begin//sd
                funct<=4'b0000;
                functld<=3'b0;
                funct_b<=3'b0;
                jflag<=2'b0;
            end
            7'b110_0011:begin//b
                funct<={instr[30],instr[14:12]};
                functld<=3'b0;
                funct_b<=instr[14:12];
                jflag<=2'b0;
            end
            default:begin
                funct<={1'b0,instr[14:12]};
                functld<=3'b0;
                funct_b<=3'b0;
                jflag<=2'b0;
            end
        endcase
//        //实现指令冲刷判断?
//        if(pcsrc!=2'b00)begin
//           IF_flash=1'b1;
//        end
//        else begin
//            IF_flash=1'b0;
//        end

//        if(branch&&(cmp^jflag[1]))begin
//            pcsrc<=2'b01;
//        end else if(branch&&jflag[0])begin
//            pcsrc<=2'b10;
//        end else begin
//            pcsrc<=2'b00;
//        end
    end
    assign pcsrc=(branch&&(cmp^jflag[1]))? 2'b01:((branch&&jflag[0])?2'b10 :2'b00 );
    //控制alu_control,main_control,指令跳转选择模块
    main_control main_control(.opcode(opcode),.aluop(aluop),.immset(immset)
                                ,.reg_write(reg_write),.ALUsrc(ALUsrc)
                                ,.mem_write(mem_write),.reg_src(reg_src)
                                ,.mem_read(mem_read),.branch(branch),.funct(funct));
    alu_control alu_control(.funct(funct),.aluop(aluop),.alucontrol(alucontrol));
    //其他控制信号实现
    assign control_sign={reg_write,reg_src,mem_read,mem_write,alucontrol,ALUsrc};
    //assign IF_flash=(pcsrc==2'b00)?1'b0:1'b1;
    assign IF_flash=((((~jump)&&(~pcsrc[1])&&pcsrc[0])||((~jump)&&(~pcsrc[0])&&pcsrc[1])||
                        (jump&&(~pcsrc[1])&&(~pcsrc[0])))&&(branch))?1'b1:1'b0;
endmodule