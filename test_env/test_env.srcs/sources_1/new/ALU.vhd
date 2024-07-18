library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.ALL;

entity ALU is
    Port ( PCinc : in STD_LOGIC_VECTOR(31 downto 0);
           RD1 : in STD_LOGIC_VECTOR(31 downto 0);
           RD2 : in STD_LOGIC_VECTOR(31 downto 0);
           Ext_Imm : in STD_LOGIC_VECTOR(31 downto 0);
           func : in STD_LOGIC_VECTOR(5 downto 0);
           sa : in STD_LOGIC_VECTOR(4 downto 0);
           ALUSrc : in STD_LOGIC;
           ALUOp : in STD_LOGIC_VECTOR(2 downto 0);
           BranchAddress : out STD_LOGIC_VECTOR(31 downto 0);
           ALURes : out STD_LOGIC_VECTOR(31 downto 0);
           Zero : out STD_LOGIC);
end ALU;

architecture Behavioral of ALU is

signal ALUIn2 : STD_LOGIC_VECTOR(31 downto 0);
signal ALUIn1 : STD_LOGIC_VECTOR(31 downto 0);
signal ALUCtrl : STD_LOGIC_VECTOR(2 downto 0);
signal ALUResAux : STD_LOGIC_VECTOR(31 downto 0);

begin

    -- MUX for ALU input 2
    with ALUSrc select
        ALUIn2 <= RD2 when '0', 
	              Ext_Imm when '1',
	              (others => '0') when others;
			  
    -- ALU Control
    process(ALUOp, func)
begin
case ALUOp is
	when "001" =>-- type R
				 case func is
					 when "000000"=> ALUCtrl <= "000"; -- ADD	
					 when "000010"=> ALUCtrl <= "010"; -- SUB
					 when "000011"=> ALUCtrl <= "011"; -- SLL
					 when "000100"=> ALUCtrl <= "100"; -- SRL
					 when "000101"=> ALUCtrl <= "101"; -- AND
					 when "000110"=> ALUCtrl <= "110"; -- OR
					 when "000111"=> ALUCtrl <= "111"; -- XOR
					 when "000001"=> ALUCtrl <= "001"; -- NAND
					 when others => ALUCtrl <= (others => 'X'); 
				 end case;
	when "010" => ALUCtrl <= "000"; -- ADDI, LW, SW 
	when "011" => ALUCtrl <= "001"; -- BEQ
	when "100" => ALUCtrl <= "100"; -- ANDI
	when "101" => ALUCtrl <= "101"; -- ORI
	when others => ALUCtrl <= (others => 'X'); -- J	
end case;
end process;

    -- ALU
    process(ALUCtrl, RD1, AluIn2, sa, ALUResAux)
    begin
        case ALUCtrl  is
            when "000" => -- ADD
                ALUResAux <= RD1 + ALUIn2;
            when "001" =>  -- SUB
                ALUResAux <= RD1 - ALUIn2;                                    
            when "010" => -- SLL
                case sa is
                    when "00001" => ALUResAux <= ALUIn2(30 downto 0) & "0";
                    when "00000" => ALUResAux <= ALUIn2;
                    when others => ALUResAux <= (others => '0');
                 end case;
            when "011" => -- SRL
                case sa is
                    when "00001" => ALUResAux <= "0" & ALUIn2(31 downto 1);
                    when "00000" => ALUResAux <= ALUIn2;
                    when others => ALUResAux <= (others => '0');
                end case;
            when "100" => -- AND
                ALUResAux<=RD1 and ALUIn2;		
            when "101" => -- OR
                ALUResAux<=RD1 or ALUIn2; 
            when "110" => -- XOR
                ALUResAux<=RD1 xor ALUIn2;		
            when "111" => 
                if signed(RD1) < signed(ALUIn2) then
                    ALUResAux <= X"00000001";
                else 
                    ALUResAux <= X"00000000";
                end if;
            when others => 
                ALUResAux <= (others => '0');              
        end case;

        -- zero detector
        case ALUResAux is
            when X"0000" => Zero <= '1';
            when others => Zero <= '0';
        end case;
    
    end process;

    -- ALU result
    ALURes <= ALUResAux;

    -- generate branch address
    BranchAddress <= PCinc + Ext_Imm;

end Behavioral;