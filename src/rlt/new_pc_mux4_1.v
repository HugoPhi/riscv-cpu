`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/04 11:27:29
// Design Name: 
// Module Name: new_pc_mux4_1
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


module new_pc_mux4_1(
    input [1:0]pcsrc,
    input [31:0]pc_pre,//btb
    input [31:0]pc_4,//addr1
    input [31:0]pc_offset,//addr2
    input [31:0]pc_offset_j,//pc_offset
    input btb_en,//btb‘§≤‚ πƒ‹
    input IF_flash,
    output wire [31:0]pc,
    input [31:0]pc_4_D,
    input IF_flash_D
    );
    assign pc=(btb_en&&(!IF_flash))?pc_pre:((IF_flash&&(pcsrc==2'b0))?pc_4_D:((pcsrc==2'b00)?pc_4:((pcsrc==2'b01)?pc_offset:pc_offset_j)));
    //assign pc=(btb_en&(!IF_flash))?pc_pre:((pcsrc==2'b00)?pc_4:((pcsrc==2'b01)?pc_offset:pc_offset_j));
endmodule
