library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity InstrFetch is
    Port (clk: in STD_LOGIC;
          rst : in STD_LOGIC;
          en : in STD_LOGIC;
          Branch : in STD_LOGIC_VECTOR(31 downto 0);
          JumpAddress : in STD_LOGIC_VECTOR(31 downto 0);
          Jump : in STD_LOGIC;
          PCSrc : in STD_LOGIC;
          Instruction : out STD_LOGIC_VECTOR(31 downto 0);
          PCinc : out STD_LOGIC_VECTOR(31 downto 0));
end InstrFetch;

architecture Behavioral of InstrFetch is

type mem is array(0 to 255) of std_logic_vector(31 downto 0);
signal M: mem :=(
        B"000001_00000_00001_0000000000000001", --4010001
        B"000001_00000_00010_0000000000000111",  -- 4020007
        B"000001_00000_00011_0000000000000000", -- 4030000
        B"000001_00000_00100_0000000000000000", -- 4040000
        B"000011_00001_00101_0000000000000001", -- C250001
        B"000011_00000_00101_0000000000000010",  --C050002
        B"000000_00100_00001_00100_00000_000000", --812000
        B"00111_00000000000000000000001011",   --1C00000B
        B"000000_00001_00010_00101_00000_000000", --222800
        B"000000_00000_00010_00001_00000_000000", --20800
        B"000000_00100_00111_00100_00000_000000", --872000
        B"000001_00001_00001_0000000000000001", -- 4210001
        B"000001_00011_00011_0000000000000001", -- 4630001
        B"000110_00010_00001_0000000000000001", -- 18410001
        B"00111_00000000000000000000000100", -- 1C000004         
        others => B"0000");
signal PC : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal PCAux, NextAddr, Aux, Aux1: STD_LOGIC_VECTOR(31 downto 0);

begin

    -- Program Counter
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                PC <= (others => '0');
            elsif en = '1' then
                PC <= NextAddr;
            end if;
        end if;
    end process;

    Instruction <= M(conv_integer(PC(6 downto 2)));

    -- PC inc
    PCAux <= PC + 4;
    PCinc <= PCAux;

    -- MUX Branch
    process(PCSrc, PCAux, Branch)
    begin
        case PCSrc is 
            when '1' => Aux <= Branch;
            when others => Aux<= PCAux;
        end case;
    end process;	

     -- MUX Jump
    process(Jump, Aux, JumpAddress)
    begin
        case Jump is
            when '1' => NextAddr <= JumpAddress;
            when others => NextAddr <= Aux;
        end case;
    end process;

end Behavioral;