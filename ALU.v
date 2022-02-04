`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/06/2021 11:25:21 AM
// Design Name: 
// Module Name: ALU
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
//Define control inputs
`define AND 4'b0000
`define OR 4'b0001
`define ADD 4'b0010
`define SLL 4'b0011
`define SRL 4'b0100
`define SUB 4'b0110
`define SLT 4'b0111
`define ADDU 4'b1000
`define SUBU 4'b1001
`define XOR 4'b1010
`define SLTU 4'b1011
`define NOR 4'b1100
`define SRA 4'b1101
`define LUI 4'b1110

module ALU(BusW, Zero, BusA, BusB, ALUCtrl);
input wire [31:0] BusA, BusB;
output reg [31:0] BusW;
input wire [3:0] ALUCtrl ;
output wire Zero ;

wire less;
wire [63:0] Bus64;
//Generate ALUzero signal
assign Zero = BusW == 0;
assign less = ({1'b0,BusA} < {1'b0,BusB}  ? 1'b1 : 1'b0);
//Switch operation based on ctrl signal
always@(*) begin	
	case (ALUCtrl)
	`AND:   BusW <= BusA & BusB;
	`OR:    BusW <= BusA | BusB;
	`ADD:   BusW <= BusA + BusB;
	`ADDU:  BusW <= BusA + BusB;
	`SLL:   BusW <= BusA << BusB;
	`SRL:   BusW <= BusA >> BusB;
	`SUB:   BusW <= BusA - BusB;
	`SUBU:  BusW <= BusA - BusB;
	`XOR:   BusW <= BusA ^ BusB;
	`NOR:   BusW <= ~(BusA | BusB);
	`SLT:   BusW <= {~BusA[31:31] , BusA[30:0]} < {~BusB[31:31] , BusB[30:0]};
	`SLTU:  BusW <= BusA < BusB;
	`SRA:   BusW <= $signed(BusA) >>> BusB;
	`LUI:   BusW <= BusB << 16;
	default:BusW <= BusA + BusB;
	endcase
end
endmodule