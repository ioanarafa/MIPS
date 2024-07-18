library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity MC is -- tabel
  Port( Instr: in std_logic_vector (2 downto 0);
        RegDst: out std_logic;
        ExtOp: out std_logic;
        ALUSrc: out std_logic;
        Branch: out std_logic;
        Jump: out std_logic;
        MemWrite: out std_logic;
        MemToReg: out std_logic;
        RegWrite: out std_logic;
        ALUOp: out std_logic_vector (2 downto 0)
    );
end MC;

architecture Behavioral of MC is

begin

process(Instr)
begin
RegDst <= '0';
ExtOp <= '0';
ALUSrc <= '0';
Branch <= '0';
Jump <= '0';
MemWrite <= '0';
MemtoReg <= '0';
RegWrite <= '0';
ALUOp <= "000";
case Instr is 
    when "000000" =>  -- Tipul R
	    RegDst <= '1';
		RegWrite <= '1';
		ALUOp <= "000";
			
	when "000001" =>  -- ADDI
		ExtOp <= '1';
		ALUSrc <= '1';
		RegWrite <= '1';
		ALUOp <= "001";
		    
	when "000100" => --LW
		ExtOp <= '1';
		ALUSrc <= '1';
		RegWrite <= '1';
		MemtoReg <= '1';
		ALUOp <= "001";
		    
    when "000101" => --SW
		ExtOp <= '1';
		ALUSrc <= '1';
		MemWrite <= '1';
		ALUOp <= "001";
		    
	when "000110" => --BEQ
		ExtOp <= '1';
		Branch <= '1';
		ALUOp <= "010"; 
		    
	when "000011" => --ANDI
		ALUSrc <= '1';
		RegWrite <= '1';
		ALUOp <= "011";
		    
	when "000010" => --ORI
		ALUSrc <= '1';
		RegWrite <= '1';
		ALUOp <= "110";
		    
	when "000111" => --J
		Jump <= '1';
		
    when others => 
		RegDst <= '0'; 
		ExtOp <= '0'; 
		ALUSrc <= '0'; 
        Branch <= '0'; 
        Jump <= '0'; 
        MemWrite <= '0';
        MemtoReg <= '0'; 
        RegWrite <= '0';
        ALUOp <= "000";   
        
end case;
end process;

end Behavioral;