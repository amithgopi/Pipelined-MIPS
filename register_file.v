`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2021 11:44:25 AM
// Design Name: 
// Module Name: register_file
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


module RegisterFile(busA, busB, busW, RA, RB, RW, RegWr, clk);
input [4:0] RA;
input [4:0] RB;
input [4:0] RW;
input [31:0] busW;
input RegWr, clk;
output  [31:0] busA;
output  [31:0] busB ;
reg [31:0] file [31:0];

always @(posedge clk) begin
    if(RegWr) file[RW] <= busW;
end 

assign busA = RA == 0 ? 0 : file[RA];
assign busB = RB == 0 ? 0 : file[RB];
endmodule
