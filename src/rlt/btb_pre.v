`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/04 10:34:45
// Design Name: 
// Module Name: btb_pre
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


module btb_pre(
    input [31:0]pc,//IF阶段的pc用于预测
    input [31:0]pc_out,//ID阶段指令的pc,用于保存
    input [31:0]pc_offset_j,//ID阶段jalr计算的偏移地址，用于保存
    input [31:0]pc_offset,//b指令偏移地址，用于保存
    input [31:0]pc_4,//pc+4
    input [1:0]pcsrc,//判断ID阶段指令是否跳转
    input IF_flash,//判断是否预测正确
    output reg jump,//预测指令是否跳转
    output reg btb_en,//是否预测使能
    output reg [31:0]pc_pre,//预测的32位地址
    input hazard_D,
    input hazard_ld_D,
    input IF_flash_D
    );
    reg IF_flash_buff;
    reg [31:0] btb_rf[127:0];//btb跳转表，用于查找pc
    reg [1:0] btb_flag[127:0];//btb状态表，用于决定跳转状态
    reg flag1,flag2,flag3;
    wire [1:0]pcsrc_buff;
    reg [31:0]pc_buff;//保存当前阶段pc
    wire [31:0]btb_rf_buff;
    wire [1:0]btb_flag_buff;
    integer i;
    assign pcsrc_buff=pcsrc;
    initial begin
        for(i=7'b0;i<=11'b11111_11;i=i+1)begin
            btb_rf[i]<=32'b11111111_11111111_11111111_11111111;
            btb_flag[i]<=2'b11;
        end
    end
    always@(pc)begin
        //未命中
        if(~btb_rf[pc]==32'b0)begin
            pc_pre<=32'b0;
            btb_en<=1'b0;
            jump<=1'b0;
        end
        //命中 
        else begin
            btb_en<=1'b1;
            if(btb_flag[pc][1])begin
                pc_pre<=btb_rf[pc];
                jump<=1'b1;
            end else begin
                pc_pre<=pc+32'b1;
                jump<=1'b0;
            end
        end
    end
//    assign btb_rf_buff=(~btb_rf[pc_out]==32'b0&&(!hazard_D)&&(!hazard_ld_D))?((pcsrc==2'b00)?pc_buff
//                            :((pcsrc==2'b01)?pc_offset
//                            :((pcsrc==2'b10)?pc_offset_j
//                            :pc_buff)))
//                            :(((~btb_rf[pc_out]!=32'b0))?((IF_flash==1'b0)?btb_rf[pc_out]
//                            :((pcsrc==2'b00)?pc_buff
//                            :((pcsrc==2'b01)?pc_offset
//                            :((pcsrc==2'b10)?pc_offset_j
//                            :pc_buff))))
//                            :((pcsrc==2'b00)?pc_buff
//                            :((pcsrc==2'b01)?pc_offset
//                            :((pcsrc==2'b10)?pc_offset_j
//                            :pc_buff)))
//                            );
//    assign btb_flag_buff=(~btb_rf[pc_out]==32'b0&&(!hazard_D)&&(!hazard_ld_D))?((pcsrc==2'b00)?2'b00
//                            :((pcsrc==2'b01)?2'b11
//                            :((pcsrc==2'b10)?2'b11
//                            :2'b11)))
//                            :((~btb_rf[pc_out]!=32'b0)?((IF_flash==1'b0)?((pcsrc==2'b00)?((btb_flag[pc_out]==2'b00)?2'b00
//                            :btb_flag[pc_out]-2'b01)
//                            :((btb_flag[pc_out]==2'b11)?2'b11
//                            :btb_flag[pc_out]+2'b01))
//                            :((pcsrc==2'b00)?((btb_flag[pc_out]==2'b00)?2'b00
//                            :btb_flag[pc_out]-2'b01)
//                            :((btb_flag[pc_out]==2'b11)?2'b11
//                            :btb_flag[pc_out]+2'b01)))
//                            :((pcsrc==2'b01)?2'b11
//                            :((pcsrc==2'b10)?2'b11
//                            :2'b11))
//                            );
//    always@(*)begin
//        btb_rf[pc_out]<=btb_rf_buff;
//        btb_flag[pc_out]<=btb_flag_buff;
//    end
    //assign pcsrc_buff=pcsrc;
    //reg [1:0]pcsrc_buff1;
    always@(*)begin
        //pcsrc_buff=pcsrc;
        //IF_flash_buff=IF_flash;
        pc_buff=pc;
        //历史中无此pc
        //装填btb表
        if(!IF_flash_D)begin
        if(~btb_rf[pc_out]==32'b0&&(!hazard_D)&&(!hazard_ld_D))begin
            flag1=hazard_D;
            //pcsrc_buff1=pcsrc_buff;
            case(pcsrc)
                2'b00:begin
                    btb_rf[pc_out]<=pc_buff;
                    btb_flag[pc_out]<=2'b00;
                end
                2'b01:begin
                    flag3=1'b1;
                    btb_rf[pc_out]<=pc_offset;
                    btb_flag[pc_out]<=2'b11;
                end
                2'b10:begin
                    btb_rf[pc_out]<=pc_offset_j;
                    btb_flag[pc_out]<=2'b11;
                end
                default:begin
                    btb_rf[pc_out]<=pc_buff;
                    btb_flag[pc_out]<=2'b11;
                end
            endcase
        end
        //历史中有pc
        //更新状态
        else if(~btb_rf[pc_out]!=32'b0)begin
            flag2<=1'b1;
            if(IF_flash==1'b0)begin//预测正确
                if(pcsrc==2'b00)begin//指令不跳转，更新状态表
                    if(btb_flag[pc_out]==2'b00)begin
                        btb_flag[pc_out]<=btb_flag[pc_out];
                    end else begin
                        btb_flag[pc_out]<=btb_flag[pc_out]-2'b01;
                    end
                end else begin//指令跳转，更新状态表
                    if(btb_flag[pc_out]==2'b11)begin
                        btb_flag[pc_out]<=btb_flag[pc_out];
                    end else begin
                        btb_flag[pc_out]<=btb_flag[pc_out]+2'b01;
                    end
                end
            end else begin//预测错误,更新btb表

                case(pcsrc)
                    2'b00:begin
                        btb_rf[pc_out]<=pc_buff;
                        if(btb_flag[pc_out]==2'b00)begin
                            btb_flag[pc_out]<=btb_flag[pc_out];
                        end else begin
                            btb_flag[pc_out]<=btb_flag[pc_out]-2'b01;
                        end
                    end
                    2'b01:begin
                        btb_rf[pc_out]<=pc_offset;
                        if(btb_flag[pc_out]==2'b11)begin
                            btb_flag[pc_out]<=btb_flag[pc_out];
                        end else begin
                            btb_flag[pc_out]<=btb_flag[pc_out]+2'b01;
                        end
                    end
                    2'b10:begin
                        btb_rf[pc_out]<=pc_offset_j;
                        if(btb_flag[pc_out]==2'b11)begin
                            btb_flag[pc_out]<=btb_flag[pc_out];
                        end else begin
                            btb_flag[pc_out]<=btb_flag[pc_out]+2'b01;
                        end
                    end
                    default:begin
                        btb_rf[pc_out]<=pc_buff;
                        btb_flag[pc_out]<=btb_flag[pc_out];
                    end
                endcase
                
            end
        end
        end else begin
            btb_rf[pc_out]<=btb_rf[pc_out];
            btb_flag[pc_out]<=btb_flag[pc_out];
        end
    end
endmodule
