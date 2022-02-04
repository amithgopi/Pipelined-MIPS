`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/03/2021 02:57:11 PM
// Design Name: 
// Module Name: HazardUnit
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

//state  = {IF_write, PC_write, bubble, [1:0] addrSel}
//AddrSel 0 - PC+4, 1 - Jump target, 2 - Branch target
`define defaultState    5'b11000
`define hazardState     5'b00100
`define jumpState       5'b01101
`define branchState0    5'b10000
`define branchState1    5'b01110          //No branch - Condition not zero

module HazardUnit(IF_write, PC_write, bubble, addrSel, Jump, Branch, ALUZero, memReadEX, currRs, currRt, prevRt, UseShamt, UseImmed, Clk, Rst);
output reg IF_write, PC_write, bubble;
output reg [1:0] addrSel;
input Jump, Branch, ALUZero, memReadEX, Clk, Rst;
input UseShamt, UseImmed;
input [4:0] currRs, currRt, prevRt;

reg LdHazard;
reg [4:0] state, nextState;

//Load hazard detection logic - generate the Ldhazard signal
always @* begin
    if(prevRt == 0) LdHazard = 1'b0; 
    else if( (currRs == prevRt || currRt == prevRt) && memReadEX == 1'b1 && UseShamt ==0 && UseImmed == 0) LdHazard = 1'b1;
    else if(UseShamt == 1 && currRs == prevRt && memReadEX == 1'b1) LdHazard = 1'b1;
    else if(UseImmed == 1 && currRs == prevRt && memReadEX == 1'b1) LdHazard = 1'b1;
    else LdHazard = 1'b0; 
end

//Change state on each clock
always @(negedge Clk) begin
    if(Rst) state <= `defaultState;
    else state <= nextState;
end

//Combinational part of the state machine
//Sets new state based on old state and other inputs
always @(LdHazard, Jump, Branch, ALUZero, state) begin
    case(state)
        `defaultState: begin
            if(Jump == 1'b1) begin
                nextState = `jumpState;
                {IF_write, PC_write, bubble, addrSel} = `jumpState;
            end
            else if(LdHazard == 1'b1) begin
                nextState = `hazardState;   //Go to hazard state
                {IF_write, PC_write, bubble, addrSel} = `hazardState;
            end
            else if(Branch == 1'b1) begin   //Branch - go to branch state
                nextState = `branchState0;
                {IF_write, PC_write, bubble, addrSel} = `branchState0;  
            end
            else begin                      //Remain in normal state
                nextState = `defaultState;
                {IF_write, PC_write, bubble, addrSel} = `defaultState;  
            end
        end
        `branchState0: begin    
            if(ALUZero == 1'b1) begin       //Go to branch taken state based on ALU zero value
                nextState = `branchState1;
                {IF_write, PC_write, bubble, addrSel} = `branchState1;
            end
            else begin 
                nextState = `defaultState;  //Back to default state
                {IF_write, PC_write, bubble, addrSel} = `defaultState; 
            end
        end
        `branchState1: begin            //Back to default state
            nextState = `defaultState;
            {IF_write, PC_write, bubble, addrSel} = `defaultState;
         end
        `jumpState: begin               //Back to default state
             nextState = `defaultState;
            {IF_write, PC_write, bubble, addrSel} = `defaultState; 
        end
        `hazardState: begin             //Back to default state
             nextState = `defaultState;
            {IF_write, PC_write, bubble, addrSel} = `defaultState;
        end
        default: begin
            nextState = `defaultState;
            IF_write = 1'bx;
            PC_write = 1'bx;
            bubble = 1'bx;
            addrSel = 2'bx;
        end  
    endcase
end
        
endmodule