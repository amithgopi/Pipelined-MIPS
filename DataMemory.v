`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2021 12:19:27 PM
// Design Name: 
// Module Name: DataMemory
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


module DataMemory(ReadData, Address, WriteData, MemoryRead, MemoryWrite, Clock);
input [5:0] Address;
input [31:0] WriteData;
input MemoryRead, MemoryWrite, Clock;
output reg [31:0] ReadData = 0;
reg [31:0] memory [0:63];

//Reads
always @(posedge Clock) begin
    if(MemoryRead) begin
        ReadData <= memory[Address];  
    end
end
//Writes
always @(negedge Clock) begin 
    if(MemoryWrite) begin
        memory[Address] <= WriteData;
    end
end
endmodule
