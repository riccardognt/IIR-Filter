library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity MULT is
	generic (
		SHAMT : positive := 20
		);
    Port (
        am : in  STD_LOGIC_VECTOR(13 downto 0);
        bm : in  STD_LOGIC_VECTOR(13 downto 0);
        --sel: in STD_LOGIC;
        mult : out  STD_LOGIC_VECTOR(6 downto 0)
        );
end MULT;

architecture Behavioral of MULT is

signal locala, localb : signed(13 downto 0);
signal localmult : signed(27 downto 0); --27-20-1=6 => 7bit
--signal xmult : signed(26 downto 0);

begin

    locala <= signed(am);
    localb <= signed(bm);
	 
    localmult <= locala * localb; -- dato in 28 bit
	 
	 --xmult <= localmult(26 downto 0); -- dato in 27 bit scartando MSB
	 
	 mult <= std_logic_vector(localmult(26 downto (shamt))); --20= 20=> 7bit di informazioni
 
    
end Behavioral;
