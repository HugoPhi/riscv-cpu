`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/20 19:38:36
// Design Name: 
// Module Name: regfile
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


module regfile(
	input clk,
	input we3,//写使能
	input [4:0] ra1,ra2,wa3,
	input [31:0] wd3,//写数据
	output wire [31:0] rd1,rd2
    );
	reg [31:0] rf[31:0];
//	reg [4:0]wa3_temp;
//	reg [31:0] temp_rd1, temp_rd2;
	always @(posedge clk) begin
		if(we3) begin
			 rf[wa3] <= wd3;
		end
//		if(wa3 == 5'bX)begin
//		     wa3_temp <= wa3;
//		end
//		else begin
//		     wa3_temp <= wa3;
//		end
//		temp_rd1 = (ra1 != 0) ? rf[ra1] : 0;
//        temp_rd2 = (ra2 != 0) ? rf[ra2] : 0;
	end
//	always@(negedge clk)begin
//	   rd1 <= temp_rd1;
//	   rd2 <= temp_rd2;
//	end
//    assign rd1 = (wa3 == 5'bXXXXX) ? ((ra1 != 0) ? rf[ra1] : 0) : (wa3 == ra1) ? wd3 : ((ra1 != 0) ? rf[ra1] : 0);
//    assign rd2 = (wa3 == 5'bXXXXX) ? ((ra2 != 0) ? rf[ra2] : 0) : (wa3 == ra2) ? wd3 : ((ra2 != 0) ? rf[ra2] : 0);
    
    assign rd1 = (wa3 == ra1) ? wd3 : (ra1 != 0) ? rf[ra1] : 0;
    assign rd2 = (wa3 == ra2) ? wd3 : (ra2 != 0) ? rf[ra2] : 0;
//	assign rd1 = (ra1 != 0) ? rf[ra1] : 0;
//    assign rd2 = (ra2 != 0) ? rf[ra2] : 0;
endmodule
