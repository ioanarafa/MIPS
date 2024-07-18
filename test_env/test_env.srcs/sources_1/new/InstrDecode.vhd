library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity InstrDecode is
    Port ( clk: in STD_LOGIC;
           en : in STD_LOGIC;    
           Instr : in STD_LOGIC_VECTOR(25 downto 0);
           write : in STD_LOGIC_VECTOR(31 downto 0);
           RegWrite : in STD_LOGIC;
           RegDst : in STD_LOGIC;
           ExtOp : in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR(31 downto 0);
           RD2 : out STD_LOGIC_VECTOR(31 downto 0);
           Ext_Imm : out STD_LOGIC_VECTOR(31 downto 0);
           func : out STD_LOGIC_VECTOR(5 downto 0);
           sa : out STD_LOGIC_VECTOR(10 downto 6));
end InstrDecode;

architecture Behavioral of InstrDecode is

-- RegFile
type reg_array is array(0 to 7) of STD_LOGIC_VECTOR(31 downto 0);
signal reg_file : reg_array := (others => X"00000000");

signal WriteAddress: STD_LOGIC_VECTOR(4 downto 0);
signal RegAddress: STD_LOGIC_VECTOR(31 downto 0);

begin

    -- RegFile write
    with RegDst select
        WriteAddress <= Instr(15 downto 11) when '1', -- rd
                        Instr(20 downto 16) when '0', -- rt
                        (others => '0') when others; 

    process(clk)			
    begin
        if rising_edge(clk) then
            if en = '1' and RegWrite = '1' then
                reg_file(conv_integer(WriteAddress)) <= write;		
            end if;
        end if;
    end process;		
    -- RegFile read
    RD1 <= reg_file(conv_integer(Instr(25 downto 21))); -- rs
    RD2 <= reg_file(conv_integer(Instr(24 downto 20))); -- rt
    
    -- extend
    Ext_Imm(15 downto 0) <= Instr(15 downto 0); 
    with ExtOp select
        Ext_Imm(31 downto 16) <= (others => Instr(15)) when '1',
                                (others => '0') when '0',
                                (others => '0') when others;

    sa <= Instr(10 downto 6);
    func <= Instr(5 downto 0);

end Behavioral;