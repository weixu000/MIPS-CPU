module digi_translate(digi_out,digi_in);
output[11:0]digi_out;
input [11:0]digi_in;
assign digi_out = (digi_in[3:0] == 0)? {~digi_in[11:8],8'b0000_0010}:
                  (digi_in[3:0] == 1)? {~digi_in[11:8],8'b1001_1110}:
                  (digi_in[3:0] == 2)? {~digi_in[11:8],8'b0010_0100}:
                  (digi_in[3:0] == 3)? {~digi_in[11:8],8'b0000_1100}:
                  (digi_in[3:0] == 4)? {~digi_in[11:8],8'b1001_1000}:
                  (digi_in[3:0] == 5)? {~digi_in[11:8],8'b0100_1000}:
                  (digi_in[3:0] == 6)? {~digi_in[11:8],8'b0100_0000}:
                  (digi_in[3:0] == 7)? {~digi_in[11:8],8'b0001_1110}:
                  (digi_in[3:0] == 8)? {~digi_in[11:8],8'b0000_0000}:
                  (digi_in[3:0] == 9)? {~digi_in[11:8],8'b0000_0100}:
                  (digi_in[3:0] == 10)? {~digi_in[11:8],8'b0000_1000}:
                  (digi_in[3:0] == 11)? {~digi_in[11:8],8'b1100_0000}:
                  (digi_in[3:0] == 12)? {~digi_in[11:8],8'b0110_0010}:
                  (digi_in[3:0] == 13)? {~digi_in[11:8],8'b1000_0100}:
                  (digi_in[3:0] == 14)? {~digi_in[11:8],8'b0110_0010}:
                  (digi_in[3:0] == 15)? {~digi_in[11:8],8'b0111_0010}:
                  {4'b1111,8'b0000_0000};
endmodule
