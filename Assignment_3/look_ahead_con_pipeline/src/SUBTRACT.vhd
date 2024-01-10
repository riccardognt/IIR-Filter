library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity SUBTRACT is
    generic( Nbit: integer := 14);
    Port (
        a : in  STD_LOGIC_VECTOR(Nbit-1 downto 0); --inputs in 14 bits, datas are already in signed format
        b : in  STD_LOGIC_VECTOR(Nbit-1 downto 0);
        result : out  STD_LOGIC_VECTOR(Nbit-1 downto 0)
        );
end SUBTRACT;

architecture Behavioral of SUBTRACT is

begin
	process(a,b)
		variable overflow : std_logic:='0';
		variable locala,localb,localsum : signed(Nbit downto 0);
		variable negsum,possum: std_logic;
		variable sumout : std_logic_vector(Nbit downto 0);
	begin
			locala := '0' & signed(a);--resize(signed(a), 15); --resize input in 15 bits
    		localb := '0' &(-signed(b));---resize(signed(b), 15);
    		localsum := locala + localb;
			negsum:=locala(Nbit-1) and localb(Nbit-1) and (not(localsum(Nbit-1)));
			possum:=(not(locala(Nbit-1))) and (not(localb(Nbit-1))) and (localsum(Nbit-1));

			if(negsum='1' or possum='1') then
				overflow := '1';
			else
				overflow:= '0';
			end if;

    		sumout := std_logic_vector(localsum);

    		--outputs
    		if (overflow = '1')then --Overflow occurs, LSB gets cut
        		result <= sumout(Nbit downto 1);

    		else --Overflown doesn't occur, MSB gets cut
				result <= sumout(Nbit-1 downto 0);      			
    		end if;
	end process;
end Behavioral;
