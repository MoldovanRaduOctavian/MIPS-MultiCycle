----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/13/2022 02:40:04 PM
-- Design Name: 
-- Module Name: mem - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mem is
  Port (
  clk : in std_logic;
  buttonEn : in std_logic;
  we : in std_logic;
  address : in std_logic_vector(15 downto 0);
  dataIn : in std_logic_vector(15 downto 0);
  dataOut : out std_logic_vector(15 downto 0) 
   );
end mem;

architecture Behavioral of mem is

type memory is array(0 to 2**12 - 1) of std_logic_vector(15 downto 0);
signal memData : memory := (
--b"000_000_000_000_0000",
--b"000_000_000_000_0000",
--b"000_000_000_000_0000",
--b"000_000_000_000_0000",
--b"001_000_010_0001111",
--b"001_000_011_0000011",
--b"000_010_011_001_0000",
--b"001_010_010_0001111",
--b"001_000_011_0001111",
--b"000_010_011_001_1001",
--b"111_0000000000000",

--b"000_000_000_000_0000",
--b"001_000_010_0111111", -- addi $2, $0, 0b0111111
--b"101_000_010_0001111", -- sw $2, $0, 0xf
--b"100_000_001_0001111", -- lw $1, $0, 0xf

--b"000_000_000_000_0000",
--b"001_000_001_0000111",
--b"111_0000000000000",
--b"001_000_010_0111111",

--b"000_000_000_000_0000",
--b"001_000_010_0001110",
--b"001_000_011_0001111",
--b"110_010_011_0000010",
--b"000_000_000_000_0000",
--b"001_000_001_0111111",

--b"000_000_000_000_0000",
--b"001_000_010_1111111",
--b"001_000_011_0011111",
--b"000_010_011_001_1011",

--b"000_000_000_000_0000",
--b"001_001_001_0000001",
--b"111_0000000000001",

-- programul calculeaza suma primelor n numere ale lui Fibonacci
b"000_000_000_000_0000",    -- noop 0
b"001_000_100_0000000",     -- addi $4, $0, 0   1
b"001_000_110_0000010",     -- addi $6, $0, 2   2
b"100_000_111_0010100",     -- lw $7, $0, 0     3
b"001_000_001_0000000",     -- addi $1, $0, 0   4
b"001_000_010_0000001",     -- addi $2, $0, 1   5
b"001_000_011_0000000",     -- addi $3, $0, 0   6
b"001_000_100_0000001",     -- addi $4, $0, 1   7
b"000_001_010_101_0000",    -- add $5, $1, $2   8
b"000_100_101_100_0000",    -- add $4, $4, $5   9
b"000_000_010_001_0000",    -- add $1, $0, $2   10
b"000_000_101_010_0000",    -- add $2, $0, $5   11
b"001_110_110_0000001",     -- addi $6, $6, 1   12
b"110_110_111_0000010",     -- beq $6, $7, 2    13
b"000_000_000_000_0000",    -- noop             14
b"111_0000000001000",       -- j    8           15
b"101_000_100_0010101",     -- sw $4, $0, 1     16
b"100_000_001_0010101",     -- lw $1, $0, 1     17
b"000_000_000_000_0000",    -- noop             18
b"000_000_000_000_0000",    -- noop             19
x"0007",
others => x"0000");

begin

process(clk)
begin

    if rising_edge(clk) then
        if buttonEn = '1' then
            if we = '1' then
                memData(conv_integer(address)) <= dataIn;
            end if;
        end if;
    end if;

end process;

dataOut <= memData(conv_integer(address));

end Behavioral;
