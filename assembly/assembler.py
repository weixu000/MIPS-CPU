def RType(opcode, rs, rt, rd, shamt, funct):
    return opcode << 26 | rs << 21 | rt << 16 | rd << 11 | shamt << 6 | funct


def IType(opcode, rs, rt, imm16):
    return opcode << 26 | rs << 21 | rt << 16 | (imm16 & 0xffff)


def JType(opcode, target):
    return opcode << 26 | target


def NextPowOf2(x):
    n = 1
    while n < x:
        n *= 2
    else:
        return n


with open('code.asm', encoding='utf-8') as f: lines = f.readlines()
lines = [line.strip() for line in lines if line and line[0] != '#']

labels = {}
insts = []
addr = 0
for line in lines:
    *label, inst = line.split(':')
    assert len(label) <= 1
    if label: labels[label[0]] = addr
    inst, *_ = inst.split('#')
    if inst:
        addr += 1
        insts.append(inst.strip())

regs = {'$zero': 0, '$at': 1,
        '$v0': 2, '$v1': 3,
        '$a0': 4, '$a1': 5, '$a2': 6, '$a3': 7,
        '$t0': 8, '$t1': 9, '$t2': 10, '$t3': 11, '$t4': 12, '$t5': 13, '$t6': 14, '$t7': 15,
        '$s0': 16, '$s1': 17, '$s2': 18, '$s3': 19, '$s4': 20, '$s5': 21, '$s6': 22, '$s7': 23,
        '$t8': 24, '$t9': 25,
        '$k0': 26, '$k1': 27,
        '$gp': 28, '$sp': 29, '$fp': 30, '$ra': 31,
        '$0': 0, '$1': 1, '$2': 2, '$3': 3, '$4': 4, '$5': 5, '$6': 6, '$7': 7, '$8': 8, '$9': 9, '$10': 10, '$11': 11,
        '$12': 12, '$13': 13, '$14': 14, '$15': 15, '$16': 16, '$17': 17, '$18': 18, '$19': 19, '$20': 20, '$21': 21,
        '$22': 22, '$23': 23, '$24': 24, '$25': 25, '$26': 26, '$27': 27, '$28': 28, '$29': 29, '$30': 30, '$31': 31, }
opcodes = {'add': 0, 'addu': 0, 'sub': 0, 'subu': 0, 'and': 0, 'or': 0, 'xor': 0, 'nor': 0,
           'sll': 0, 'srl': 0, 'sra': 0, 'jr': 0, 'jalr': 0,
           'lw': 0x23, 'sw': 0x2b, 'lui': 0x0f,
           'addi': 0x08, 'addiu': 0x09, 'andi': 0x0c, 'ori': 0x0d, 'slti': 0x0a, 'sltiu': 0x0b,
           'beq': 0x04, 'bne': 0x05, 'ble': 0x06, 'bgt': 0x07, 'blt': 0x01,
           'beqz':0x04, 'bnez':0x05, 'blez': 0x06, 'bgtz': 0x07, 'bltz': 0x01,
           'j': 0x02, 'jal': 0x03}
functs = {'add': 0x20, 'addu': 0x21, 'sub': 0x22, 'subu': 0x23, 'and': 0x24, 'or': 0x25, 'xor': 0x26, 'nor': 0x27,
          'sll': 0x00, 'srl': 0x02, 'sra': 0x03, 'jr': 0x08, 'jalr': 0x09}

bins = []
for i, inst in enumerate(insts):
    sym, *vs = inst.split(maxsplit=1)
    vs = vs[0].split(',') if vs else ''
    vs = [v.strip() for v in vs]
    if sym in {'add', 'addu', 'sub', 'subu', 'and', 'or', 'xor', 'nor'}:
        rd, rs, rt = map(lambda x: regs[x], vs)
        bins.append(RType(opcodes[sym], rs, rt, rd, 0, functs[sym]))
    elif sym in {'sll', 'srl', 'sra'}:
        rd, rt, shamt = vs
        rd, rt = regs[rd], regs[rt]
        shamt = int(shamt)
        bins.append(RType(opcodes[sym], 0, rt, rd, shamt, functs[sym]))
    elif sym in {'jr'}:
        rs = regs[vs[0]]
        bins.append(RType(opcodes[sym], rs, 0, 0, 0, functs[sym]))
    elif sym in {'jalr'}:
        rs, rd = map(lambda x: regs[x], vs)
        bins.append(RType(opcodes[sym], rs, 0, rd, 0, functs[sym]))
    elif sym in {'lw', 'sw'}:
        rt, addr = vs
        offset, rs = addr.split('(')
        offset = int(offset)
        rs, rt = regs[rs[:-1]], regs[rt]
        bins.append(IType(opcodes[sym], rs, rt, offset))
    elif sym in {'lui'}:
        rt, imm16 = vs
        rt = regs[rt]
        imm16 = int(imm16)
        bins.append(IType(opcodes[sym], 0, rt, imm16))
    elif sym in {'addi', 'addiu', 'andi', 'ori', 'slti', 'sltiu'}:
        rt, rs, imm16 = vs
        rt, rs = regs[rt], regs[rs]
        imm16 = int(imm16)
        bins.append(IType(opcodes[sym], rs, rt, imm16))
    elif sym in {'beq', 'bne', 'ble', 'bgt', 'blt'}:
        rs, rt, label = vs
        rs, rt = regs[rs], regs[rt]
        imm16 = labels[label] - i - 1
        bins.append(IType(opcodes[sym], rs, rt, imm16))
    elif sym in {'beqz', 'bnez', 'blez', 'bgtz', 'bltz'}:
        rs, label = vs
        rs = regs[rs]
        imm16 = labels[label] - i - 1
        bins.append(IType(opcodes[sym], rs, 0, imm16))
    elif sym in {'j', 'jal'}:
        target = vs[0]
        target = labels[target]
        bins.append(JType(opcodes[sym], target))
    elif sym in {'nop'}:
        bins.append(JType(0, 0))
    else:
        raise Exception('Unkown instruction {}'.format(inst))

output = '''module ROM(
    input [30:0] addr,
    output [31:0] data
);

localparam ROM_SIZE = {};
(* rom_style = "distributed" *) reg [31:0] ROMDATA[ROM_SIZE-1:0];

assign data = addr[30:2]<ROM_SIZE ? ROMDATA[addr[30:2]] : 32'b0;

integer i;
initial begin'''.format(NextPowOf2(len(bins)))
output = '\n'.join([output] + ["    ROMDATA[{}] <= 32'h{};".format(i, hex(b)[2:].zfill(8)) for i, b in enumerate(bins)])
output += '''
    for (i={}; i<ROM_SIZE; i=i+1) begin
        ROMDATA[i] <= 32'b0;
    end
end
endmodule
'''.format(len(bins))
with open('ROM.v', mode='w', encoding='utf-8') as f:
    f.write(output)
