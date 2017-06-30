module ROM(
    input [30:0] addr,
    output [31:0] data);

localparam ROM_SIZE = 32;
(* rom_style = "distributed" *) reg [31:0] ROMDATA[ROM_SIZE-1:0];

assign data = addr[30:2]<ROM_SIZE ? ROMDATA[addr[30:2]] : 32'b0;

integer i;
initial begin
    // ROMDATA[0] <= 32'h3c114000;
    // ROMDATA[1] <= 32'h26310004;
    // ROMDATA[2] <= 32'h241000aa;
    // ROMDATA[3] <= 32'hae200000;
    // ROMDATA[4] <= 32'h08100000;
    // ROMDATA[5] <= 32'h0c000000;
    // ROMDATA[6] <= 32'h00000000;
    // ROMDATA[7] <= 32'h3402000a;
    // ROMDATA[8] <= 32'h0000000c;
    // ROMDATA[9] <= 32'h0000_0000;
    // ROMDATA[10] <= 32'h0274_8825;
    // ROMDATA[11] <= 32'h0800_0015;
    // ROMDATA[12] <= 32'h0274_8820;
    // ROMDATA[13] <= 32'h0800_0015;
    // ROMDATA[14] <= 32'h0274_882A;
    // ROMDATA[15] <= 32'h1011_0002;
    // ROMDATA[16] <= 32'h0293_8822;
    // ROMDATA[17] <= 32'h0800_0015;
    // ROMDATA[18] <= 32'h0274_8822;
    // ROMDATA[19] <= 32'h0800_0015;
    // ROMDATA[20] <= 32'h0274_8824;
    // ROMDATA[21] <= 32'hae11_0003;
    // ROMDATA[22] <= 32'h0800_0001;

    // $sp放到内存顶部
    // addi $sp, $zero, 0x3FF
    ROMDATA[0] <= {6'h08, 5'd0 , 5'd29 , 16'h3FF};

    // 计算$a0的自然数之和
    // addi $a0, $zero, 3
    ROMDATA[1] <= {6'h08, 5'd0 , 5'd4 , 16'd3};
    // jal sum
    ROMDATA[2] <= {6'h03, 26'd4};
    // Loop:
    // beq $zero, $zero, Loop
    ROMDATA[3] <= {6'h04, 5'd0 , 5'd0 , 16'hffff};
    // sum:
    // addi $sp, $sp, -8
    ROMDATA[4] <= {6'h08, 5'd29 , 5'd29 , 16'hfff8};
    // sw $ra, 4($sp)
    ROMDATA[5] <= {6'h2b, 5'd29 , 5'd31, 16'd4};
    // sw $a0, 0($sp)
    ROMDATA[6] <= {6'h2b, 5'd29 , 5'd4, 16'd0};
    // slti $t0, $a0, 1
    ROMDATA[7] <= {6'h0a, 5'd4 , 5'd8 , 16'd1};
    // beq $t0, $zero, L1
    ROMDATA[8] <= {6'h04, 5'd8 , 5'd0 , 16'd3};
    // xor $v0, $zero, $zero
    ROMDATA[9] <= {6'h00, 5'd0 , 5'd0 , 5'd2 , 5'd0 , 6'h26};
    // addi $sp, $sp, 8
    ROMDATA[10] <= {6'h08, 5'd29 , 5'd29 , 16'd8};
    // jr $ra
    ROMDATA[11] <= {6'h00, 5'd31 , 15'd0 , 6'h08};
    // L1:
    // addi $a0, $a0, -1
    ROMDATA[12] <= {6'h08, 5'd4 , 5'd4 , 16'hffff};
    // jal sum
    ROMDATA[13] <= {6'h03, 26'd4};
    // lw $a0, 0($sp)
    ROMDATA[14] <= {6'h23, 5'd29 , 5'd4, 16'd0};
    // lw $ra, 4($sp)
    ROMDATA[15] <= {6'h23, 5'd29 , 5'd31, 16'd4};
    // addi $sp, $sp, 8
    ROMDATA[16] <= {6'h08, 5'd29 , 5'd29 , 16'd8};
    // add $v0, $a0, $v0
    ROMDATA[17] <= {6'h00, 5'd4 , 5'd2 , 5'd2 , 5'd0 , 6'h20};
    // jr $ra
    ROMDATA[18] <= {6'h00, 5'd31 , 15'd0 , 6'h08};

    for (i=19; i<ROM_SIZE; i=i+1) begin
        ROMDATA[i] <= 32'b0;
    end
end
endmodule
