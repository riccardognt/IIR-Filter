LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.ALL;

ENTITY myIIR2 IS
	 
	PORT (  b0, b1, b2, b3, a2, a3 : in std_logic_vector(13 downto 0);
			DIN : in std_logic_vector(13 downto 0);
		    VIN, CLK : in std_logic;
			RST_n : in std_logic;
			DOUT : out std_logic_vector (13 downto 0);
			VOUT : out std_logic); -- control singnals
			 
END myIIR2;

ARCHITECTURE Structure OF myIIR2 IS

signal VIN_reg1 : std_logic;
signal sig1, sig2, sig3, sig4, sig5, sig8, sig15: std_logic_vector(13 downto 0);
signal sig6_trunc7, sig7_trunc7, sig9_trunc7, sig10_trunc7, sig12_trunc7, sig14_trunc7 : std_logic_vector(6 downto 0);
signal sig8_trunc8, sig11_trunc8, sig12_trunc8 : std_logic_vector(7 downto 0);
signal sig13_trunc9, sig14_trunc9 :  std_logic_vector(8 downto 0);
signal sig15_trunc10 : std_logic_vector(9 downto 0);
signal sigb0, sigb1, sigb2, sigb3, siga2, siga3 : std_logic_vector(13 downto 0);

COMPONENT FF IS
	PORT (  CLK     :   in std_logic;                       
        	RST     :   in std_logic;                                        
        	D       :   in std_logic;
		  	Q       :   out std_logic); -- control singnals
END COMPONENT;

COMPONENT REG IS
	port (
			CLK     :   in std_logic;                       
        	RST     :   in std_logic;                       
        	ENABLE  :   in  std_logic;                  
        	D       :   in std_logic_vector(13 downto 0);
		  	Q       :   out std_logic_vector(13 downto 0)
		);
END COMPONENT;

COMPONENT REGNOEN IS
	port (
			CLK     :   in std_logic;                       
        	RST     :   in std_logic;                                         
        	D       :   in std_logic_vector(13 downto 0);
		  	Q       :   out std_logic_vector(13 downto 0)
		);
END COMPONENT;

COMPONENT MULT IS
	generic (
		SHAMT : positive := 20
		);
    Port (
        am : in  STD_LOGIC_VECTOR(13 downto 0);
        bm : in  STD_LOGIC_VECTOR(13 downto 0);
        --sel: in STD_LOGIC;
        mult : out  STD_LOGIC_VECTOR(6 downto 0)
        );
END COMPONENT;

COMPONENT ADD IS
	generic( Nbit: integer := 14);
    Port (
        a : in  STD_LOGIC_VECTOR(Nbit-1 downto 0); --inputs in 14 bits, datas are already in signed format
        b : in  STD_LOGIC_VECTOR(Nbit-1 downto 0);
        sum : out  STD_LOGIC_VECTOR(Nbit downto 0)
        );
END COMPONENT;

COMPONENT SUBTRACT IS
    generic( Nbit: integer := 14);
    Port (
        a : in  STD_LOGIC_VECTOR(Nbit-1 downto 0); --inputs in 14 bits, datas are already in signed format
        b : in  STD_LOGIC_VECTOR(Nbit-1 downto 0);
        result : out  STD_LOGIC_VECTOR(Nbit-1 downto 0)
        );
END COMPONENT;

BEGIN

REG_in:
	REG port map (CLK=>CLK, RST=>RST_n, ENABLE =>VIN, D=>DIN, Q=>sig1);
	
REG_out:
	REG port map (CLK=>CLK, RST=>RST_n , ENABLE =>VIN_reg1, D=>sig15, Q=>DOUT);
	
FF1:
	FF port map (CLK=>CLK, RST=>RST_n, D=>VIN, Q=>VIN_reg1);
	
FF2:
	FF port map (CLK=>CLK, RST=>RST_n, D=>VIN_reg1, Q=>VOUT);

SUB1:
	SUBTRACT 	generic map ( Nbit=> 14)
				port map (a=> sig1, b=>sig8, result=>sig2);

sig8<=sig8_trunc8 & "000000";
	
SUM1:
	ADD 	generic map ( Nbit=> 7)
			port map (a=> sig6_trunc7, b=>sig7_trunc7, sum=>sig8_trunc8);

SUM2:
	ADD 	generic map ( Nbit=> 7)
			port map (a=> sig9_trunc7, b=>sig10_trunc7, sum=>sig11_trunc8);

sig12_trunc8 <= sig12_trunc7 & "0";
	
SUM3:
	ADD 	generic map ( Nbit=> 8)
			port map (a=> sig11_trunc8, b=>sig12_trunc8, sum=>sig13_trunc9);

sig14_trunc9 <= sig14_trunc7 & "00";
	
SUM4:
	ADD 	generic map ( Nbit=> 9)
			port map (a=> sig13_trunc9, b=>sig14_trunc9, sum=>sig15_trunc10);

sig15 <= sig15_trunc10 & "0000";
	
MULT1:
	MULT generic map (SHAMT=> 20)
	port map (am=>siga2, bm=>sig4, mult =>sig7_trunc7);
	
MULT2:
	MULT generic map (SHAMT=> 20)
	port map (am=>siga3, bm=>sig5, mult =>sig6_trunc7);
	
MULT3:
	MULT generic map (SHAMT=> 20)
	port map (am=>sigb3, bm=>sig5, mult =>sig9_trunc7);
	
MULT4:
	MULT generic map (SHAMT=> 20)
	port map (am=>sigb2, bm=>sig4, mult =>sig10_trunc7);
	
MULT5:
	MULT generic map (SHAMT=> 20)
	port map (am=>sigb1, bm=>sig3, mult =>sig12_trunc7);

MULT6:
	MULT generic map (SHAMT=> 20)
	port map (am=>sigb0, bm=>sig2, mult =>sig14_trunc7);
	
REG0:
	REG port map (CLK=>CLK, RST=>RST_n,ENABLE =>VIN, D=>sig2, Q=>sig3);
	
REG1:
	REG port map (CLK=>CLK, RST=>RST_n,ENABLE =>VIN, D=>sig3, Q=>sig4);
	
REG2:
	REG port map (CLK=>CLK, RST=>RST_n,ENABLE =>VIN, D=>sig4, Q=>sig5);

--Registers for the coefficients         
--Va fatto il REGNOEN parametrico, i nuovi coeffs avranno bit widths diverse
REGb0:
	REGNOEN port map (CLK=>CLK, RST=>RST_n, D=>b0, Q=>sigb0);

REGb1:
	REGNOEN port map (CLK=>CLK, RST=>RST_n, D=>b1, Q=>sigb1);

REGb2:
	REGNOEN port map (CLK=>CLK, RST=>RST_n, D=>b2, Q=>sigb2);

REGb3:
	REGNOEN port map (CLK=>CLK, RST=>RST_n, D=>b3, Q=>sigb3);

REGa2:
	REGNOEN port map (CLK=>CLK, RST=>RST_n, D=>a2, Q=>siga2);

REGa3:
	REGNOEN port map (CLK=>CLK, RST=>RST_n, D=>a3, Q=>siga3);

END Structure;
