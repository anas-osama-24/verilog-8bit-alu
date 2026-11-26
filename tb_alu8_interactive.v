module tb_alu8_interactive;
    reg  [7:0] a, b;
    reg  [2:0] op;
    wire [7:0] result;
    wire       zero, carry;

    integer    op_in, status;
    reg [31:0] a_in, b_in;

    alu8 dut (.a(a), .b(b), .op(op), .result(result), .zero(zero), .carry(carry));

    initial begin
        $dumpfile("alu.vcd");
        $dumpvars(0, tb_alu8_interactive);
    end

    task read_bin(input [31:0] max, output [31:0] val);
        integer st;
        begin
            val = max + 1;
            while (val > max) begin
                st = $fscanf(32'h8000_0000, "%b", val);
                if (st != 1) val = 0;                    
                else if (val > max) $write("too many bits, try again: ");
            end
        end
    endtask

    initial begin
        op_in = 0;
        while (op_in != 8) begin
            $display("");
            $display("0:ADD 1:SUB 2:AND 3:OR 4:XOR 5:NOT 6:SHR 7:SHL 8:QUIT");
            $write("operation (decimal): ");
            status = $fscanf(32'h8000_0000, "%d", op_in);
            if (status != 1) op_in = 8;

            if (op_in < 0 || op_in > 8) begin
                $display("invalid operation");
            end
            else if (op_in != 8) begin
                $write("A (8-bit binary): ");
                read_bin(255, a_in);

                if (op_in == 5) begin
                    b_in = 0;
                end
                else if (op_in == 6 || op_in == 7) begin
                    $write("shift count (3-bit binary, 000 to 111): ");
                    read_bin(7, b_in);
                end
                else begin
                    $write("B (8-bit binary): ");
                    read_bin(255, b_in);
                end

                op = op_in;
                a  = a_in[7:0];
                b  = b_in[7:0];
                #10;

                case (op_in)
                    0: $display("operation: ADD");
                    1: $display("operation: SUB");
                    2: $display("operation: AND");
                    3: $display("operation: OR");
                    4: $display("operation: XOR");
                    5: $display("operation: NOT");
                    6: $display("operation: SHR");
                    7: $display("operation: SHL");
                endcase

                $display("A      = %b (%0d)", a, a);
                if (op_in == 6 || op_in == 7)
                    $display("shift  = %b (%0d bits)", b[2:0], b[2:0]);
                else if (op_in != 5)
                    $display("B      = %b (%0d)", b, b);
                $display("result = %b (%0d)", result, result);
            end
        end
        $display("done");
        $finish;
    end
endmodule